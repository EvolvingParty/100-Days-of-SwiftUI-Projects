//
//  ThingDetailView.swift
//  RememberThings
//
//  Created by Kurt L on 19/1/2023.
//

import SwiftUI
import CoreData
import MapKit

struct ThingMapKitLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ThingDetailView: View {
    @Environment(\.dismiss) var dismiss
    var recievedThing: Thing
    var thingImage: Image
    
    @State private var mapRegion = MKCoordinateRegion()
    @State private var thingLocation = ThingMapKitLocation(name: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    
    init(recievedThing: Thing, thingImage: Image, mapRegion: MKCoordinateRegion = MKCoordinateRegion(), thingLocation: ThingMapKitLocation = ThingMapKitLocation(name: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))) {
        self.recievedThing = recievedThing
        self.thingImage = thingImage
        let mapCords = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: recievedThing.latitude, longitude: recievedThing.longitude), span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        _mapRegion = State(initialValue: mapCords)
        _thingLocation = State(initialValue: ThingMapKitLocation(name: recievedThing.wrappedName, coordinate: CLLocationCoordinate2D(latitude: recievedThing.latitude, longitude: recievedThing.longitude)))
    }
    
    var body: some View {
        VStack {
            HStack {
                thingImage
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            Form {
                Text(recievedThing.wrappedDateTime)
                Text(recievedThing.wrappedName)
                if let wrappedNotes = recievedThing.notes {
                    Text(wrappedNotes)
                }
                VStack {
                    Map(coordinateRegion: $mapRegion, annotationItems: [thingLocation]) { location in
                        MapMarker(coordinate: location.coordinate)
                    }
                        .frame(height: 300.0)
                }
            }
        }
        .navigationTitle(recievedThing.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ThingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThingDetailView(recievedThing: Thing.sampleThing, thingImage: Image("no-image-available"))
        }
    }
}
