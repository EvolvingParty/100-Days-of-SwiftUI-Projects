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
    @Binding var inputImage: UIImage?
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
            currentFilter.center = CGPoint(x: inputImage!.size.width / 2, y: inputImage!.size.height / 2)
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
    @Binding var inputImage: UIImage?
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
                imageSaver.writeToPhotoAlbum(image: inputImage!)
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
        image = Image(uiImage: inputImage!)
        
        //UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil)
    }
    
}


public struct Filter: Identifiable {
    public var id = UUID()
    let name: String
    let filterType: CIFilter
    let exampleAmount: Double
}

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterIRadius = 0.5
    @State private var filterIScale = 0.5
    
    @State private var isShowingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingInputIntensitySlider = true
    @State private var showingInputRadiusSlider = false
    @State private var showingInputScaleSlider = false
    
    let availableFilters: [Filter] = [
        Filter(name: "Sepia", filterType: CIFilter.sepiaTone(), exampleAmount: 1.0),
        Filter(name: "Pixellate", filterType: CIFilter.pixellate(), exampleAmount: 0.5),
        Filter(name: "Crystallize", filterType: CIFilter.crystallize(), exampleAmount: 0.8),
        Filter(name: "Edges", filterType: CIFilter.edges(), exampleAmount: 0.5),
        Filter(name: "Gaussian", filterType: CIFilter.gaussianBlur(), exampleAmount: 2.0),
        Filter(name: "Unsharp", filterType: CIFilter.unsharpMask(), exampleAmount: 1.0),
        Filter(name: "Vignette", filterType: CIFilter.vignette(), exampleAmount: 1.0)
    ]
    
    @State private var showingFiltersSelectionConfirmation = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Group {
                        Rectangle()
                            .fill(.secondary.opacity(0.1))
                        Text("Tap to select a picture")
                            .font(.headline)
                    }
                    .opacity(image == nil ? 1.0 : 0.0)
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    //select an image
                    isShowingImagePicker.toggle()
                }
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(availableFilters) { filter in
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.primary.opacity(0.05))
                                    VStack {
                                        Spacer()
                                        Spacer().frame(maxHeight: 1.0)
                                        if image == nil {
                                            Rectangle()
                                                .foregroundColor(.primary.opacity(0.05))
                                                //.frame(width: 90, height: 75)
                                                .padding(5)
                                        }
                                        exampleImage(filter.filterType, filter.exampleAmount)?
                                            .resizable()
                                            .scaledToFit()
                                        Text(filter.name)
                                            .font(.system(.footnote, design: .rounded).weight(.light))
                                            .lineLimit(1)
                                        Spacer()
                                        Spacer().frame(maxHeight: 1.0)
                                    }
                                }
                                .background(Color.primary.opacity(0.01))
                                .frame(width: 100, height: 100)
                                .padding(.bottom, 10)
                                .onTapGesture(perform: { setFilter(filter.filterType)})
//                                VStack(alignment: .center) {
//                                    ZStack {
//                                        VStack {
//                                            Spacer()
//                                            ZStack {
//                                                if image == nil {
//                                                    Rectangle()
//                                                        .foregroundColor(.primary.opacity(0.05))
//                                                        .frame(width: 90, height: 75)
//                                                        .padding(.top)
//                                                }
//                                                image?
//                                                    .resizable()
//                                                    .scaledToFit()
//                                            }
//                                            Text(filter)
//                                                .font(.system(.footnote, design: .rounded).weight(.light))
//                                                .lineLimit(1)
//                                                .padding(.bottom)
//                                            Spacer()
//                                        }
//                                    }.frame(width: 100, height: 115)
//                                }
                            }
                        }
                    }
                }.frame(height: 105)
                if showingInputIntensitySlider {
                    HStack {
                        Text ("Intensity")
                        Slider(value: $filterIntensity, in: 0.1...1.0)
                            .onChange(of: filterIntensity, perform:{ _ in applyProcessing()})
                    }.padding(.horizontal)
                }
                if showingInputRadiusSlider {
                    HStack {
                        Text ("Radius")
                        Slider(value: $filterIRadius, in: 0.1...1.0)
                            .onChange(of: filterIRadius, perform:{ _ in applyProcessing()})
                    }.padding(.horizontal)
                }
                if showingInputScaleSlider {
                    HStack {
                        Text ("Scale")
                        Slider(value: $filterIScale, in: 0.1...1.0)
                            .onChange(of: filterIScale, perform:{ _ in applyProcessing()})
                    }.padding(.horizontal)
                }
