import SwiftUI
import AVFoundation

struct MeditationStart: View {
    @State private var timeRemaining: Int = 60 // Default time, will be set dynamically
    @State private var isPlaying: Bool = false
    @State private var player: AVAudioPlayer?
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    
    var meditationTime: Int // Time selected by the user
    
    var body: some View {
        let lightpink = Color(hue: 0.89, saturation: 0.4, brightness: 1, opacity: 1.0)
        
        ZStack {
            PlayerView()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title
                Text("Crimson Oak Tree")
                    .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                // Image and Pulsing Circle
                ZStack {
                    Circle()
                        .stroke(lightpink.opacity(0.3), lineWidth: 2)
                        .frame(width: 220, height: 220)
                        .scaleEffect(outerCircleScale)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                outerCircleScale = 1.2
                            }
                        }
                    
                    Circle()
                        .fill(lightpink.opacity(0.6))
                        .frame(width: 180, height: 180)
                        .scaleEffect(innerCircleScale)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                innerCircleScale = 0.9
                            }
                        }
                    
                    Image("treeseed") // Replace with your tree icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                // Timer Display
                Text(timeFormatted(timeRemaining))
                    .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 24))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                Spacer()
                
                // Playback Controls
                HStack {
                    // Backward Button
                    Button(action: {
                        rewindAudio(by: 10)
                    }) {
                        Image(systemName: "gobackward.10")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Play/Pause Button
                    Button(action: {
                        togglePlayback()
                    }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Forward Button
                    Button(action: {
                        forwardAudio(by: 10)
                    }) {
                        Image(systemName: "goforward.10")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 50)
            }
            .onAppear {
                setupAudio()
                timeRemaining = meditationTime
                startTimer()
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Helper Methods
    func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func setupAudio() {
        guard let url = Bundle.main.url(forResource: "meditation_audio", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            print("Audio player setup failed: \(error.localizedDescription)")
        }
    }
    
    func startTimer() {
        isPlaying = true
        player?.play()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                isPlaying = false
                player?.stop()
            }
        }
    }
    
    func togglePlayback() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
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

struct MeditationStart_Previews: PreviewProvider {
    static var previews: some View {
        MeditationStart(meditationTime: 60)
    }
}
