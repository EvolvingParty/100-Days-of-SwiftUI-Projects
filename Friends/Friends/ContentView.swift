//
//  ContentView.swift
//  Friends
//
//  Created by Kurt Lane on 3/1/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var allFriends: [Friend] = []
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                if allFriends.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(allFriends) { friend in
                            Text(friend.name)
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
        }
    }
    
    func loadFriends() async {
        if let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") {
            do {
                let contents: [Friend] = try await URLSession.shared.decode(from: url)
                allFriends = contents
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
