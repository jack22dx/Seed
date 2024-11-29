import SwiftUI
import AVFoundation

struct MeditationStartView: View {
    @State private var timeRemaining: Int = 0 // Timer will dynamically reflect the audio duration
    @State private var isPlaying: Bool = false
    @State private var player: AVAudioPlayer?
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    @State private var timer: Timer? // Keep track of the timer
    @State private var showContinueButton: Bool = false // Tracks whether the Continue button should appear
    @State private var navigateToSummary: Bool = false // Navigation state
    
    var body: some View {
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
                    Text("Crimson Oak Tree")
                        .font(Font.custom("Visby", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    // Tree Icon above the pulsing circles
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 100, height: 100)
                            .shadow(radius: 10)
                        
                        Image("treeseed") // Replace with your tree icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 57)
                    
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
                    
                    // Timer Display
                    Text(timeFormatted(timeRemaining))
                        .font(Font.custom("Visby", size: 24))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    // Playback Controls or Continue Button
                    if showContinueButton {
                        // Continue Button (Fades in)
                        NavigationLink(destination: MeditationSummaryView()
                                        .navigationBarHidden(true), isActive: $navigateToSummary) {
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
}

struct MeditationStartView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationStartView()
    }
}