//                HStack {
//                    Button("Change Filter") {
//                        // change filter
//                        showingFiltersSelectionConfirmation.toggle()
//                    }
//                    Spacer()
//                    //Button("Save", action: save)
//                }
            }
            .padding([.horizontal,.bottom])
            .navigationTitle("InstaFilter")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    //Button("Save", action: save)
                    Button(action: save) {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .disabled(image == nil ? true : false)
                }
            }
            .onChange(of: inputImage) { _ in
                loadImage()
            }
            .confirmationDialog("Select a filter", isPresented: $showingFiltersSelectionConfirmation) {
                Button("Sepia") { setFilter(CIFilter.sepiaTone())}
                Button("Pixelate") { setFilter(CIFilter.pixellate())}
                Button("Crystallize") { setFilter(CIFilter.crystallize())}
                Button("Twirl") { setFilter(CIFilter.twirlDistortion())}
                Button( "Cancel", role: .cancel) { }
            } message: {
                Text("Select a new colour")
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        let inputKeys = currentFilter.inputKeys
        withAnimation {
            showingInputIntensitySlider = false
            showingInputRadiusSlider = false
            showingInputScaleSlider = false
            for key in inputKeys {
                if key == "inputIntensity" {showingInputIntensitySlider = true}
                if key == "inputScale" {showingInputScaleSlider = true}
                if key == "inputRadius" {showingInputRadiusSlider = true}
            }
        }
        loadImage()
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {return}
        //image = Image(uiImage: inputImage)
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func save() {
        guard let processedImage = processedImage else {return}
        let imageSaver = ImageSaver()
        imageSaver.successHandler = {
            showAlert(title: "Success", message: "Photo saved to library!")
        }
        imageSaver.errorHandler = {
            showAlert(title: "Error", message: "Something went wrong! \($0.localizedDescription)")
        }
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
    
    func exampleImage(_ filter: CIFilter, _ intensity: Double) -> Image? {
        guard let inputImage = inputImage else {return nil}
        let exampleFilter = filter
        let beginImage = CIImage(image: inputImage)
        exampleFilter.setValue(beginImage, forKey: kCIInputImageKey)
        let inputKeys = exampleFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            exampleFilter.setValue(intensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            exampleFilter.setValue(intensity * 10, forKey: kCIInputRadiusKey)
        }

//        if inputKeys.contains(kCIInputRadiusKey) {
//            currentFilter.setValue(intensity * 200, forKey: kCIInputRadiusKey)
//        }
//
//        if inputKeys.contains(kCIInputScaleKey) {
//            currentFilter.setValue(intensity * 10, forKey: kCIInputScaleKey)
//        }
        
        guard let outputImage = exampleFilter.outputImage else {return nil}
        if let cgimg = context.createCGImage(outputImage, from: outputImage .extent) {
            let uiImage = UIImage(cgImage: cgimg)
            processedImage = uiImage
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    func applyProcessing() {
        //currentFilter.intensity = Float(filterIntensity)
        let inputKeys = currentFilter.inputKeys
        print(inputKeys)
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIRadius * 20, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIScale * 15, forKey: kCIInputScaleKey)
        }
        guard let outputImage = currentFilter.outputImage else {return}
        if let cgimg = context.createCGImage(outputImage, from: outputImage .extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
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
