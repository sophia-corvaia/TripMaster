//
//  LoginView.swift
//  TripMaster
//
//  Created by Sophia on 22/09/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    let us = UserService()

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
                Text("Sign In to TripMaster")
                    .font(.largeTitle)
                    .padding(.bottom, 40)
                
                // Username TextField
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                // Password SecureField
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                // Sign In button
                Button(action: {
                    login()
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .padding(.bottom, 20)
                
                // Show error message if login fails
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                }
                
                // Disclaimer: "Don't have an account? Sign up"
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: RegistrationView()) {
                        Text("Sign up")
                            .foregroundColor(.blue)
                            .bold()
                    }
                }
                .padding(.top, 20)
                
                // Navigation to HomeView if login is successful
                NavigationLink(destination: HomeView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
        }
    }

    // Funzione di autenticazione simulata
    func login() {
        // Simulazione della verifica delle credenziali (in un'app reale, utilizza un'API o un sistema di autenticazione)
        let user = us.getUser(username: username)
        if username == user?.username && password == user?.password {
            isLoggedIn = true // Se il login è corretto, naviga verso la HomeView
            logUsername = username // Salva il nome utente in AppStorage
        } else {
            // Mostra un errore se le credenziali non sono corrette
            errorMessage = "Invalid username or password."
            showError = true
        }
    }
}

#Preview {
    LoginView()
}
