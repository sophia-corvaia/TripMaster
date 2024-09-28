//
//  GroupDetailView.swift
//  TripMaster
//
//  Created by Sophia on 20/09/24.
//

import SwiftUI

struct GroupDetailView: View {
    @Binding var group: TravelGroup
    var gs = GroupService()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    @State private var isEditing = false
    @State private var isPresented = false
    @State private var isShowing = false
    @State var routes: [Route] = []
    @State private var selectedRoute: Route? // Variabile per memorizzare la route selezionata

    
    let colors: [Color] = [
            .red, .green, .blue, .yellow, .orange, .purple, .pink, .teal, .indigo,
            .brown, .cyan, .mint, .gray, .black,
        ]
    
    var randomColor: Color {
        colors.randomElement() ?? .blue // Nel caso non ci siano colori, default a .blue
    }

    
    var body: some View {
        NavigationStack{
            VStack {
                
                Text(group.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, -10)
                
                ScrollView{
                    //Group image
                    //Image(image)
                    VStack {
                        let initials: String = {
                            let words = group.name.split(separator: " ")
                            let initials = words.map { String($0.prefix(1)) }.prefix(2).joined()
                            return initials.uppercased()
                        }()
                        
                        ZStack {
                            Circle()
                                .fill(randomColor)
                                .frame(width: 240, height: 220)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)

                            Text(initials)
                                .font(.system(size: 90, weight: .bold))
                                .frame(width: 240, height: 220)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack {
                        Text("Members")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 5)
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 5) {
                            
                            ForEach($group.members, id: \.username) { $member in
                                ZStack(alignment: .topTrailing) {
                                    let letter = member.username.first?.lowercased()
                                    VStack {
                                        
                                        ZStack {
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 80, height: 80)
                                            
                                            Image(systemName: "\(letter!).circle.fill")
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .foregroundColor(randomColor)
                                        }

                                        HStack {
                                            Spacer()
                                            Text(member.username)
                                                .foregroundColor(.black)
                                                .font(.headline)
                                                .multilineTextAlignment(.center)
                                            Spacer()
                                        }
                                    }
                                    .frame(width: 100)
                                    
                                    if isEditing {
                                        Button(action: {
                                            if let index = group.members.firstIndex(where: { $0.id == member.id }) {
                                                group.members.remove(at: index)
                                                if gs.setGroup(group: group) {
                                                    print("Aggiornamento del gruppo \(group.name) completata!")
                                                } else {
                                                    print("Errore nell'aggiornamneto del gruppo \(group.name)!")
                                                }
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                                .frame(width: 30, height: 30)
                                                .background(Color.white.opacity(0.8))
                                                .clipShape(Circle())
                                        }
                                        .offset(x: 5, y: 10)
                                        .zIndex(1)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    ForEach($routes, id: \.name) { $route in
                        Button(action: {
                            selectedRoute = route // Imposta la route selezionata
                            isPresented.toggle()   // Mostra il foglio
                        }) {
                            HStack {
                                Image(route.image!)
                                    .resizable()
                                    .cornerRadius(10)
                                    .frame(width: 80, height: 80)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)

                                VStack(alignment: .leading) {
                                    Text(route.name)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 21 / 255, green: 68 / 255, blue: 171 / 255))
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text(route.description!)
                                        .font(.footnote)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .sheet(isPresented: $isPresented) {
                            if let selectedRoute = selectedRoute {
                                // Usa .constant per non passare un Binding opzionale
                                DetailRouteView(route: .constant(selectedRoute))
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.leading, 25)
                    .padding(.top, 10)
                }
            }
            .padding(.top, 70)
            .ignoresSafeArea(edges: .top)
            .onAppear{
                routes = group.group_routes
            }
        }
    }
}


#Preview {
    GroupDetailView(group: .constant(TravelGroup(name: "Crazy Friends", members: [
        User(username: "support1", password: "password1", preferences: [1, 0, 1, 0, 1], details: "Supporto tecnico per problemi generali.", image: ""),
        User(username: "support2", password: "password2", preferences: [0, 1, 0, 1, 0], details: "Assistenza per questioni di pagamento.", image: ""),
        User(username: "support3", password: "password3", preferences: [1, 1, 0, 0, 1], details: "Supporto per l'uso dell'app.", image: ""),
        User(username: "support4", password: "password4", preferences: [0, 0, 1, 1, 0], details: "Consulenza per la gestione dell'account.", image: "")
    ], group_routes: [])))
}

