//
//  ContentView.swift
//  Instafilter
//
//  Created by Kurt Lane on 5/1/2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct OnChangeView: View {
    
    @State private var blurAmount = 0.0
    
    var body: some View {
        VStack {
            
            Text("Hello, world!")
                .blur (radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { newValue in
                    print("New value is \(newValue)")
                }

            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20)
            }
            
        }
    }
}

struct ConfirmationView: View {
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    
    var body: some View {
        Text("Tap me!")
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .onTapGesture {
                showingConfirmation = true
            }
            .confirmationDialog("Change background", isPresented: $showingConfirmation) {
                Button("Red") { backgroundColor = .red }
                Button( "Green") { backgroundColor = .green }
                Button("Blue") { backgroundColor = .blue }
                Button( "Cancel", role: .cancel) { }
            } message: {
                Text("Select a new colour")
            }
    }
}

struct ImageEffectsView: View {
    @State private var image: Image?
    @State private var originalImage: UIImage?
    @Binding var inputImage: UIImage
    @State private var filterSelected = "Sepia"
    @State private var amount = 1.0
    @State private var maxAmount = 1.0
    
    var body: some View {
        VStack {
            Picker("", selection: $filterSelected) {
                ForEach(["Sepia","Pixel","Crystallize","Twirl"], id: \.self) {
                    Text($0)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding()
            .onChange(of: filterSelected, perform: {_ in
                switch filterSelected {
                case "Pixel":
                    amount = 10.0
                    maxAmount = 100.0
                case "Crystallize":
                    amount = 20.0
                    maxAmount = 200.0
                case "Twirl":
                    amount = 100.0
                    maxAmount = 1500.0
                default:
                    amount = 1.0
                    maxAmount = 1.0
                }
            })
            image?
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 300)
            HStack {
                Slider(value: $amount, in: 0.1...maxAmount)
                    .onChange(of: amount) { newValue in
                        print("New value is \(newValue)")
                        loadFilteredImage()
                    }
                    .padding()
                Button(action: {
                    switch filterSelected {
                    case "Pixel": amount = 10.0
                    case "Crystallize": amount = 20.0
                    case "Twirl": amount = 500.0
                    default: amount = 1.0
                    }
                }, label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(.quaternaryLabel).opacity(0.5))
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Image(systemName: "wand.and.rays")
                            .font(.headline)
                            .imageScale(.large)
                    }
                })
                .padding(.trailing)
            }
        }
        .onAppear(perform: {
            originalImage = inputImage
            loadFilteredImage()
        })
    }
    
    func loadFilteredImage() {
        //image = Image("Example")
        //guard let inputImage = inputImage else {return}
        let beginImage = CIImage(image: originalImage ?? UIImage())
        let context = CIContext()
        switch filterSelected {
        case "Pixel":
            let currentFilter = CIFilter.pixellate()
            currentFilter.inputImage = beginImage
            currentFilter.scale = Float(amount)
            guard let outputImage = currentFilter.outputImage else {return}
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiImage = UIImage(cgImage: cgimg)
                inputImage = uiImage
                image = Image (uiImage: uiImage)
            }
        case "Crystallize":
            let currentFilter = CIFilter.crystallize()
            currentFilter.inputImage = beginImage
            currentFilter.radius = Float(amount)
            guard let outputImage = currentFilter.outputImage else {return}
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiImage = UIImage(cgImage: cgimg)
                inputImage = uiImage
                image = Image (uiImage: uiImage)
            }
        case "Twirl":
            let currentFilter = CIFilter.twirlDistortion()
            currentFilter.inputImage = beginImage
            currentFilter.radius = Float(amount)
            currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
            guard let outputImage = currentFilter.outputImage else {return}
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiImage = UIImage(cgImage: cgimg)
                inputImage = uiImage
                image = Image (uiImage: uiImage)
            }
        default:
            let currentFilter = CIFilter.sepiaTone()
            currentFilter.inputImage = beginImage
            currentFilter.intensity = Float(amount)
            guard let outputImage = currentFilter.outputImage else {return}
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiImage = UIImage(cgImage: cgimg)
                inputImage = uiImage
                image = Image(uiImage: uiImage)
            }
        }
    }
    
//    func loadImage() {
//        image = Image("Example")
//        guard let inputImage = UIImage(named: "Example") else {return}
//        let beginImage = CIImage(image: inputImage)
//        let context = CIContext()
//        let currentFilter = CIFilter.twirlDistortion()
//        currentFilter.inputImage = beginImage
//        let amount = 1.0
//        let inputKeys = currentFilter.inputKeys
//
//        if inputKeys.contains(kCIInputIntensityKey) {
//            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
//        }
//
//        if inputKeys.contains(kCIInputRadiusKey) {
//            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
//        }
//
//        if inputKeys.contains(kCIInputScaleKey) {
//            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
//        }
//
////        currentFilter.radius = Float(1000.0)
////        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
//        guard let outputImage = currentFilter.outputImage else {return}
//        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
//            let uiImage = UIImage(cgImage: cgimg)
//            image = Image(uiImage: uiImage)
//        }
//    }
    
}

struct PHPickerView: View {
    @State private var image: Image?
    @Binding var inputImage: UIImage
    @State private var isShowingImagePicker = false
    @State private var isShowingSaved = false
    var body: some View {
        VStack {
            Button(action : {isShowingImagePicker = true}) {
                HStack {
                    Image(systemName: "photo.stack")
                    Text("Select image")
                }
            }.padding()
            HStack {
                ZStack {
                    Color.primary.opacity(image == nil ? 0.22 : 0.0)
                    image?
                        .resizable()
                        .scaledToFit()
                }
            }.frame(width: 400, height: 300)
            Button(action: {
                //guard let inputImage = inputImage else { return }
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: inputImage)
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save photo to library")
                }
            }.padding()
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in
            loadImage()
        }

    }
    
    func loadImage() {
        //guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
        
        //UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil)
    }
    
}
    
struct ContentView: View {
    @State private var image: Image?
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
    }
}

struct View_Previews: PreviewProvider {
    static var previews: some View {
        OnChangeView()
            .previewDisplayName("On Change")
        ConfirmationView()
            .previewDisplayName("Confirmation")
        ImageEffectsView(inputImage: .constant(UIImage(named: "Example")!))
            .previewDisplayName("Image Effects")
        PHPickerView(inputImage: .constant(UIImage(named: "Example")!))
            .previewDisplayName("PHPickerView")
        ContentView()
            .previewDisplayName("Instafliter")
    }
}
