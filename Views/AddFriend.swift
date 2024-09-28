import SwiftUI

struct AddFriend: View {
    @State private var searchText = ""
    @State private var isPresented = false
    @State private var selectedUser: User?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) var dismiss
    var us = UserService()
    let fs = FriendService()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    
    @State private var allUsers: [User] = []
    
    let colors: [Color] = [
            .red, .green, .blue, .yellow, .orange, .purple, .pink, .teal, .indigo,
            .brown, .cyan, .mint, .gray, .black,
        ]
    
    var randomColor: Color {
        colors.randomElement() ?? .blue // Nel caso non ci siano colori, default a .blue
    }

    var filteredItems: [User] {
        if searchText.isEmpty {
            return allUsers
        } else {
            return allUsers.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Barra di ricerca
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding([.top, .bottom])
                
                // Griglia degli elementi
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredItems, id: \.username) { item in
                            VStack {
                                VStack {
                                    ZStack {
                                        let letter = item.username.first?.lowercased()
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 80, height: 80)
                                        
                                        Image(systemName: "\(letter!).circle.fill")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .foregroundColor(randomColor)
                                    }

                                    
                                    Text(item.username)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .padding(.top, 5)
                                }
                                
                                Button(action: {
                                    addNewFriend(friend_username: item.username)
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(.white)
                                        
                                        Text("Add")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Add new friends")
            .alert(isPresented: $showAlert) { // Alert per informare l'utente
                Alert(
                    title: Text("Friend Added"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                let friends = fs.readFriend(username: logUsername)
                let friendUsernames = Set(friends.map { $0.username })
                let nonFriends = us.readUsers().filter { !friendUsernames.contains($0.username) && $0.username != logUsername }
                allUsers = nonFriends
            }
        }
        .padding()
    }
    
    public func addNewFriend(friend_username: String) {
        let existing_friend = fs.getFriend(username: friend_username)
        if (existing_friend?.friend_of == logUsername) {
            alertMessage = "\(friend_username) is already in your friend list"
            showAlert = true
            return
        }

        let friend_me = Friend(username: friend_username, friend_of: logUsername)
        let friend_of = Friend(username: logUsername, friend_of: friend_username)

        if fs.setFriend(friend: friend_me) {
            if fs.setFriend(friend: friend_of) {
                alertMessage = "\(friend_username) has been added to your friends!"
                showAlert = true
            } else {
                fs.removeFriend(username: friend_me.username)
                alertMessage = "Error adding \(friend_username) to your friends."
                showAlert = true
            }
        } else {
            alertMessage = "Error adding \(friend_username) to your friends."
            showAlert = true
        }
    }
}

// Custom SearchBar view
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    AddFriend()
}
