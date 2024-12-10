import SwiftUI
import AVFoundation
import SwiftData

struct MeditationStartView: View {
    
    var selectedTime : String
    var selectedGardenElement: GardenElementData
    @State private var timeRemaining: Int = 0 // Timer will dynamically reflect the audio duration
    @State private var isPlaying: Bool = false
    @State private var player: AVAudioPlayer?
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    @State private var timer: Timer? // Keep track of the timer
    @State private var showContinueButton: Bool = false // Tracks whether the Continue button should appear
    @State private var navigateToSummary: Bool = false // Navigation state
    
    //for oracle
    @Environment(\.modelContext) private var modelContext
    @State private var oracleTips_meditation: [OracleTip] = []
    @State private var clickTipBtn: Bool = false

    
    var body: some View {
        
        let selectedElement = selectedGardenElement
        
        let lightpink = Color(hue: 0.89, saturation: 0.4, brightness: 1, opacity: 1.0)
        let buttonColors = [
            LinearGradient(
                gradient: Gradient(colors: [Color.orange, Color.red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.teal]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ]
        NavigationStack {
            ZStack {
                
                PlayerView()
                    .ignoresSafeArea()
                Color.blue
                    .opacity(0.2) // Adjust transparency as needed
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title
                    Text(selectedElement.name)
                        .font(Font.custom("Visby", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    // Tree Icon above the pulsing circles
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 100, height: 100)
                            .shadow(radius: 10)
                        
                        switch selectedElement.type {
                        case .png(let imageName):
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        case .gif(let gifName):
                            GIFView(gifName: gifName)
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        }
                        
                        //                        Image("treeseed") // Replace with your tree icon
                        //                            .resizable()
                        //                            .scaledToFit()
                        //                            .frame(width: 80, height: 80)
                        //                            .clipShape(Circle())
                    }
                    .padding(.bottom, 10)
                    
                    // Pulsing Circles
                    ZStack {
                        Circle()
                            .stroke(lightpink.opacity(0.3), lineWidth: 2)
                            .frame(width: 200, height: 200)
                            .scaleEffect(outerCircleScale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    outerCircleScale = 1.2
                                }
                            }
                        
                        Circle()
                            .fill(lightpink.opacity(0.6))
                            .frame(width: 140, height: 140)
                            .scaleEffect(innerCircleScale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    innerCircleScale = 0.9
                                }
                            }
                    }
                    .padding(.bottom,10)
                    
                    //tip btn
                    Button(action: {
                        isPlaying = false
                        player?.pause()
                        timer?.invalidate()
                        self.clickTipBtn = true
                    }) {
                        Text("Tips")
                            .font(Font.custom("Visby", size: 18))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(Color.purple)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .navigationDestination(isPresented: $clickTipBtn)
                    {
                        MeditationOracleTipsView(oracleTips: oracleTips_meditation)
                    }
                    
                    // Timer Display
                    Text(timeFormatted(timeRemaining))
                        .font(Font.custom("Visby", size: 24))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    // Playback Controls or Continue Button
                    if showContinueButton {
                        Button(action: {
                            navigateToSummary = true // Set the state to trigger navigation
                        }) {
                            Text("Continue")
                                .font(Font.custom("Visby", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(buttonColors[1])
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .opacity(showContinueButton ? 1 : 0) // Fade effect
                                .animation(.easeInOut(duration: 3), value: showContinueButton) // Smooth fade
                        }
                        // Navigation Destination
                        .navigationDestination(isPresented: $navigateToSummary) {
                            MeditationSummaryView(
                                selectedGardenElement: selectedElement,
                                selectedTime: selectedTime
                            )
                            .navigationBarHidden(true)
                        }
                        .padding(.top, 30)
                    } else {
                        // Playback Controls
                        HStack(spacing: 50) {
                            // Backward Button
                            Button(action: {
                                rewindAudio(by: 10)
                                timeRemaining = min(timeRemaining + 10, Int(player?.duration ?? 0)) // Add time
                            }) {
                                Image(systemName: "gobackward.10")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                            }
                            .opacity(showContinueButton ? 0 : 1) // Fade out effect
                            .animation(.easeInOut(duration: 2), value: showContinueButton)
                            
                            // Play/Pause Button
                            Button(action: {
                                togglePlayback()
                            }) {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                            }
                            .opacity(showContinueButton ? 0 : 1) // Fade out effect
                            .animation(.easeInOut(duration: 2), value: showContinueButton)
                            
                            // Forward Button
                            Button(action: {
                                forwardAudio(by: 10)
                                timeRemaining = max(timeRemaining - 10, 0) // Subtract time
                            }) {
                                Image(systemName: "goforward.10")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                            }
                            .opacity(showContinueButton ? 0 : 1) // Fade out effect
                            .animation(.easeInOut(duration: 2), value: showContinueButton)
                        }
                        .padding(.top, 30)
                    }
                }
                .onAppear {
                    setupAudio()
                    togglePlayback()
                    fetchOracleTips()
                }
                .onDisappear {
                    timer?.invalidate() // Stop the timer if the view is dismissed
                }
            }
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
        .navigationBarHidden(true)
    }
    
    // MARK: - Helper Methods
    func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func setupAudio() {
        guard let url = Bundle.main.url(forResource: "FreeMindfulness3MinuteBreathing", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            timeRemaining = Int(player?.duration ?? 0) // Set the timer based on the audio duration
        } catch {
            print("Audio player setup failed: \(error.localizedDescription)")
        }
    }
    
    func startTimer() {
        timer?.invalidate() // Reset any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                isPlaying = false
                player?.stop()
                withAnimation {
                    showContinueButton = true // Show the Continue button
                }
            }
        }
    }
    
    func togglePlayback() {
        if isPlaying {
            player?.pause()
            timer?.invalidate() // Pause the timer
        } else {
            player?.play()
            startTimer() // Restart the timer
        }
        isPlaying.toggle()
    }
    
    func rewindAudio(by seconds: Int) {
        guard let player = player else { return }
        player.currentTime = max(player.currentTime - Double(seconds), 0)
        if isPlaying {
            player.play()
        }
    }
    
    func forwardAudio(by seconds: Int) {
        guard let player = player else { return }
        player.currentTime = min(player.currentTime + Double(seconds), player.duration)
        if isPlaying {
            player.play()
        }
    }
    
    func fetchOracleTips() {
        
        let fetchRequest = FetchDescriptor<OracleTip>(
            predicate: #Predicate { $0.type == "meditation" },
            sortBy: [
                SortDescriptor(\OracleTip.level),  // Sort by level
                SortDescriptor(\OracleTip.seq)     // Then sort by seq
            ]
        )
        
        do {
            
            let  oracleTips = try modelContext.fetch(fetchRequest)
            
            if (oracleTips_meditation.isEmpty) {
                
                oracleTips_meditation.removeAll();
                
                for tip in oracleTips {
                    
                    oracleTips_meditation.append(tip)
                }
            }
            
        } catch {
            print("Failed to fetch OracleTips: \(error)")
        }
    }
}

// MARK: - Tips Views
struct MeditationOracleTipsView: View {
    
