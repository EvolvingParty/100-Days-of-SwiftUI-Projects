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
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    @State private var searchText = ""
    
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
    
    private var hasChanges: Bool {
        name != initialName || description != initialDescription
    }
    
    @State private var showingConfirmationAlert = false
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        initialName = location.name
        _description = State(initialValue: location.description)
        initialDescription = location.description
    }
    
    struct SearchableListView: View {
        @Environment(\.isSearching) var isSearching
        @Environment(\.dismissSearch) var dismissSearch
        var filteredResults: [Page]
        @Binding var name: String
        @Binding var description: String
        
        var body: some View {
//                List {
//                    Text("Search Bar")
//                }
//                VStack(alignment: .center) {
//                    Text(isSearching ? "Searching" : "Not Searching")
//                }
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
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    
                    Section {
                        TextField("Placename", text: $name)
                            .id(101)
                        TextField("Description", text: $description)
                    } header: {
                        Text("PLace details")
                    }
                    
                    Section {
                        if loadingState == .loading {Text("Loading…")}
                        else if loadingState == .failed {Text("There was an error loading the data.")}
                        else {
                            SearchableListView(filteredResults: filteredResults, name: $name, description: $description)
                                
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
                        Text("Nearby…")
                    }
                }.searchable(text: $searchText, placement: .toolbar)
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
