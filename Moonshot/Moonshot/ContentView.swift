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
    
    let astronauts: [String: Astronaut] = Bundle.main.decode ("astronauts.json")
    let mission: [Mission] = Bundle.main.decode("missions.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
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
        
//        Text("\(astronauts.count)")
//            .padding()
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(mission) { mission in
                        NavigationLink {
                            Text("Detail View")
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding( )
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackaround)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackaround)
                            )
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}