    let oracleTips: [OracleTip]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                
                Color.blue
                    .opacity(0.2) // Adjust transparency as needed
                    .ignoresSafeArea()
                
                VStack {
                    Text("Meditation Tips")
                        .font(Font.custom("Visby", size: 30))
                        .foregroundColor(.white)
                        .padding()
                    
                    ScrollView {
                        
                        // Use ForEach to display the oracleTips
                        ForEach(oracleTips, id: \.seq) { tip in
                            Text("\(tip.seq). \(tip.text)")
                                .font(Font.custom("Visby", size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .lineSpacing(10)
                        }
                    }
                    .frame(height: geometry.size.height * 0.6) // screen height 60%
                    
                    // scroll more icon
                    VStack {
                        Spacer()
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.bottom, 8)
                        Text("Scroll down for more")
                            .font(Font.custom("Visby", size: 14))
                            .foregroundColor(.white)
                    }
                    .opacity(0.8)
                    
                    Spacer()
                }
            }
        }
    }
}

struct MeditationStartView_Previews: PreviewProvider {
    static var gardenElements: GardenElementData =
    GardenElementData(name: "Flower", type: .png("flower"))

    static var previews: some View {
        MeditationStartView(selectedTime: "3",selectedGardenElement: gardenElements)
    }
}
