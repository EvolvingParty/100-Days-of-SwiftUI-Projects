//
//  LocationEditView.swift
//  BucketList
//
//  Created by Kurt L on 12/1/2023.
//

import SwiftUI

struct LocationEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.dismissSearch) var dismissSearch
    
    public var location: Location
    public var onSave: (Location) -> Void
    
    @State var name: String
    @State var description: String
    @State var latitude: Double
    @State var longitude: Double
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    @State private var locationPages = [LocationPage]()
    
    @State private var searchText = ""
    
    var filteredLocationResults: [LocationPage] {
        if searchText.isEmpty {
            return locationPages
        } else {
            var pagesToReturn = [LocationPage]()
            for page in locationPages {
                if page.title.lowercased().contains(searchText.lowercased()) { pagesToReturn.append(page) }
            }
            return pagesToReturn
        }
    }
    
    var filteredResults: [Page] {
        if searchText.isEmpty {
            return pages
        } else {
            var pagesToReturn = [Page]()
            for page in pages {
                if page.title.lowercased().contains(searchText.lowercased()) || page.description.lowercased().contains(searchText.lowercased()) { pagesToReturn.append(page) }
            }
            return pagesToReturn
        }
    }
    
    private var initialName = ""
    private var initialDescription = ""
    private var initialLatitude = 0.0
    private var initialLongitude = 0.0
    
    
    private var hasChanges: Bool {
        name != initialName || description != initialDescription || latitude != initialLatitude || longitude != initialLongitude
    }
    
    @State private var showingConfirmationAlert = false
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        initialName = location.name
        _description = State(initialValue: location.description)
        initialDescription = location.description
        _latitude = State(initialValue: location.latitude)
        initialLatitude = location.latitude
        _longitude = State(initialValue: location.longitude)
        initialLongitude = location.longitude
        print("\(latitude), \(longitude)")
    }
    
    struct SearchableListView: View {
        @Environment(\.isSearching) var isSearching
        @Environment(\.dismissSearch) var dismissSearch
        var filteredResults: [Page]
        var filteredLocationResults: [LocationPage]
        @Binding var name: String
        @Binding var description: String
        @Binding var latitude: Double
        @Binding var longitude: Double
        @Binding var resultsType: Int
        
        var body: some View {
            if resultsType == 1 {
                if filteredResults.isEmpty {
                    VStack {
                        HStack {
                            Spacer()
                            Text("No results…")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("Try a different search.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                else {
                    ForEach(filteredResults, id: \.self) { page in
                        Button {
                            name = page.title
                            description = page.description
                            dismissSearch()
                            //                        withAnimation {
                            //                            proxy.scrollTo(101)
                            //                        }
                        } label: {
                            Text(page.title)
                                .font(.system(.body, design: .rounded).weight(.semibold))
                            + Text(": ")
                            + Text(page.description)
                                .font(.system(.body, design: .rounded))
                        }.foregroundColor(.primary)
                    }
                }
            } else {
                if filteredLocationResults.isEmpty {
                    VStack {
                        HStack {
                            Spacer()
                            Text("No results…")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("Try a different search.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                else {
                    ForEach(filteredLocationResults, id: \.self) { location in
                        Button {
                            name = location.title
                            latitude = location.lat
                            longitude = location.lon
                            dismissSearch()
                        } label: {
                            Text(location.title)
                                .font(.system(.body, design: .rounded).weight(.semibold))
                            + Text(". Distance: ")
                            + Text("\(Int(location.dist))m")
                                .font(.system(.body, design: .rounded))
                        }.foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    @State private var selectedResultsType = 1
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    
                    Section {
                        TextField("Placename", text: $name)
                            .id(101)
                        TextField("Description", text: $description)
                        Text("\(latitude), \(longitude)")
                            .foregroundColor(Color.secondary)
                    } header: {
                        Text("Place details")
                    }
                    
                    Section {
                        if loadingState == .loading {Text("Loading…")}
                        else if loadingState == .failed {Text("There was an error loading the data.")}
                        else {
                            SearchableListView(filteredResults: filteredResults, filteredLocationResults: filteredLocationResults, name: $name, description: $description, latitude: $latitude, longitude: $longitude, resultsType: $selectedResultsType)
                                
//                            ForEach(filteredResults, id: \.self) { page in
//                                Button {
//                                    name = page.title
//                                    description = page.description
//                                    dismissSearch()
//                                    withAnimation {
//                                        proxy.scrollTo(101)
//                                    }
//                                } label: {
//                                    Text(page.title)
//                                        .font(.system(.body, design: .rounded).weight(.semibold))
//                                    + Text(": ")
//                                    + Text(page.description)
//                                        .font(.system(.body, design: .rounded))
//                                }.foregroundColor(.primary)
//                            }
                        }
                    } header: {
                        VStack {
                            HStack {
                                Text("Nearby…")
                                Spacer()
                            }
                            Spacer()
                            Picker("Type", selection: $selectedResultsType) {
                                Text("Locations").tag(0)
                                Text("Places").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .labelsHidden()
                            .padding(.bottom, 10)
                            .onChange(of: selectedResultsType, perform: { newValue in
                                Task {
                                    if newValue == 1 {
                                        await fetchNearbyPlaces()
                                    } else {
                                        await fetchNearbyLocations()
                                    }
                                }
                            })
                        }
                    }
                }
                .searchable(text: $searchText, placement: .toolbar)
                .listStyle(.insetGrouped)
            }
            .alert("Discard changes", isPresented: $showingConfirmationAlert) {
                Button("Discard", role: .destructive) {dismiss()}
            }
            .navigationTitle (name)
            .toolbar {
                if hasChanges {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingConfirmationAlert.toggle()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            var newLocation = location
                            newLocation.id = UUID()
                            newLocation.name = name
                            newLocation.description = description
                            newLocation.longitude = longitude
                            newLocation.latitude = latitude
                            onSave(newLocation)
                            dismiss()
                        }
                        .fontWeight(.bold)
                    }
                } else {
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
                }
            }
            .task{
                await fetchNearbyPlaces()
            }
        }
    }
    
    func fetchNearbyPlaces() async {
        loadingState = .loading
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
    
    func fetchNearbyLocations() async {
        loadingState = .loading
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&list=geosearch&gsradius=10000&gscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&format=json"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            loadingState = .failed
            return
        }
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            print(data)
            let items = try JSONDecoder().decode(LocationResult.self, from: data)
            //pages = items.query.pages.values.sorted { $0.title < $1.title }
            locationPages = items.query.geosearch.sorted()
            print(locationPages)
            loadingState = .loaded
        } catch {
            print("fetchNearbyLocations error:")
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
