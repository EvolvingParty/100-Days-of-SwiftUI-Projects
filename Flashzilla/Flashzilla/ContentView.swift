//
//  ContentView.swift
//  Flashzilla
//
//  Created by Kurt L on 26/1/2023.
//

import SwiftUI

struct PressesView: View {
    @State private var colourOfGlobe = Color.blue
    @State private var displayText = "Hello, world!"

    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    
    @State private var currentRotationAmount = Angle.zero
    @State private var finalRotationAmount = Angle.zero
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(colourOfGlobe)
                .onTapGesture {
                    print("Image taooed")
                }
            Text(displayText)
                .onTapGesture {
                    print("Text taooed")
                }
        }
        .onTapGesture {
            print("VStack taooed") // <- Not registered user .highPriorityGesture and the child will not register. To register both use a simultaneousGesture
        }
        .highPriorityGesture( //simultaneousGesture
            TapGesture()
                .onEnded {print("VStack taooed") }
        )
        .scaleEffect(finalAmount + currentAmount)
        .gesture(
            MagnificationGesture()
                .onChanged() { amount in
                    currentAmount = amount - 1
                }
                .onEnded() { amount in
                    finalAmount += currentAmount
                    currentAmount = 0
                }
        )
        .rotationEffect(finalRotationAmount + currentRotationAmount)
        .gesture(
            RotationGesture()
                .onChanged() { angle in
                    currentRotationAmount = angle
                }
                .onEnded() { amount in
                    finalRotationAmount += currentRotationAmount
                    currentRotationAmount = .zero
                }
        )
        .onTapGesture(count: 2) {
            colourOfGlobe = Color.red
            displayText = "Double Tap Success"
        }
        .onLongPressGesture(minimumDuration: 4) {
            colourOfGlobe = Color.green
            displayText = "Long Press Success"
        } onPressingChanged: { inProgress in
            displayText = "Long Press in progress"
        }
        .onTapGesture {
            colourOfGlobe = Color.blue
            displayText = "Hello, world!"
        }
    }
}

struct CompoundTouchesView: View {
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        let combined = pressGesture.sequenced(before: dragGesture)
        
        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1.0)
            .offset(offset)
            .gesture(combined)
    }
}

import CoreHaptics
struct VibrationsAndCoreHapticsView: View {
    
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        VStack {
            VStack {
                Text("Success")
                    .foregroundColor(.blue)
            }
            .padding()
            .onTapGesture (perform: simpleSuccess)
            VStack {
                Text("Warning")
                    .foregroundColor(.blue)
            }
            .padding()
            .onTapGesture (perform: {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            })
            VStack {
                Text("Error")
                    .foregroundColor(.blue)
            }
            .padding()
            .onTapGesture (perform: {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            })
            VStack {
                Text("Complex Success")
                    .foregroundColor(.blue)
            }
            .padding()
            .onTapGesture (perform: {
                complexSuccess()
            })
            VStack {
                Text("Stride")
                    .foregroundColor(.blue)
            }
            .padding()
            .onTapGesture (perform: {
                playStride()
            })
        }
        .onAppear(perform: { prepareHantics() })
    }
    
    func simpleSuccess () {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func prepareHantics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func playStride() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
}

struct AllowsHitTestingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame (width: 300, height: 300)
                .onTapGesture {
                    print ("Rectanale tapped!")
                }
            
            Circle()
                .fill(.red)
                .contentShape(Rectangle()) // <- befreo frame
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Circle tapped!")
                }
                //.allowsHitTesting(false) <- disables tap
                //.contentShape(Rectangle()) <- after frame
        }
    }
}

struct TimersView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Count = \(counter)")
        }
        .padding()
        .onReceive (timer) { time in
            if counter == 5 {
                timer.upstream.connect().cancel()
            } else {
                counter += 1
            }
        }
    }
}

struct ScenePhaseChangeView: View {
    @Environment(\ .scenePhase) var scenePhase
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print ("Active")
            } else if newPhase == .inactive {
                print ("Inactive")
            } else if newPhase == .background {
                print ( "Background" )
            }
        }
    }
}


func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body ()
    } else {
        return try withAnimation (animation, body)
    }
}
    
struct SupportingAccessibility: View {
    @Environment (\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment (\.accessibilityReduceMotion) var reduceMotion
    @Environment (\.accessibilityReduceTransparency) var reduceTransparency
    
    @State private var scale = 1.0
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .scaleEffect(scale)
        .onTapGesture {
            withOptionalAnimation {
                scale *= 1.5
            }
        }
    }
}

extension View  {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset*3)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @State private var cards = [Card]()//Array<Card>(repeating: Card.example, count: 10)
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showingEditScreen = false
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text ("Time remaining: \(timeRemaining)s")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5).background(.black.opacity (0.75))
                    .clipShape(Capsule())
                    .padding(.bottom, 10)
                ZStack {
                    ForEach (0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again".uppercased(), action: resetCards)
                        .font(.headline)
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                }
            }
            .padding(.top, -20)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image (systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity (0.7))
                            .clipShape (Circle ())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard (at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle ())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as incorrect")
                        Spacer()
                        Button {
                            withAnimation {
                                removeCard (at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle ())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as correct")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        //cards = Array<Card>(repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
        loadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        PressesView()
//            .previewDisplayName("Presses")
//        CompoundTouchesView()
//            .previewDisplayName("Compound Touches")
//        VibrationsAndCoreHapticsView()
//            .previewDisplayName("Vibrations CoreHaptics")
//        AllowsHitTestingView()
//            .previewDisplayName("Allows Hit Testing")
//        TimersView()
//            .previewDisplayName("Timers")
//        ScenePhaseChangeView()
//            .previewDisplayName("ScenePhases")
        ContentView()
    }
}
