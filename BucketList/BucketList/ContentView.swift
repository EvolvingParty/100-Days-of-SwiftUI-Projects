//
//  ContentView.swift
//  BucketList
//
//  Created by Kurt L on 10/1/2023.
//

import SwiftUI

struct User: Identifiable, Comparable {
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    let id = UUID()
    let firstName: String
    let lastName: String
}

struct ComparableView: View {
    
    let users = [
        User (firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister")
    ]
    
    var body: some View {
        List(users.sorted()) { user in
            Text("\(user.firstName) \(user.lastName)")
        }
    }
}

struct DocumentsDirectoryView: View {
    var body: some View {
        Text("Hello, world!")
            .onTapGesture {
                let str = "Text message"
                let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                
                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    var body: some View {
        Text ("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text ("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text ("Failed :(")
    }
}

struct EnumsView: View {
    var loadingState = LoadingState.loading
    var body: some View {
        switch loadingState {
        case .loading:
            LoadingView()
        case .success:
            SuccessView()
        case .failed:
            FailedView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ComparableView()
            .previewDisplayName("Comparable")
        DocumentsDirectoryView()
            .previewDisplayName("Documents directory")
        EnumsView()
            .previewDisplayName("Switching view states with enums")
        ContentView()
            .previewDisplayName("Bucket List")
    }
}
