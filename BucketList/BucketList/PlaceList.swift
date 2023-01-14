//
//  PlaceList.swift
//  BucketList
//
//  Created by Kurt L on 14/1/2023.
//

import SwiftUI
import MapKit

struct PlaceList: View {
    @Environment(\.dismiss) var dismiss
    @Binding var locationsList: [Location]
    @Binding var mapRegion: MKCoordinateRegion
    var body: some View {
        NavigationView {
            List {
                ForEach(locationsList) { place in
                    Button {
                            dismiss()
                        withAnimation {
                            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
                        }
                    } label: {
                        Text(place.name)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                        + Text(": ")
                        + Text(place.description)
                            .font(.system(.body, design: .rounded))
                    }
                }
                .onDelete(perform: removePlace)
            }
            .navigationTitle("Places List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(.secondarySystemFill))
                            Image(systemName: "xmark")
                                .font(Font.body.weight(.bold))
                                .foregroundColor(.secondary)
                                .imageScale(.small)
                                .frame(width: 44, height: 44)
                        }
                        .padding(.trailing, -5)
                        .padding(.top, 10)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
                }
            }
        }
    }
    
    func removePlace(at offsets: IndexSet) {
        locationsList.remove(atOffsets: offsets)
    }
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        PlaceList(locationsList: .constant([]), mapRegion: .constant(MKCoordinateRegion()))
    }
}
