//
//  ContentView.swift
//  RememberThings
//
//  Created by Kurt L on 18/1/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var things: FetchedResults<Thing>
    
    @State private var isShowingCreateNewThingView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(things) { thing in
                    HStack {
                        thing.wrappedImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                        VStack(alignment: .leading) {
                            Text(thing.wrappedName)
                                .font(.system(.headline,design: .rounded).weight(.bold))
                            Text(thing.wrappedDateTime)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }.padding(.horizontal, 10)
                    }
                }
                .onDelete(perform: deleteThing)
            }
            .sheet(isPresented: $isShowingCreateNewThingView) {
                CreateNewThingView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingCreateNewThingView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Remember Things")
        }
    }
    
    func deleteThing(at offsets: IndexSet) {
        for offset in offsets {
            let thing = things[offset]
            moc.delete(thing)
        }
        if moc.hasChanges {
            try? moc.save()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
