import SwiftUI
import NavigationTransitions

struct MeditationIntroView: View {
    @State private var displayedText = ""
    @State private var isComplete = false
    private let fullText = "Welcome. To unlock your first seed, I will be guiding you through your first meditation practice."

    var body: some View {
        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                
                // Text with fade-in animation and fixed frame to prevent shifting
                Text(displayedText)
                    .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4)
                    .opacity(displayedText.isEmpty ? 0 : 1)
                    .onAppear {
                        // Delay before starting the text animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            animateText()
                        }
                    }
                
                // Invisible NavigationLink to trigger fade transition to MeditationView
                NavigationLink(
                    destination: MeditationView()
                        .navigationBarHidden(true), // Hide navigation bar in MeditationView as well
                    isActive: $isComplete
                ) {
                    EmptyView()
                }
                .hidden() // Keep the link hidden
            }
            .background(Color.black.opacity(0.7).ignoresSafeArea())
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2)))
        .navigationBarHidden(true) // Hide the navigation bar in this view
    }
    
    func animateText() {
        let words = fullText.split(separator: " ").map(String.init)
        var delay: Double = 0.1
        
        for (index, word) in words.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    displayedText += word + " "
                }
            }
            // Apply a longer pause after "Welcome."
            delay += (index == 0 ? 1.2 : 0.4) // Adjust delay after first word
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
