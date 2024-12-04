import SwiftUI

struct JournalingView: View {
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    @State private var showWelcomeText = true
    @State private var displayedText = ""
    @State private var navigateToTabs = false

    var body: some View {
        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                Color.yellow
                    .opacity(0.2)
                    .ignoresSafeArea()

                VStack {
                    // Pulsating circle at the top
                    ZStack {
                        Circle()
                            .stroke(Color.pink.opacity(0.3), lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .scaleEffect(outerCircleScale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    outerCircleScale = 1.2
                                }
                            }

                        Circle()
                            .fill(Color.pink.opacity(0.6))
                            .frame(width: 40, height: 40)
                            .scaleEffect(innerCircleScale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    innerCircleScale = 1.1
                                }
                            }
                    }
                    .padding(.top, 60)

                    Spacer()

                    // Main content area
                    if showWelcomeText {
                        Text("Welcome to your Journaling Area")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .shadow(radius: 5)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 5)) {
                                    showWelcomeText = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    startTextAnimation("Journaling helps process emotions, reduce stress, and reflect on experiences.")
                                }
                            }
                    } else {
                        Text(displayedText)
                            .font(Font.custom("Visby", size: 20))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .lineSpacing(8)
                            .shadow(radius: 5)
                            .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .top)
                    }

                    Spacer()

                    // Navigation button
                    NavigationLink(destination: JournalingTabsView(), isActive: $navigateToTabs) {
                        Button("Continue") {
                            navigateToTabs = true
                        }
                        .padding()
                        .frame(minWidth: 150)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.teal]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }

    private func startTextAnimation(_ fullText: String) {
        displayedText = ""
        let words = fullText.split(separator: " ").map(String.init)
        var delay: Double = 0.1
        for word in words {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                displayedText += word + " "
            }
            delay += 0.2
        }
    }
}
