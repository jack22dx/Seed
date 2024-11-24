import SwiftUI
import NavigationTransitions

struct MeditationIntroView: View {
    @State private var displayedText = ""
    @State private var showWelcome = true
    @State private var isComplete = false
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    
    @AppStorage("userName") private var userName: String = "Friend" // Persistent storage for the user's name
    
    private var fullText: String {
        return "To unlock your first seed, I will be guiding you through your first meditation practice."
    }

    var body: some View {
        let lightpink = Color(hue: 0.89, saturation: 0.4, brightness: 1, opacity: 1.0)
        
        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                
                VStack {
                    // Pulsing circle at the top
                    ZStack {
                        Circle()
                            .stroke(lightpink.opacity(0.3), lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .scaleEffect(outerCircleScale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    outerCircleScale = 1.2 // Pulsing effect for the outer circle
                                }
                            }
                        
                        Circle()
                            .fill(lightpink.opacity(0.6))
                            .frame(width: 40, height: 40)
                            .scaleEffect(innerCircleScale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    innerCircleScale = 0.9 // Pulsing effect for the inner circle
                                }
                            }
                    }
                    .padding(.bottom, -60) // Adjust spacing to keep text visually centered
                    
                    // Main content area
                    Spacer()
                    
                    if showWelcome {
                        Text("Welcome, \(userName).")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .opacity(showWelcome ? 1 : 0)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    showWelcome = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        showWelcome = false
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        animateFullText()
                                    }
                                }
                            }
                    } else {
                        Text(displayedText)
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4)
                            .opacity(displayedText.isEmpty ? 0 : 1)
                    }
                    Spacer()
                }
                .navigationDestination(isPresented: $isComplete) {
                    DidYouKnowView() // Updated for iOS 16+ NavigationLink
                        .navigationBarHidden(true)
                }
            }
            .background(Color.black.opacity(0.7).ignoresSafeArea())
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2)))
        .navigationBarHidden(true)
    }
    
    func animateFullText() {
        let words = fullText.split(separator: " ").map(String.init)
        var delay: Double = 0.1
        
        for (index, word) in words.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    displayedText += word + " "
                }
            }
            delay += (index == 0 ? 1.2 : 0.4)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 2.0) {
            withAnimation(.easeInOut) {
                isComplete = true
            }
        }
    }
}

struct MeditationIntroView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationIntroView()
    }
}
