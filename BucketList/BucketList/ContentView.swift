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

import MapKit

struct IntegratingMapKitLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

let locations = [
    IntegratingMapKitLocation(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
    IntegratingMapKitLocation(name: "Tower of London", coordinate: CLLocationCoordinate2D (latitude: 51.508, longitude: -0.076))
]

struct IntegratingMapKit: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
            //MapMarker(coordinate: location.coordinate)
            MapAnnotation(coordinate: location.coordinate) {
                VStack {
//                    Circle()
//                        .stroke(.red, lineWidth: 3)
//                       .frame(width: 44, height: 44)
                    Image(systemName: "star.fill")
                        .imageScale(.large)
                        .foregroundColor(.red)
                        .padding(.vertical, 2.5)
                    Text(location.name)
                        .font(.system(.caption, design: .rounded).weight(.bold))
                        .foregroundColor(.red)
                }
            }
        }
        
    }
}

import LocalAuthentication
struct TouchIDAndFaceID: View {
    
    @State private var isUnlocked = false
    
    var body: some View {
        ZStack {
            if isUnlocked {
                Color.green.ignoresSafeArea()
            } else {
                Color.red.ignoresSafeArea()
            }
            Image(systemName: isUnlocked ? "lock.open.fill" : "lock.fill")
                .font(.system(size: 100))
                .onTapGesture {
                    print("tapped")
                    authenticate()
                }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //Can use biometics
            let reason = "Unlock the app data"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    withAnimation {
                        isUnlocked = true
                    }
                }
                else {}
            }
        } else {
            //no biometics
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var showingLocationsList = false
    
    @State private var failedAlertMessage = ""
    @State private var showingFailedAlert = false
    
    var body: some View {
        //if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    //                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    MapAnnotation(coordinate: location.coordinate) {
                        ZStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            Text(location.name)
                                .fixedSize()
                                .padding(.top, 66)
                        }.onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Button {
                                showingLocationsList.toggle()
                            } label: {
                                Image(systemName: "list.star")
                                    .padding()
                                    .background(.primary.opacity(0.15))
                                    .foregroundColor(.primary)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .padding(.trailing)
                            }
                            Button {
                                viewModel.addNewLocation()
                            } label: {
                                Image(systemName: "plus")
                                    .padding()
                                    .background(.green.opacity(0.95))
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .clipShape(Circle ())
                                    .padding(.trailing)
                            }
                        }
                    }
                }
                if viewModel.isUnlocked == false {
                    ZStack {
                        Rectangle()
                            .ignoresSafeArea()
                            .background(.ultraThinMaterial)
                        Button ("Unlock Places") {
                            viewModel.authenticate(onSuccess: {}, onFailed: { message in
                                failedAlertMessage = message
                                showingFailedAlert = true
                            })
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                //Text(place.name)
                LocationEditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                }
            }
            .sheet(isPresented: $showingLocationsList) {
                PlaceList(locationsList: $viewModel.locations, mapRegion: $viewModel.mapRegion, onDelete: { viewModel.save() })
            }
            .alert(isPresented: $showingFailedAlert) {
                Alert(title: Text("Authenticaion Failed"), message: Text(failedAlertMessage), dismissButton: .default(Text("OK")))
            }
//        } else {
//            ZStack {
//                Map(coordinateRegion: $viewModel.mapRegion)
//                    .ignoresSafeArea()
//                Rectangle()
//                    .ignoresSafeArea()
//                    .background(.ultraThinMaterial)
//                Button ("Unlock Places") {
//                    viewModel.authenticate ()
//                }
//                .padding()
//                .background(. blue)
//                .foregroundColor(.white)
//                .clipShape (Capsule ( ))
//            }
//        }
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
        IntegratingMapKit()
            .previewDisplayName("Integrating MapKit")
        TouchIDAndFaceID()
            .previewDisplayName("Using Touch ID and Face ID")
        ContentView()
            .previewDisplayName("BucketList")
    }
}
