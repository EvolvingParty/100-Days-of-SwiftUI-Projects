//
//  ContentView.swift
//  Friends
//
//  Created by Kurt Lane on 3/1/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var cashedUsers: FetchedResults<CashedUser>
    
    @State private var allUsers: [User] = []
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private var sortOptions = ["A-Z", "Online"]
    @State private var sortMethod = "A-Z"
    
    @State private var searchText = ""
    
//    func sortUsers() {
//        allUsers.sort(by: {$0.name < $1.name} )
//    }
//
//    var searchResults: [User] {
//        if searchText.isEmpty {return allUsers}
//        else {
//            var usersToReturn = [User]()
//            for user in allUsers {
//                if user.name.lowercased().contains(searchText.lowercased()) {
//                    usersToReturn.append(user)
//                }
//            }
//            return usersToReturn
//        }
//    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if cashedUsers.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(cashedUsers) { user in
                            if sortMethod == "Online" {
                                if user.isActive {
                                    NavigationLink(destination: {
                                        UserView(allUsers: allUsers, selectedUser: user)
                                    }, label: {
                                        HStack {
                                            Text(user.isActive ? "🟢" : "⚪️")
                                            Text(user.name ?? "")
                                                .foregroundColor(user.isActive ? Color.primary : Color.primary.opacity(0.75))
                                                .font(.system(.title3, design: .rounded))
                                                .padding(.top, 1)
                                        }
                                    })
                                }
                            } else {
                                NavigationLink(destination: {
                                    UserView(allUsers: allUsers, selectedUser: user)
                                }, label: {
                                    HStack {
                                        Text(user.isActive ? "🟢" : "⚪️")
                                        Text(user.name ?? "")
                                            .foregroundColor(user.isActive ? Color.primary : Color.primary.opacity(0.75))
                                            .font(.system(.title3, design: .rounded))
                                            .padding(.top, 1)
                                    }
                                })
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("FriendFace")
            .onAppear(perform: { Task {await loadFriends()} })
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
                Button("Retry", role: .none) {
                    Task {await loadFriends()}
                }
            } message: {
                Text(alertMessage)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(sortOptions, id: \.self) { option in
                            Button {
                                sortMethod = option
                                //sortUsers()
                            } label: {
                                HStack {
                                    Text(option)
                                    if sortMethod == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }
    
    func loadFriends() async {
        if allUsers.isEmpty {
            if let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") {
                do {
                    let contents: [User] = try await URLSession.shared.decode(from: url)
                    //allUsers = contents
                    for friend in contents {
                        let newFriend = CashedUser(context: moc)
                        newFriend.id = friend.id
                        newFriend.name = friend.name
                        newFriend.isActive = friend.isActive
                        newFriend.name = friend.name
                        newFriend.age = Int16(friend.age)
                        newFriend.address = friend.address
                        newFriend.company = friend.company
                        newFriend.email = friend.email
                        newFriend.about = friend.about
                        newFriend.registered = friend.registered
                        var friendsString = ""
                        for friend in friend.friends {
                            friendsString += "\(friend.name),"
                        }
                        newFriend.friendIDs = friendsString
                        var tagsString = ""
                        for tag in friend.tags {
                            tagsString += "\(tag),"
                        }
                        newFriend.tags = tagsString
                    }
                    if moc.hasChanges {
                        try moc.save()
                    }
                    //sortUsers()
                } catch {
                    // contents could not be loaded
                    alertTitle = "Connection Error"
                    alertMessage = "Friends could not be loaded"
                    showingAlert = true
                }
            } else {
                // the URL was bad!
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
