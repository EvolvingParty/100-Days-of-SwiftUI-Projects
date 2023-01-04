//
//  UserView.swift
//  Friends
//
//  Created by Kurt Lane on 3/1/2023.
//

import SwiftUI

struct UserView: View {
    //@State private var allUsers: [User]
    //@State private var selectedUser: User
    @State private var selectedUser: CashedUser
    @State private var userAvatar = "😇"
    @State private var showingEmojiPicker = false
    
    init(allUsers: [User], selectedUser: CashedUser, userAvatar: String = "😇", showingEmojiPicker: Bool = false) {
//        self.allUsers = allUsers
//        self.selectedUser = selectedUser
        self.selectedUser = selectedUser
        _userAvatar = State(initialValue: UserDefaults.standard.string(forKey: selectedUser.id ?? "") ?? "😇")
        self.showingEmojiPicker = showingEmojiPicker
    }
    
    var body: some View {
        VStack {
            List {
                
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .foregroundColor(.secondary.opacity(0.05))
                            Text(userAvatar)
                                .font(.system(size: 300.0))
                                .lineLimit(1)
                                .padding(15)
                                .minimumScaleFactor(0.1)
                        }.frame(width: 160, height: 160)
                        Spacer()
                    }
                    Text("Edit")
                        .foregroundColor(.blue)
                }
                .listRowBackground(Color.clear)
                .onTapGesture {
                    showingEmojiPicker = true
                }
                .onChange(of: userAvatar, perform: { newValue in
                    UserDefaults.standard.set(newValue, forKey: selectedUser.id ?? "")
                })
                
                Section {
                    HStack(alignment: .top) {
                        Text("Age: ")
                            .foregroundColor(.secondary)
                        Text(selectedUser.age, format: .number)
                    }
    
                    HStack(alignment: .top) {
                        Text("Company: ")
                            .foregroundColor(.secondary)
                        Text(selectedUser.company ?? "")
                    }
                    
                    HStack(alignment: .top) {
                        Text("Email: ")
                            .foregroundColor(.secondary)
                        Text(selectedUser.email ?? "")
                    }
                    
                    HStack(alignment: .top) {
                        Text("Address: ")
                            .foregroundColor(.secondary)
                        Text(selectedUser.address ?? "")
                    }
                }
                
                Section {
                    Text(selectedUser.about ?? "")
                        .padding(5)
                } header: {
                    Text("About")
                }
                
                Section {
                    HStack(alignment: .top) {
                        Text("Registered: ")
                            .foregroundColor(.secondary)
                        let newFormatter = ISO8601DateFormatter()
                        let date = newFormatter.date(from: selectedUser.registered ?? "")
                        Text(date?.formatted(date: .abbreviated, time: .shortened) ?? "unknown")
                    }
                }
                
//                Section {
//                    ForEach(selectedUser.friends, id: \.id) { user in
//                        if let fullUser = allUsers.first { $0.id == user.id } {
//                            NavigationLink(destination: {UserView(allUsers: allUsers, selectedUser: fullUser)}, label: {
//                                HStack {
//                                    Text(fullUser.isActive ? "🟢" : "⚪️")
//                                    Text(fullUser.name)
//                                        .foregroundColor(fullUser.isActive ? Color.primary : Color.primary.opacity(0.75))
//                                        .font(.system(.title3, design: .rounded))
//                                        .padding(.top, 1)
//                                }
//                            })
//                        }
//                    }
//                } header: {
//                    Text("Friends")
//                }
            
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            let tags: [String] = selectedUser.tags?.components(separatedBy: ",") ?? []
                            ForEach(tags, id: \.self) { tag in
                                Button(tag) {}
                                    .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                } header: {
                    Text("Tags")
                }
                
            }
        }
        .sheet(isPresented: $showingEmojiPicker) {
            EmojiPickerView(selectedEmoji: $userAvatar)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    HStack {
                        Text(selectedUser.isActive ? "🟢" : "⚪️")
                        Text(selectedUser.name ?? "")
                            .foregroundColor(selectedUser.isActive ? Color.primary : Color.primary.opacity(0.75))
                            .font(.system(.title, design: .rounded).weight(.bold))
                            .padding(.top, 1)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct UserView_Previews: PreviewProvider {
//    static let allUsers: [User] = Bundle.main.decode("_friendface.json")
//    static var previews: some View {
//        NavigationStack {
//            UserView(allUsers: [User](), selectedUser: allUsers[0])
//        }
//    }
//}
