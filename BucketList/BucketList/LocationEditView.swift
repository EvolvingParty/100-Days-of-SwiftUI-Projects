//
//  LocationEditView.swift
//  BucketList
//
//  Created by Kurt L on 12/1/2023.
//

import SwiftUI

struct LocationEditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    
    @State private var name: String
    @State private var description: String
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    TextField("Placename", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section {
                    if loadingState == .loading {Text("Loading…")}
                    else if loadingState == .failed {Text("There was an error loading the data.")}
                    else {
                        ForEach(pages, id: \.self) { page in
                            Button {
                                name = page.title
                                description = page.description
                            } label: {
                                Text(page.title)
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                                + Text(": ")
                                + Text(page.description)
                                    .font(.system(.body, design: .rounded))
                            }.foregroundColor(.primary)
                        }
                    }
                } header: {
                    Text("Nearby…")
                }
                
            }
            .navigationTitle ("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task{ await fetchNearbyPlaces() }
        }
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            loadingState = .failed
            return
        }
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            //pages = items.query.pages.values.sorted { $0.title < $1.title }
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            print(error.localizedDescription)
            loadingState = .failed
        }
    }
}

struct LocationEditView_Previews: PreviewProvider {
    static var previews: some View {
        LocationEditView(location: Location.example) { _ in }
    }
}
