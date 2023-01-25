//
//  MeView.swift
//  HotProspects
//
//  Created by Kurt L on 23/1/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import CoreImage

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @FocusState private var inputIsFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .focused($inputIsFocused)
                    TextField("Email address", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .focused($inputIsFocused)
                }
                Section {
                    HStack(alignment: .center) {
                        Spacer()
                        Image(uiImage: qrCode)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            //.frame(width: 200, height: 200)
                            .contextMenu {
                                Button {
                                    ImageSaver().writeToPhotoAlbum(image: qrCode)
                                } label: {
                                    Label("Save to Photos", systemImage: "square.and.arrow.down")
                                }
                            }
                        Spacer()
                    }.listRowBackground(Color.clear)
                }
            }
            .onAppear(perform: updateCode)
            .onChange(of : name) { _ in updateCode() }
            .onChange(of: emailAddress) { _ in updateCode() }
            .navigationTitle("Your code")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
        }
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage (systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
