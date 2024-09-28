import SwiftUI

struct GroupCreateView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    @State private var fs = FriendService()
    @State private var gs = GroupService()
    @State private var us = UserService()
    @State private var groupName = ""
    @State private var selectedFriends = Set<String>()
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var friends: [Friend] = []
    @State private var isCreating: Bool = false // Stato per gestire il caricamento

    var body: some View {
        NavigationView {
                VStack {
                    Text("Create new group")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    
                    TextField("Insert name", text: $groupName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onTapGesture {
                            hideKeyboard() // Nasconde la tastiera al tocco fuori dal TextField
                        }
                    
                    Text("Select members")
                        .font(.title3)
                        .bold()
                        .padding(.trailing, 150)
                    
                    let allFriends = friends.filter { $0.username != logUsername }
                    
                    VStack {
                        if allFriends.isEmpty {
                            Text("You need to add some friend first")
                                .foregroundColor(.red) // Colore del testo per evidenziarlo
                                .font(.headline)
                                .padding()
                        }
                        
                        List(allFriends, id: \.id) { friend in
                            Button(action: {
                                if selectedFriends.contains(friend.username) {
                                    selectedFriends.remove(friend.username)
                                } else {
                                    selectedFriends.insert(friend.username)
                                }
                            }) {
                                HStack {
                                    Image(systemName: selectedFriends.contains(friend.username) ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundColor(selectedFriends.contains(friend.username) ? .blue : .gray)
                                        .font(.title)
                                    
                                    Text(friend.username)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 260)
                    
                    Spacer()
                    
                    Button(action: {
                        // Inizia il caricamento
                        isCreating = true
                        DispatchQueue.global(qos: .background).async {
                            let success = validateGroup()
                            DispatchQueue.main.async {
                                if success {
                                    // Naviga indietro dopo aver creato il gruppo
                                    dismiss()
                                }
                                isCreating = false // Termina il caricamento
                            }
                        }
                    }) {
                        Text("Create")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top, 50)
                    }
                    
                    /*NavigationLink(destination: GroupView(), isActive: $isCreating) {
                     EmptyView()
                     }*/
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .overlay {
                    // Mostra un indicatore di attività durante il caricamento
                    if isCreating {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView("Creating group...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2) // Modifica la dimensione dell'indicatore
                            .foregroundColor(.white)
                    }
                }
                .onAppear {
                    friends = fs.readFriend(username: logUsername).filter { $0.username != logUsername }
                }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func validateGroup() -> Bool {
        var result = false
        if groupName.isEmpty {
            alertMessage = "Please enter a group name."
            showAlert = true
        } else if selectedFriends.isEmpty {
            alertMessage = "Please select at least one friend."
            showAlert = true
        } else {
            result = saveGroup()
        }
        return result
    }

    func saveGroup() -> Bool {
        var members: [User] = []
        for selection in selectedFriends {
            if let r_user = us.getUser(username: selection) {
                members.append(r_user)
            }
        }
        members.append(us.getUser(username: logUsername)!)
        var new_group = TravelGroup(name: groupName, image: "", members: members, group_routes: [])

        let numberOfRoutes = 4
        for index in 0..<numberOfRoutes { //creo direttamente le rotte personalizzate
            let newRoute = generateRoute(group: new_group, description: "Your \(index + 1)th mixed route for \(new_group.name)", currentNumber: index + 1)
            new_group.group_routes.append(newRoute)
        }

        print(new_group)
        if gs.setGroup(group: new_group) { //salvo il gruppo
            print("Aggiunta del gruppo \(groupName) riuscita!")
            return true
        } else {
            print("Errore nel salvataggio del gruppo \(groupName)!")
        }
        return false
    }
}

extension GroupCreateView {
    func generateCategories(from lists: [[Int]], categories: [String], totalElements: Int) -> [String] {
        var categoryCounts = Array(repeating: 0, count: categories.count)

        for list in lists {
            for (index, value) in list.enumerated() {
                if value == 1 {
                    categoryCounts[index] += 1
                }
            }
        }
        let totalOnes = categoryCounts.reduce(0, +)
        var result: [String] = []
        
        for (index, count) in categoryCounts.enumerated() {
            let proportion = Int(Double(count) / Double(totalOnes) * Double(totalElements))
            result.append(contentsOf: Array(repeating: categories[index], count: proportion))
        }

        while result.count < totalElements {
            let randomCategory = categories.randomElement()!
            result.append(randomCategory)
        }

        return result
    }

    /// Generazione automatica degli itinerari sulla base delle preferenze dei membri
    func generateRoute(group: TravelGroup, description: String, currentNumber: Int) -> Route {
        var preferences: [[Int]] = []
        
        for member in group.members { // per ogni membro del gruppo
            preferences.append(member.preferences) // colleziona le preferenze degli utenti
        }
        
        let categories = ["Culture", "Food", "By Night", "Relax", "Adventure"]
        
        // Controllo se tutte le preferenze sono a 0
        let areAllPreferencesZero = preferences.allSatisfy { $0.allSatisfy { $0 == 0 } }
        
        let generatedCategories: [String]
        
        if areAllPreferencesZero {
            let rs = RouteService()
            let randomCategory = categories.randomElement() ?? "Food" // Seleziona una categoria casuale
            let random_route = rs.readRoutes(forCategory: randomCategory).randomElement()
            
            var generatedRoute = Route(name: "\(group.name) \(currentNumber)-th - \(randomCategory)", steps: [], start_time: "07:00", end_time: "23:00", description: description, category: randomCategory, image: "")
            
            if let randomRoute = random_route {
                generatedRoute.steps = randomRoute.steps
                generatedRoute.image = randomRoute.image
            }
            
            return generatedRoute
        } else {
            // Se ci sono preferenze valide, genera le categorie
            generatedCategories = generateCategories(from: preferences, categories: categories, totalElements: 6)
            var generatedRoute = Route(name: "\(group.name) \(currentNumber)-th - \(generatedCategories[0])", steps: [], start_time: "07:00", end_time: "23:00", description: description, category: generatedCategories[0], image: "")
            let rs = RouteService()
            
            for category in generatedCategories {
                let random_route = rs.readRoutes(forCategory: category).randomElement()
                let random_step = (random_route?.steps.randomElement())!
                generatedRoute.steps.append(random_step)
            }
            generatedRoute.image = generatedRoute.steps.randomElement()?.image
            
            return generatedRoute
        }
    }
}

#Preview {
    GroupCreateView()
}
