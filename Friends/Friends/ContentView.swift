//
//  ContentView.swift
//  Friends
//
//  Created by Kurt Lane on 3/1/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var allUsers: [User] = []
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private var sortOptions = ["A-Z", "Online", "Offline"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if allUsers.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(allUsers) { user in
                            HStack {
                                Text(user.isActive ? "🟢" : "⚪️")
                                Text(user.name)
                                    .foregroundColor(user.isActive ? Color.primary : Color.primary.opacity(0.75))
                                    .font(.system(.title3, design: .rounded))
                                    .padding(.top, 1)
                            }
                        }
                    }
                }
            }
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
                            Button {} label: {
                                HStack {
                                    Text(option)
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
        if let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") {
            do {
                let contents: [User] = try await URLSession.shared.decode(from: url)
                allUsers = contents
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
