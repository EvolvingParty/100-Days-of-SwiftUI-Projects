//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Kurt Lane on 26/12/2022.
//

import SwiftUI

//class User: ObservableObject, Codable {
//    enum CodingKeys: CodingKey {
//        case name
//    }
//    @Published var name = "First Last"
//    required init(from decoder: Decoder) throws { //OR make this a final class
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decode(String.self, forKey: .name)
//    }
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//    }
//}

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct RetrieveSongs: View {
    @State private var results = [Result]()
    
    var body: some View {
        NavigationStack {
            List (results, id: \.trackId) { item in
                VStack (alignment: .leading) {
                    Text(item.trackName)
                        .font(.headline)
                    Text(item.collectionName)
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("Austin French Songs")
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=austin+french&entity=song") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
    
}

struct LoadingAnImage: View {
    var body: some View {
//        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
//            image
//                .resizable()
//                .scaledToFit()
//        } placeholder: {
//            //Color.red
//            ProgressView()
//        }
//        .frame(width: 200, height: 200)
        AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("There was an error loading the image")
            } else {
                ProgressView()
            }
        }
        .frame(width: 200, height: 200)
    }
}

struct ValidatingAndDisablingForms: View {
    @State private var username = ""
    @State private var email = ""
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }
            Section {
                Button("Create Account") {
                    print("Creating account")
                }
            }.disabled(disableForm)
        }
    }
    
    var disableForm: Bool {
        username.count < 5 || email.count < 5
    }
}

//CupcakeCorner
struct CupcakeCornerContentView: View {
    @StateObject var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    Stepper ("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                Section {
                    Toggle ("Any special requests?", isOn: $order.specialRequestEnabled.animation())
                    if order.specialRequestEnabled {
                        Toggle ("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle ("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }.navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CupcakeCornerContentView()
            .previewDisplayName("Cupcake Corner")
        RetrieveSongs()
            .previewDisplayName("Retrieve songs")
        LoadingAnImage()
            .previewDisplayName("Loading an image")
        ValidatingAndDisablingForms()
            .previewDisplayName("Validating and disabling forms")
    }
}
