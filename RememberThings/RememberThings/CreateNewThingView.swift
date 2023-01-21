//
//  CreateNewThingView.swift
//  RememberThings
//
//  Created by Kurt L on 19/1/2023.
//

import SwiftUI

struct CreateNewThingView: View {
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.dismiss) var dismiss
    @State private var showingConfirmationAlert = false
    
    @State private var isShowingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    @State var thingName: String = ""
    @State var thingNotes: String = ""
    @State var thingDateTime = Date.now
    
    //Day 78
    let locationFetcher = LocationFetcher()
    @State var userLatitude: Double = 0.0
    @State var userLongitude: Double = 0.0

    var body: some View {
        NavigationView {
            VStack {
                if image != nil {
                    HStack {
                        image?
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                    Form {
                        
                        HStack {
                            DatePicker("Time", selection: $thingDateTime, displayedComponents: .hourAndMinute)
                            DatePicker("Date", selection: $thingDateTime, displayedComponents: .date)
                        }
                        .labelsHidden()
                        .colorInvert()
                        .colorMultiply(.blue)
                        .padding(.vertical, 5)
                        
                        HStack {
                            Text("\(userLatitude), ")
                            Text("\(userLongitude)")
                        }
                        .foregroundColor(.secondary)

                        TextField("Give this image a memorable name", text: $thingName)
                        
                        TextField("Notes", text: $thingNotes)
                        
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                        Text("Tap to select an image")
                            .font(.headline)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isShowingImagePicker.toggle()
                    }
                }
            }
            .onAppear(perform: {
                self.locationFetcher.start()
                updateLocation()
            })
            .onChange(of: locationFetcher.lastKnownLocation?.latitude, perform: { _ in updateLocation() })
            .navigationTitle("Remember new thing")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Discard changes", isPresented: $showingConfirmationAlert) {
                Button("Discard", role: .destructive) {dismiss()}
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if image != nil {
                        Button("Cancel") {
                            showingConfirmationAlert.toggle()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if image != nil {
                        Button("Save") {
                            let newThing = Thing(context: moc)
                            newThing.name = thingName
                            newThing.dateTime = thingDateTime
                            if thingNotes != "" {
                                newThing.notes = thingNotes
                            }
                            let newThingImageUUID = UUID().uuidString
                            newThing.imageUUID = newThingImageUUID
                            newThing.latitude = userLatitude
                            newThing.longitude = userLongitude
                            if moc.hasChanges {
                                try? moc.save()
                            }
                            //encode and save image
                            let savePath = FileManager.documentsDirectory.appendingPathComponent(newThingImageUUID)
                            do {
                                let data = try JSONEncoder().encode(inputImage?.jpegData(compressionQuality: 1.0))
                                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
                            } catch {
                                print("Unable to save data")
                            }
                            dismiss()
                        }
                        .font(.system(.body).bold())
                        .disabled(thingName == "")
                    } else {
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
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in
                //loadImage()
                guard let inputImage = inputImage else {return}
                thingDateTime = Date.now
                image = Image(uiImage: inputImage)
            }
            .interactiveDismissDisabled(image != nil)
        }
    }
    
    func updateLocation() {
        if let location = self.locationFetcher.lastKnownLocation {
            userLatitude = location.latitude
            userLongitude = location.longitude
        }
    }
}

struct CreateNewThingView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewThingView()
    }
}
