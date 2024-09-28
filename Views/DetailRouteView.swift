import SwiftUI

struct DetailRouteView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    @Binding var route: Route
    @State private var expandedItems: [Bool] = Array(repeating: false, count: 10)
    @State private var isLiked = false
    var us = UserService()

    var body: some View {
        VStack {
            ZStack {
                Image(route.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .colorMultiply(Color(red: 159 / 255, green: 200 / 255, blue: 216 / 255, opacity: 0.7))
                    .opacity(0.8)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    .clipped()
                
                HStack {
                    ZStack {
                        VStack(alignment: .center) {
                            Text(route.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 21 / 255, green: 68 / 255, blue: 171 / 255))
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text(route.description!)
                                .font(.footnote)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 350)
                        .frame(maxWidth: .infinity)
                        
                        if isLoggedIn {
                            Button(action: {
                                isLiked.toggle()
                                addToLiked(liked: route, add: isLiked)
                            }) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(red: 21 / 255, green: 68 / 255, blue: 171 / 255))
                            }
                            .padding(.top, -120)
                            .padding(.leading, 280)
                        }
                    }
                }
            }
            .padding(.top, -70)
            .ignoresSafeArea(edges: .top)
            
            VStack {
                Text("Start: ").bold() + Text("\(route.start_time) - ") + Text("End: ").bold() + Text("\(route.end_time)")
            }
            .padding(.top, 20)
            .padding(.bottom, -30)
            
            VStack {
                List {
                    ForEach($route.steps.indices, id: \.self) { index in
                        VStack {
                            HStack {
                                Image(route.steps[index].image!)
                                    .resizable()
                                    .cornerRadius(10)
                                    .frame(width: 80, height: 80)
                                
                                Text(route.steps[index].name)
                                    .font(.headline)
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        expandedItems[index].toggle()
                                    }
                                }) {
                                    Image(systemName: expandedItems[index] ? "chevron.up" : "chevron.down")
                                }
                            }
                            
                            // Descrizione a scomparsa
                            if expandedItems[index] {
                                let text_description = "Opening hour: \(route.steps[index].open_time!)\nClosing hour: \(route.steps[index].closing_time!)\n\n\(route.steps[index].description!)"
                                Text(text_description)
                                    .font(.subheadline)
                                    .transition(.slide)
                                    .padding(.trailing, 70)
                            }
                        }
                        .padding(.vertical, -2)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .padding(.top, 30)
            .padding(.horizontal, -20)
        }
        .padding()
        .onAppear {
            if let user = us.getUser(username: logUsername) {
                isLiked = user.liked.contains { $0.name == route.name }
            }
        }
    }
}

extension DetailRouteView {
    public func addToLiked(liked: Route, add: Bool) {
        if var loggedUser = us.getUser(username: logUsername) {
            if add { // aggiungi alla lista di preferiti
                loggedUser.liked.append(liked)
            } else { // rimuovi dalla lista di preferiti
                loggedUser.liked.removeAll { $0.name == liked.name }
            }
            if us.setUser(user: loggedUser) {
                print("Dettagli dell'utente \(logUsername) modificati")
            } else {
                print("Errore nella modifica dei dettagli")
            }
        }
    }
}

#Preview {
    DetailRouteView(route: .constant(Route(name: "Itinerario 1", steps:
                                            [Step(name: "tappa 1", open_time: "8:00", closing_time: "15:00", description: "Questa è la prima tappa del tuo viaggio", image: "sea"),
                                             Step(name: "tappa 2", open_time: "8:00", closing_time: "15:00", description: "Questa è la seconda tappa del tuo viaggio", image: "teatro_massimo"),
                                             Step(name: "tappa 3", open_time: "8:00", closing_time: "15:00", description: "Questa è la terza tappa del tuo viaggio", image: "sea"),
                                             Step(name: "tappa 4", open_time: "8:00", closing_time: "15:00", description: "Questa è la quarta tappa del tuo viaggio", image: "surf"),]
                                           ,  start_time: "08:00", end_time: "23:00", description: "Consigliato per 3 persone", category: "Culture", image: "piazza_marina")))
}
