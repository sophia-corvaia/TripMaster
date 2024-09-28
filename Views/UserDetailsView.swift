import SwiftUI

struct UserDetailsView: View {
    @Binding var user: User
    var us = UserService()
    @State private var items = [
        Item(name: "Food", isSelected: false),
        Item(name: "Culture", isSelected: false),
        Item(name: "Relax", isSelected: false),
        Item(name: "Adventure", isSelected: false),
        Item(name: "By Night", isSelected: false)
    ]
    @State private var selections = [0, 0, 0, 0, 0] // Inizialmente tutte a 0

    var body: some View {
        VStack {
            let letter = user.username.first?.lowercased()
        
            Image(systemName: "\(letter!).circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            HStack {
                Spacer()
                Text(user.username)
                    .font(.title)
                Spacer()
            }
            .padding(.bottom)
            
            // Blocco per i dettagli dell'utente
            ScrollView {
                Text(user.details ?? "N/A") 
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 35)
            .frame(height: 100)
            
            VStack {
                Text("Preferences")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 21 / 255, green: 68 / 255, blue: 171 / 255))
                    .padding(.trailing, 200)
                    .padding(.top)
                
                List {
                    let icon_names = ["fork.knife", "building.columns", "sparkles", "safari", "wineglass"]
                    ForEach(0..<items.count) { index in
                        HStack {
                            Image(systemName: icon_names[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                            
                            Text(items[index].name)
                                .fontWeight(items[index].isSelected ? .bold : .light)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image(systemName: items[index].isSelected ? "checkmark.square" : "square")
                                .foregroundColor(items[index].isSelected ? .blue : .gray)
                                .padding(.leading, 10)
                        }
                        .frame(height: 30)
                        .alignmentGuide(.leading) { d in d[.leading] }
                    }
                }
                .scrollContentBackground(.hidden)
                .padding(.top, -40)
                .padding(.trailing)
            }
            .padding(.top)
        }
        .padding(.top, 50)
        .onAppear {
            loadPreferences() // Carica le preferenze quando la vista appare
        }
    }
    
    public func loadPreferences() {
        if let currentUser = us.getUser(username: user.username) {
            selections = currentUser.preferences
            for index in items.indices {
                items[index].isSelected = selections[index] == 1
            }
        }
    }
}

#Preview {
    UserDetailsView(user: .constant(User(username: "sophy0295", password: "", preferences: [1, 0, 0, 1, 1], details: "Ciao! Sono un amante dei viaggi e delle avventure in giro per il mondo. La mia passione per l’esplorazione è nata fin da giovane, quando ho scoperto che ogni luogo ha una storia da raccontare e una cultura da scoprire. Che si tratti di scoprire le meraviglie naturali delle montagne, di immergermi nella storia affascinante delle città antiche o di assaporare i piatti tipici in un mercato locale, ogni viaggio rappresenta per me un’opportunità unica per crescere e imparare.Amo condividere le mie esperienze attraverso foto e racconti, ispirando gli altri a uscire dalla propria zona di comfort e a scoprire il mondo. Ho visitato tanti paesi e ogni meta ha arricchito il mio spirito e la mia prospettiva sulla vita. Che si tratti di un weekend in una città vicina o di un lungo viaggio in un continente lontano, non vedo l’ora di scoprire dove mi porterà la prossima avventura!", liked: [], recommended: [])))
}
