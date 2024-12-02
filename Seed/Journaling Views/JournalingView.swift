import SwiftUI
import NavigationTransitions

struct JournalingView: View {
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    @State private var showWelcomeText = true
    @State private var displayedText = ""
    @State private var isComplete = false
    @State private var isLearnMorePressed = false // Tracks whether "Learn More" has been pressed
    @State private var animationTaskID = UUID()  // Unique ID for tracking animation tasks
    @State private var navigateToMoodSelection = false // Tracks navigation to MoodSelectionView

    var body: some View {
        let backgroundGradient = LinearGradient(
            gradient: Gradient(colors: [Color.yellow.opacity(0.7), Color.orange.opacity(0.6)]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        let lightPink = Color(hue: 0.89, saturation: 0.4, brightness: 1.0, opacity: 1.0)
        let fullText = "Journaling can reduce stress by helping you process emotions, clarify thoughts, and release pent-up feelings, promoting better mental health."
        let learnMoreText = "In this section, reflect on your emotions with guided questions. Answer freely and review your entries anytime on the summary page."

        NavigationStack {
            ZStack {
                // Background gradient
            
                PlayerView()
                    .ignoresSafeArea()
                Color.yellow
                        .opacity(0.2) // Adjust transparency as needed
                        .ignoresSafeArea()
                
                VStack {
                    // Pulsing circle at the top
                    ZStack {
                        Circle()
                            .stroke(lightPink.opacity(0.3), lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .scaleEffect(outerCircleScale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    outerCircleScale = 1.2
                                }
                            }
                        
                        Circle()
                            .fill(lightPink.opacity(0.6))
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
                            .opacity(showWelcomeText ? 1 : 0)
                            .padding(.top, -60)
                            .shadow(radius: 5)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    showWelcomeText = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        showWelcomeText = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        startTextAnimation(fullText: fullText)
                                    }
                                }
                            }
                    } else {
                        Text(displayedText)
                            .font(Font.custom("Visby", size: 22))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .lineSpacing(10)
                            .shadow(radius: 5)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 300, alignment: .top)
                            .opacity(displayedText.isEmpty ? 0 : 1)
                    }

                    Spacer()
                    
                    // Action buttons
                    HStack(spacing: isLearnMorePressed ? 0 : 40) {
                        // Learn More Button (fades out when pressed)
                        if !isLearnMorePressed {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    isLearnMorePressed = true // Trigger fade-out
                                }
                                cancelTextAnimation() // Cancel any running animation
                                startTextAnimation(fullText: learnMoreText) // Start new text animation
                            }) {
                                Text("Learn More")
                                    .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                    .padding()
                                    .frame(minWidth: 150)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [Color.orange, Color.red]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                    )
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            }
                            .transition(.opacity) // Smooth fade-out
                        }

                        // Start Button (fades in and moves to center)
                        NavigationLink(destination: MoodSelectionView().navigationBarHidden(true), isActive: $navigateToMoodSelection) {
                            Button(action: {
                                navigateToMoodSelection = true
                            }) {
                                Text("Start")
                                    .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                    .padding()
                                    .frame(minWidth: 150)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [Color.green, Color.teal]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                    )
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            }
                            .transition(.opacity) // Smooth fade-in
                        }
                    }
                    .frame(maxWidth: .infinity) // Ensures proper centering
                    .padding(.bottom, 50)
                    .animation(.easeInOut(duration: 1.5), value: isLearnMorePressed) // Animates position changes
                }
            }
            .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 1.5))) // Fade transition between views
        }
    }
    
    /// Starts a word-by-word text animation.
    func startTextAnimation(fullText: String) {
        cancelTextAnimation() // Ensure no overlapping animations
        animationTaskID = UUID() // Create a new task identifier
        displayedText = "" // Clear any existing text
        
        let words = fullText.split(separator: " ").map(String.init)
        var delay: Double = 0.1
        let currentTaskID = animationTaskID // Capture the task ID for this animation

        for (index, word) in words.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if currentTaskID == animationTaskID { // Ensure this is the latest animation
                    withAnimation(.easeInOut(duration: 0.6)) {
                        displayedText += word + " "
                    }
                }
            }
            delay += (index == 0 ? 1.2 : 0.4)
        }
    }
    
    /// Cancels any ongoing text animation.
    func cancelTextAnimation() {
        animationTaskID = UUID() // Invalidate any pending tasks
        displayedText = "" // Clear the text immediately
    }
}

//struct JournalingView_Previews: PreviewProvider {
//    static var previews: some View {
//        JournalingView()
//    }
//}
