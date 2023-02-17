//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Kurt L on 12/2/2023.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var sizeClass //"Compact" or on PLus or Max, "Regular"
    @Environment(\.dynamicTypeSize) var typeSize
    @EnvironmentObject var favorites: Favorites
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
     
    let resort: Resort
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                ZStack(alignment: .bottomLeading) {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                    Text("Image credit: \(resort.imageCredit)")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(.black.opacity (0.5))
                        .clipShape (Capsule ( ))
                        .offset(x: 5, y: -5)
                }
                
                HStack {
                    if sizeClass == .compact && typeSize > .large {
                        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    } else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    Text("Facilities")
                        .font(.headline)
                    //Text(resort.facilities.joined(separator: ", "))
//                    Text(resort.facilities, format: .list(type: .and))
//                        .padding(.vertical, 2)
                    HStack {
                        ForEach (resort.facilityTypes) { facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }
                    
                    Button(favorites.contains(resort) ? "Remove from favourites" : "Add to favourites") {
                        if favorites.contains (resort) {
                            favorites.remove(resort)
                        } else {
                            favorites.add(resort)
                        }
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedFacility?.name ?? "More Information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
            .environmentObject(Favorites())
    }
}
