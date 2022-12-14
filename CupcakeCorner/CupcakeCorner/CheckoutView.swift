//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Kurt Lane on 27/12/2022.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var showingConfirmation = false
    @State private var confirmationMessage = ""
    @State private var confirmationTitle = ""
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage (url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }.frame(height: 233)
                Text("Your total is \(order.cost, format: .currency (code: "USD"))")
                    .font(.system(.title, design: .rounded))
                Button ("Place Order", action: {
                    Task {
                        await placeOrder()
                    }
                })
                    .padding ()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert (confirmationTitle, isPresented: $showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print ("Failed to encode order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data,_) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationTitle = "Thank you!"
            confirmationMessage = "Your order for \(decodedOrder.quantity)× \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            print ("Failed to upload order")
            confirmationTitle = "Failed to place order"
            confirmationMessage = "Please check your internet connection and try again."
            showingConfirmation = true
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CheckoutView(order: Order())
        }
    }
}
