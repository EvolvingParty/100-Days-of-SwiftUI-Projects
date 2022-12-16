//
//  ContentView.swift
//  Moonshot
//
//  Created by Kurt Lane on 16/12/2022.
//

import SwiftUI

struct ContentView: View {
    
//    let lavout = [
//        GridItem(.adaptive(minimum: 80))
//    ]
    
    var body: some View {
//        GeometryReader { geo in
//            Image("example")
//                .resizable()
//                .scaledToFit()
//                .frame(width: geo.size.width * 0.8)
//                .frame(width: geo.size.width, height: geo.size.height)
//        }
        
//        ScrollView {
//            LazyVStack(spacing: 10) {
//                ForEach (0..<100) {
//                    Text ("Item \($0)")
//                        .font (.title)
//                }
//            }
//            .frame(maxWidth: .infinity)
//        }
        
//        NavigationStack {
//            List(0..<100) { row in
//                NavigationLink {
//                    Text("Detail \(row)")
//                } label: {
//                    Text ("Row \(row)")
//                        .padding()
//                }
//            }.navigationTitle("SwiftUI")
//        }
        
//        ScrollView {
//            LazyVGrid(columns: lavout) {
//                ForEach(0..<1000) {
//                    Text ("Item \($0)")
//                }
//            }
//        }
        
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
