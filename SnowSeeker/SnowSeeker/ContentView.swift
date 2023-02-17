//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Kurt L on 8/2/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var favourites = Favorites()
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @State private var searchText = ""
    
    var filteredList: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredList) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack(alignment: .top) {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 24)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 0.25)
                            }
                            .padding(.top, 4)
                            .padding(.trailing, 5)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                        
                        if favourites.contains(resort) {
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("Favourite")
                                .foregroundColor(.red)
                        }
                        
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button(action: {}, label: {
                            Text("Default")
                            Image(systemName: "checkmark")
                        })
                        Button(action: {}, label: {
                            Text("Alphabetical")
                        })
                        Button(action: {}, label: {
                            Text("Countries")
                        })
                    }, label: {
                        Image(systemName: "arrow.up.arrow.down")
                    })
                }
            }
            .searchable(text: $searchText, prompt: "Search resorts")
            .navigationTitle ("Resorts")
            
            WelcomeView()
        }
        .environmentObject(favourites)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
