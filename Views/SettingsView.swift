import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}

struct SettingsView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    @State private var userDetails: String = ""
    @State private var isEditing: Bool = false
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Lista di elementi
    @State private var items = [
        Item(name: "Food", isSelected: false),
        Item(name: "Culture", isSelected: false),
        Item(name: "Relax", isSelected: false),
        Item(name: "Adventure", isSelected: false),
        Item(name: "By Night", isSelected: false)
    ]
    
    // Lista di interi per tenere traccia delle selezioni
    @State private var selections = [0, 0, 0, 0, 0] // Inizialmente tutte a 0
    @State private var navigateToHome = false
    @State private var showLogoutAlert = false
    @State private var showPreferencesInfo = false // Nuovo stato per mostrare/nascondere il testo
    let us = UserService()

    var body: some View {
        var user = us.getUser(username: logUsername)
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showLogoutAlert = true
                }, label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                })
                .padding(.leading, -60)
                .padding(.top, 5)
                .alert(isPresented: $showLogoutAlert) {
                    Alert(
                        title: Text("Logout"),
                        message: Text("Are you sure you want to exit the application?"),
                        primaryButton: .destructive(Text("Yes")) {
                            logout()
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }
            }
            
            let letter = logUsername.first?.lowercased()
        
            Image(systemName: "\(letter!).circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text(logUsername)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            
            HStack {
                Spacer()
                Button(action: {
                    if isEditing {
                        saveUserDetails()
                    }
                    isEditing.toggle()
                }) {
                    Image(systemName: isEditing ? "pencil.circle.fill" : "pencil.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isEditing ? .blue : .gray)
                }
                .padding(.trailing, -50)
                
                // Blocco per i dettagli dell'utente
                ScrollView {
                    //TODO: Impostare il valore di default dei dettagli dell'utente
                    TextField("Details", text: $userDetails)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .disabled(!isEditing)
                }
                .padding(.horizontal, 35)
                .frame(height: 60)
            }
            .padding(.leading, 20)
            .padding(.bottom)
            
            Text("Preferences")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 21 / 255, green: 68 / 255, blue: 171 / 255))
                .padding(.trailing, 190)

            
            Text("This section provides insights on how your preferences personalize itineraries to better match your interests and travel needs.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
                .transition(.scale)
                .padding([.leading, .trailing])
                .padding(.top, -20)
            
            
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
                            .onTapGesture {
                                items[index].isSelected.toggle()
                                selections[index] = items[index].isSelected ? 1 : 0
                            }
                            .padding(.leading, 10)
                    }
                    .frame(height: 30)
                    .alignmentGuide(.leading) { d in d[.leading] }
                }
            }
            .scrollContentBackground(.hidden)
            .padding(.top, -20)
            .padding(.trailing)
            
            Button(action: {
                savePreference(preferences: selections)
            }) {
                HStack {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.top, -7)
                        Text("Save Preference")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSaving ? Color.gray : Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Saved Preferences"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                EmptyView()
            }
        }
        .padding(.top, -20)
        .onAppear{
            loadPreferences()
            userDetails = us.getUser(username: logUsername)!.details!
        }
    }

    public func logout() {
        isLoggedIn = false
        navigateToHome = true
    }
    
    public func savePreference(preferences: [Int]) {
            var loggedUser = us.getUser(username: logUsername)
            loggedUser!.preferences = preferences
            loggedUser!.recommended = generateRoutes(preferences: preferences, numberSteps: 5, currentNumber: 5)
        print(loggedUser!.recommended.count)
            
            if us.setUser(user: loggedUser!) {
                print("Preferenze dell'utente \(logUsername) modificate")
                alertMessage = "Your preferences have been updated. Check out the new suggested routes!"
                showAlert = true
            } else {
                print("Errore nella modifica delle preferenze")
                alertMessage = "An error occurred while saving your preferences."
                showAlert = true
            }
        }
    
    public func saveUserDetails(){
        if var loggedUser = us.getUser(username: logUsername){
            loggedUser.details = userDetails
            print(userDetails)
            if us.setUser(user: loggedUser){
                print("Dettagli dell'utente \(logUsername) modificati")
            } else {
                print("Errore nella modifica dei dettagli")
            }
        }
    }

    public func loadPreferences() {
        if let loggedUser = us.getUser(username: logUsername) {
            selections = loggedUser.preferences // Carica le preferenze salvate
            for index in items.indices {
                items[index].isSelected = selections[index] == 1 // Aggiorna la selezione degli elementi
            }
        }
    }
}

extension SettingsView {
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

    /// Generazione automatica degli itinerari sulla base delle preferenze dell'utente
    func generateRoutes(preferences: [Int], numberSteps: Int, currentNumber: Int) -> [Route] {
        let categories = ["Culture", "Food", "By Night", "Relax", "Adventure"]
        let areAllPreferencesZero = preferences.allSatisfy { $0 == 0 }
        let rs = RouteService()
        var generatedRoutes: [Route] = []

        // Funzione helper per prendere step da una route
        func getSteps(from category: String, maxSteps: Int) -> [Step] {
            guard let randomRoute = rs.readRoutes(forCategory: category).randomElement() else { return [] }
            return Array(randomRoute.steps.prefix(maxSteps))
        }
        
        if areAllPreferencesZero {
            // Se tutte le preferenze sono 0, genera itinerari casuali da tutte le categorie
            for category in categories {
                let stepsToAdd = getSteps(from: category, maxSteps: numberSteps)
                if !stepsToAdd.isEmpty {
                    let route = Route(name: "Random route from \(category)",
                                      steps: stepsToAdd,
                                      start_time: "07:00",
                                      end_time: "23:00",
                                      description: "Generated for you",
                                      category: category,
                                      image: stepsToAdd.first?.image ?? "")
                    generatedRoutes.append(route)
                }
            }
        } else {
            // Genera itinerari solo per le categorie selezionate
            let selectedCategories = categories.enumerated()
                .filter { preferences[$0.offset] == 1 }
                .map { $0.element }
            
            for i in 0..<currentNumber {
                var currentRoute = Route(name: "Your \(i+1)-th daily route",
                                         steps: [],
                                         start_time: "07:00",
                                         end_time: "23:00",
                                         description: "A daily proposal for you",
                                         category: "Mixed")
                
                // Raccogliere step da categorie selezionate fino a riempire numberSteps
                var remainingSteps = numberSteps
                
                for category in selectedCategories {
                    let stepsToAdd = getSteps(from: category, maxSteps: remainingSteps)
                    currentRoute.steps.append(contentsOf: stepsToAdd)
                    remainingSteps -= stepsToAdd.count
                    if remainingSteps <= 0 { break }
                }
                
                if !currentRoute.steps.isEmpty {
                    currentRoute.image = currentRoute.steps.first?.image ?? ""
                    generatedRoutes.append(currentRoute)
                }
            }
        }
        
        return generatedRoutes
    }
}

#Preview {
    SettingsView()
}

