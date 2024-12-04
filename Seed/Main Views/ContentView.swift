import SwiftUI
import AVKit

// Custom UIView for the second video without looping
class SecondPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Use the local video file URL from the app bundle
        guard let fileURL = Bundle.main.url(forResource: "plant-1", withExtension: "mov") else {
            fatalError("plant-1.mov not found")
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
    @State private var showText = false
    @State private var showMeditationButton = false
    @State private var showJournalingButton = false
    @State private var showDigitalDetoxButton = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background videos
                PlayerView()
                    .ignoresSafeArea()
                SecondPlayerView()
                    .ignoresSafeArea()

                VStack {
                    Text("What would you like to focus on?")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 24))
                        .foregroundColor(.white)
                        .opacity(showText ? 1 : 0)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 5)

                    VStack(spacing: 20) {
                        NavigationLink(destination: MeditationIntroView()) {
                            ActivityButton(title: "Meditation", colors: [Color.cyan, Color.teal])
                        }

                        NavigationLink(destination: JournalingView()) {
                            ActivityButton(title: "Journaling", colors: [Color.green, Color.yellow])
                        }

                        NavigationLink(destination: DigitalDetoxView()) {
                            ActivityButton(title: "Digital Detox", colors: [Color.gray, Color.orange])
                        }
                    }
                }
                .padding(.bottom, 50)
                .frame(maxHeight: .infinity, alignment: .top)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) { showText = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeIn(duration: 1)) { showMeditationButton = true }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        withAnimation(.easeIn(duration: 1)) { showJournalingButton = true }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation(.easeIn(duration: 1)) { showDigitalDetoxButton = true }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ActivityButton: View {
    let title: String
    let colors: [Color]

    var body: some View {
        Text(title)
            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
            .frame(maxWidth: .infinity)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(radius: 3)
            .padding(.horizontal, 40)
    }
}
