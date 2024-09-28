import SwiftUI

struct GroupView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    @State private var searchFriend = ""
    @State private var selectedUser: User?
    @State private var showUserDetails = false
    @State private var isPresented = false
    @State private var isGroupPresented = false
    @State private var isFriendShowed = false
    @State private var us = UserService()
    @State private var fs = FriendService()
    @State private var gs = GroupService()
    @State private var friends: [Friend] = []
    @State private var groupes: [TravelGroup] = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let colors: [Color] = [
            .red, .green, .blue, .yellow, .orange, .purple, .pink, .teal, .indigo,
            .brown, .cyan, .mint, .gray, .black,
        ]
    
    var randomColor: Color {
        colors.randomElement() ?? .blue // Nel caso non ci siano colori, default a .blue
    }
    
    var friendPadding: CGFloat {
        if friends.isEmpty {
            return 20
        } else {
            return 0
        }
    }
    
    var groupPadding: CGFloat {
        if groupes.isEmpty {
            return 0
        } else {
            return -5
        }
    }
    
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
                        Text("Groups")
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
                        }
                        .padding(.leading, 137)
                    }
                    .padding()
                    
                    ScrollView {
                        HStack {
                            Image(systemName: "shared.with.you")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                            
                            Text("Friends")
                                .padding(.horizontal)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .padding(.leading, -160)
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                            LazyHGrid(rows: Array(repeating: .init(.flexible()), count: 2), spacing: 15) {
                                VStack {
                                    Spacer()
                                    NavigationLink(destination: AddFriend()) {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                            .foregroundColor(.white)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Text("")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding(.top, 4)
                                    .frame(maxWidth: .infinity)
                                }
                                
                                @State var allFriends = friends.filter { $0.username != logUsername }
                                
                                ForEach($allFriends, id: \.username) { $friend in
                                    VStack {
                                        let letter = friend.username.first?.lowercased()
                                        
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
                                            Text(friend.username)
                                                .foregroundColor(.black)
                                                .font(.headline)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                            .padding(.top, friendPadding)
                            .padding(.leading, 40)
                        }
                        
                        HStack {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                            
                            Text("Your groups")
                                .padding(.horizontal)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .padding(.leading, -100)
                        .padding(.top, 50)
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                            LazyHGrid(rows: Array(repeating: .init(.flexible()), count: 2), spacing: 15) {
                                VStack {
                                    Spacer()
                                    NavigationLink(destination: GroupCreateView()) {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                            .foregroundColor(.white)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                                    }//.padding(.top, 10)
                                    
                                    HStack {
                                        Spacer()
                                        Text("")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding(.top, -3)
                                    .frame(maxWidth: .infinity)
                                }
                                
                                @State var allFriends = friends.filter { $0.username != logUsername }
                                
                                ForEach($groupes, id: \.name) { $group in
                                    NavigationLink(destination: GroupDetailView(group: $group)) {
                                        VStack {
                                            let initials: String = {
                                                let words = group.name.split(separator: " ")
                                                let initials = words.map { String($0.prefix(1)) }.prefix(2).joined()
                                                return initials.uppercased()
                                            }()
                                            
                                            ZStack {
                                                Circle()
                                                    .fill(randomColor)
                                                    .frame(width: 80, height: 80)

                                                Text(initials)
                                                    .font(.system(size: 30, weight: .bold))
                                                    .frame(width: 80, height: 80)
                                                    .foregroundColor(.white)
                                            }

                                            HStack {
                                                Spacer()
                                                Text(group.name.lowercased())
                                                    .foregroundColor(.black)
                                                    .font(.headline)
                                                Spacer()
                                            }
                                            .frame(maxWidth: .infinity)
                                        }
                                    }
                                }
                            }
                            .padding(.top, friendPadding)
                            .padding(.leading, 40)
                        }.padding(.top)
                    }
                }
            }
            .onAppear {
                friends = fs.readFriend(username: logUsername).filter { $0.username != logUsername }
                groupes = gs.readGroups(username: logUsername)
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    GroupView()
}
