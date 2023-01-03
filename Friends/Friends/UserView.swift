//
//  UserView.swift
//  Friends
//
//  Created by Kurt Lane on 3/1/2023.
//

import SwiftUI

struct UserView: View {
    @Binding var selectedUser: User
    @State private var userAvatar = "🙂"
    
    var body: some View {
        VStack {
            List {
                Section {
                    HStack(alignment: .top) {
                        Text("Age: ")
                            .foregroundColor(.secondary)
                        Text(selectedUser.age, format: .number)
                    }
    
                    HStack(alignment: .top) {
                        Text("Company: ")
                            .foregroundColor(.secondary)
                        Text(selectedUser.company)
                    }
                    
                    HStack(alignment: .top) {
                        Text("Email: ")
                            .foregroundColor(.secondary)
                        Text(selectedUser.email)
                    }
                    
                    HStack(alignment: .top) {
                        Text("Address: ")
                            .foregroundColor(.secondary)
                        Text(selectedUser.address)
                    }
                }
                
                Section {
                    Text(selectedUser.about)
                        .padding(5)
                } header: {
                    Text("About")
                }
                
                Section {
                    HStack(alignment: .top) {
                        Text("Registered: ")
                            .foregroundColor(.secondary)
                        let newFormatter = ISO8601DateFormatter()
                        let date = newFormatter.date(from: selectedUser.registered)
                        Text(date?.formatted(date: .abbreviated, time: .shortened) ?? "unknown")
                    }
                }
                
                Section {
                    ForEach(selectedUser.friends, id: \.id) { user in
                        Text(user.name)
                    }
                } header: {
                    Text("Friends")
                }
            
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedUser.tags, id: \.self) { tag in
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    HStack {
                        Text(selectedUser.isActive ? "🟢" : "⚪️")
                        Text(selectedUser.name)
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

struct UserView_Previews: PreviewProvider {
    static let allUsers: [User] = Bundle.main.decode("_friendface.json")
    static var previews: some View {
        NavigationStack {
            UserView(selectedUser: .constant(allUsers[0]))
        }
    }
}
