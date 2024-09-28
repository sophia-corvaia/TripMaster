//
//  UserView.swift
//  TripMaster
//
//  Created by Sophia on 16/09/24.
//

import SwiftUI

struct UserView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    let us = UserService()
    @State var user_liked: [Route] = []
    @State var user_recommended: [Route] = []
    @State private var isPresented_l: Bool = false
    @State private var isPresented_r: Bool = false
    @State private var selectedRoute_l: Route? // Variabile per memorizzare la route selezionata
    @State private var selectedRoute_r: Route? // Variabile per memorizzare la route selezionata


    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 5)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Travels")
                            .padding(.horizontal)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        
                        NavigationLink(destination: SettingsView()) {
                            HStack {
                                let letter = logUsername.first?.lowercased()
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 60, height: 60)

                                    Image(systemName: "\(letter!).circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.blue) 
                                }
                            }
                        }.padding(.leading, 139)
                    }.padding()
                    
                    ScrollView {
                        VStack {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                                
                                Text("Liked")
                                    .padding(.horizontal)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            .padding(.trailing, 230)
                            
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    ForEach($user_liked, id: \.name) { $route in
                                        Button(action: {
                                            selectedRoute_l = route // Imposta la route selezionata

                                                isPresented_l.toggle()
                                            }) {
                                                VStack(alignment: .leading) {
                                                    Image(route.image!)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 150, height: 150)
                                                        .cornerRadius(10)
                                                        .padding(.leading, 15)
                                                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                                                    HStack {
                                                        Spacer()
                                                        Text(insertLineBreaks(in: route.name, maxLength: 17))
                                                            .foregroundColor(.black)
                                                            .font(.headline)
                                                            .padding(.leading, 12)
                                                            .padding(.bottom, 5)
                                                            .frame(maxWidth: 230, alignment: .leading)
                                                            .lineLimit(nil)
                                                        Spacer()
                                                    }
                                                }
                                            }
                                            .sheet(isPresented: $isPresented_l) {
                                                if let selectedRoute = selectedRoute_l {
                                                    // Usa .constant per non passare un Binding opzionale
                                                    DetailRouteView(route: .constant(selectedRoute))
                                                }
                                            }
                                        
                                    }
                                }//HSTACK
                            }//SCROLLVIEW OR
                            .padding([.top, .bottom, .trailing, .leading])
                            
                            HStack {
                                Image(systemName: "figure.walk")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                                
                                Text("Recommended")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            .padding(.trailing, 170)
                            
                            
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    ForEach($user_recommended, id: \.name) { $route in
                                        Button(action: {
                                            selectedRoute_r = route // Imposta la route selezionata
                                                isPresented_r.toggle()
                                            }) {
                                                VStack(alignment: .leading) {
                                                    Image(route.image!)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 150, height: 150)
                                                        .cornerRadius(10)
                                                        .padding(.leading, 15)
                                                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                                                    HStack {
                                                        Spacer()
                                                        Text(insertLineBreaks(in: route.name, maxLength: 17))
                                                            .foregroundColor(.black)
                                                            .font(.headline)
                                                            .padding(.leading, 12)
                                                            .padding(.bottom, 5)
                                                            .frame(maxWidth: 230, alignment: .leading)
                                                            .lineLimit(nil)
                                                        Spacer()
                                                    }
                                                }
                                            }
                                            .sheet(isPresented: $isPresented_r) {
                                                if let selectedRoute = selectedRoute_r {
                                                    // Usa .constant per non passare un Binding opzionale
                                                    DetailRouteView(route: .constant(selectedRoute))
                                                }
                                            }
                                    }
                                }//HSTACK
                            }
                            .padding([.top, .bottom, .trailing, .leading])
                        }
                        
                    }.onAppear{
                        let logUser = us.getUser(username: logUsername)
                        user_liked = logUser!.liked
                        user_recommended = logUser!.recommended
                    }
                    
                }
            }
        }
    }
    
    func insertLineBreaks(in text: String, maxLength: Int) -> String {
        var result = ""
        var currentLength = 0
        
        // Split the text into words
        let words = text.split(separator: " ")
        
        for word in words {
            if currentLength + word.count + 1 > maxLength { // +1 for space
                result += "\n" // Add a line break if it exceeds the max length
                currentLength = 0 // Reset the current length
            } else if currentLength > 0 {
                result += " " // Add space before the word if not at the start
            }
            
            result += word
            currentLength += word.count + (currentLength > 0 ? 1 : 0) // Update the length
        }
        
        return result
    }
}

#Preview {
    UserView()
}
