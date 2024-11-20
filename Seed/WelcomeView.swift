import SwiftUI
import SDWebImageSwiftUI
import AVKit
import AVFoundation
import NavigationTransitions // Import the package

// Custom UIView to handle video playback
class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Use the local video file URL from the app bundle
        guard let fileURL = Bundle.main.url(forResource: "Gradient", withExtension: "mp4") else {
            fatalError("Gradient.mp4 not found")
        }

        let player = AVPlayer(url: fileURL)
        player.actionAtItemEnd = .none // Prevent the player from stopping at the end
        player.play() // Start playing the video

        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill // Fill the screen with the video

        // Add an observer to loop the video
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)

        layer.addSublayer(playerLayer)
    }

    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil) // Loop the video
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds // Ensure the player layer fills the view
    }
}

// SwiftUI view to use PlayerUIView
struct PlayerView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

// Main WelcomeView with TabView for swiping
struct WelcomeView: View {
    @State private var currentPage = 0

    var body: some View {
        NavigationStack {
            ZStack {
                // Video Player Background
                PlayerView()
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    if currentPage == 0 {
                        Image("leaf")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.bottom, -90)
                            .padding(.top, 150)
                    } else if currentPage == 1 {
                        Image("treeseed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.bottom, -90)
                            .padding(.top, 150)
                    } else if currentPage == 2 {
                        AnimatedImage(name: "butterfly.gif")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.bottom, -90)
                            .padding(.top, 200)
                    }

                    TabView(selection: $currentPage) {
                        VStack {
                            Text("Seed")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 60))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                            Text("Your Mindfulness Garden")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 20))
                                .foregroundColor(.white)
                                .opacity(0.8)
                                .padding(.bottom, 40)
                                .shadow(radius: 5)
                        }
                        .tag(0)

                        VStack {
                            Text("Choose your mindfulness seeds")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .shadow(radius: 5)
                        }
                        .tag(1)

                        VStack {
                            Text("Grow your garden and watch it flourish")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .shadow(radius: 5)
                        }
                        .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .animation(.easeInOut, value: currentPage)

                    HStack {
                        // Skip Button
                        NavigationLink(destination: NameView()) {
                            Text("Skip")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 50)

                        Spacer()

                        if currentPage < 2 {
                            Button(action: {
                                withAnimation {
                                    currentPage += 1
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [Color.orange, Color.pink]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, weight: .bold))
                                }
                            }
                            .padding(.trailing, 50)
                        } else {
                            NavigationLink(destination: NameView()) {
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [Color.orange, Color.pink]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, weight: .bold))
                                }
                            }
                            .padding(.trailing, 50)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTransition(
            .fade(.in).animation(.easeInOut(duration: 2))
        ) // Apply the custom fade transition
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
