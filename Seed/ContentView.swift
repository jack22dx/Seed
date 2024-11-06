import SwiftUI
import CoreData
import SDWebImageSwiftUI
import AVKit
import AVFoundation

// Custom UIView for the second video without looping
class SecondPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Use the local video file URL from the app bundle
        guard let fileURL = Bundle.main.url(forResource: "plant-1", withExtension: "mov") else {
            fatalError("SecondVideo.mp4 not found")
        }
        
        let player = AVPlayer(url: fileURL)
        player.actionAtItemEnd = .pause // Pause the player when the video ends
        player.play() // Start playing the video

        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill // Fill the screen with the video
        layer.addSublayer(playerLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds // Ensure the player layer fills the view
    }
}

struct SecondPlayerView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return SecondPlayerUIView(frame: .zero)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ContentView: View {
    // State variables to control visibility
    @State private var showText = false
    @State private var showMeditationButton = false
    @State private var showJournalingButton = false
    @State private var showDigitalDetoxButton = false

    var body: some View {
        NavigationView {
            ZStack {
                // Video Player Background
                PlayerView()
                    .ignoresSafeArea()
                SecondPlayerView()
                    .ignoresSafeArea()

                VStack {
                    // "What would you like to focus on?" Text
                    Text("What would you like to focus on?")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 24))
                        .foregroundColor(.white)
                        .opacity(showText ? 1 : 0) // Fade-in effect
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 5)

                    // Navigation Buttons
                    VStack(spacing: 20) {
                        NavigationLink(destination: MeditationView()) {
                            Text("Meditation")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [Color.cyan, Color.teal]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .opacity(showMeditationButton ? 1 : 0) // Fade-in effect
                                .padding(.horizontal, 40)
                                .shadow(radius: 3)
                        }

                        NavigationLink(destination: JournalingView()) {
                            Text("Journaling")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.yellow]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .opacity(showJournalingButton ? 1 : 0) // Fade-in effect
                                .padding(.horizontal, 40)
                                .shadow(radius: 3)
                        }

                        NavigationLink(destination: DigitalDetoxView()) {
                            Text("Digital Detox")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [Color.gray, Color.orange]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .opacity(showDigitalDetoxButton ? 1 : 0) // Fade-in effect
                                .padding(.horizontal, 40)
                                .shadow(radius: 3)
                        }
                    }
                }
                .padding(.bottom, 50)
                .frame(maxHeight: .infinity, alignment: .top)
                .onAppear {
                    // Animate each element with a delay
                    withAnimation(.easeIn(duration: 1.5)) {
                        showText = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeIn(duration: 1)) {
                            showMeditationButton = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        withAnimation(.easeIn(duration: 1)) {
                            showJournalingButton = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation(.easeIn(duration: 1)) {
                            showDigitalDetoxButton = true
                        }
                      
                    }
                 
                }
                .navigationBarHidden(true)
            }
             // Hide the navigation bar on this screen
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
    
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
