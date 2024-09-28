//
//  RegistrationView.swift
//  TripMaster
//
//  Created by Sophia on 22/09/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isRegistered: Bool = false // Variabile per tracciare la registrazione
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    var us = UserService()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Image("logo_tm")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                    Spacer()
                }
                Text("Join TripMaster").font(.largeTitle)

                // Username TextField with validation
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .onChange(of: username) { newValue in
                        // Limit to 10 characters and allow only a-z, A-Z, 0-9
                        let filtered = newValue.filter { $0.isLetter || $0.isNumber }
                        if filtered.count > 10 {
                            username = String(filtered.prefix(10))
                        } else {
                            username = filtered
                        }
                    }

                // Password SecureField with validation
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                // Confirm Password SecureField
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                // Show error message if any validation fails
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                }

                // Sign Up button
                Button(action: {
                    register()
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                
                // Navigation to HomeView if registration is successful
                NavigationLink(destination: HomeView(), isActive: $isRegistered) {
                    EmptyView()
                }
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
        }
        .navigationBarBackButtonHidden(true)

    }

    // Funzione di registrazione con validazione
    func register() {
        // Controllo che tutti i campi siano compilati
        guard !username.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Fill in all fields."
            showError = true
            return
        }

        // Verifica se le password corrispondono
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showError = true
            return
        }

        // Se tutto è valido, nascondi l'errore e registra l'utente
        showError = false
        var new_user = User(username: username, password: password, details: "Hi! I'm joining TripMaster.", image: "")
        new_user.recommended = generateRoutes()
        if us.setUser(user: new_user) {
            print("Registrazione riuscita per: \(username)")
            isRegistered = true
            isLoggedIn = true
            logUsername = username
        } else {
            errorMessage = "Registration failed. Try again."
            showError = true
        }
    }
}

extension RegistrationView {

    /// Generazione automatica degli itinerari sulla base delle preferenze dell'utente (in fase di registrazione)
    func generateRoutes() -> [Route] {
        let categories = ["Culture", "Food", "By Night", "Relax", "Adventure"]
        let rs = RouteService()
        var generatedRoutes: [Route] = []

        for category in categories {
            let randomRoute = rs.readRoutes(forCategory: category).randomElement()
            generatedRoutes.append(randomRoute!)
        }
        
        return generatedRoutes
    }
}

#Preview {
    RegistrationView()
}
