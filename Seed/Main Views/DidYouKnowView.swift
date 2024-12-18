import SwiftUI
import NavigationTransitions
import SwiftData


struct DidYouKnowView: View {
    @State private var displayedText = ""
    @State private var showTitleText = false // Controls the "Did you know?" fade-in
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    @State private var isAnimatingText = false
    @State private var navigateToMeditationView = false // Tracks navigation to MeditationView
    var selectedTime: String? // 接收傳遞的時間
    
    @Environment(\.modelContext) private var modelContext
    @State private var oracleFacts_meditation: [OracleFact] = []
    
    private let titleText = "Did you know?"
    @State private var descriptionText = """
    Meditation can physically change your brain. It can also reduce the size of the amygdala, which is associated with stress and fear.
    """
    
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
                // Background Color
                PlayerView()
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 20) {
                        // Pulsing oracle circle
                        ZStack {
                            Circle()
                                .stroke(lightpink.opacity(0.3), lineWidth: 2)
                                .frame(width: 60, height: 60)
                                .scaleEffect(outerCircleScale)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                        outerCircleScale = 1.2
                                    }
                                }
                            
                            Circle()
                                .fill(lightpink.opacity(0.6))
                                .frame(width: 40, height: 40)
                                .scaleEffect(innerCircleScale)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                        innerCircleScale = 0.9
                                    }
                                }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 50)
                        
                        // "Did you know?" title text with fade-in animation
                        Text(titleText)
                            .font(Font.custom("Visby", size: 30))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .shadow(radius: 5)
                            .opacity(showTitleText ? 1 : 0) // Starts hidden
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    showTitleText = true
                                }
                                
                                // Start animating the description text after the title fades in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    animateDescriptionText()
                                }
                            }
                        
                        // Word-by-word fade-in animation for description
                        Text(displayedText)
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 22))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 300, alignment: .top) // Fixed height
                            .padding(.horizontal, 50)
                            .shadow(radius: 5)
                            .padding(.top, 30)
                    }
                    Spacer() // Push buttons to the bottom
                    
                    // Action Buttons
                    HStack(spacing: 20) {
                        // Learn More Button
                        Button(action: {
                            changeOracleFacts()
                        }) {
                            Text("Learn More")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(buttonColors[0])
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        // Continue Button
                        Button(action: {
                            navigateToMeditationView = true // 设置状态以触发导航
                        }) {
                            Text("Continue")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(buttonColors[1])
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        NavigationLink(
                            value: selectedTime,
                            label: { EmptyView() } // 占位，触发条件为 `navigateToMeditationView`
                        )
                        .navigationDestination(isPresented: $navigateToMeditationView) {
                            MeditationView(selectedTime: selectedTime)
                                .navigationBarHidden(true)
                        }
                    }
                    .padding(.bottom, 30) // Bottom padding for buttons
                }
            }
        }
        .navigationBarHidden(true)
    }

    func animateDescriptionText() {
        
        displayedText = ""
        let words = descriptionText.split(separator: " ").map(String.init)
        var delay: Double = 0.1
        
        for word in words {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    displayedText += word + " "
                }
            }
            delay += 0.3 // Adjust delay for word-by-word effect
        }
        
        // Ensure animation does not re-run unintentionally
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            isAnimatingText = true
        }
    }
    
    func fetchOracleFacts(randomOracleId: Int) {
        
        let fetchRequest = FetchDescriptor<OracleFact>(
            predicate: #Predicate { $0.id == randomOracleId && $0.type == "meditation"}
        )
        
        do {
            
            let  oracleFacts = try modelContext.fetch(fetchRequest)
            
            if (oracleFacts_meditation.isEmpty) {
                
                descriptionText = oracleFacts
                    .map { $0.text }
                    .joined(separator: " ")
            }
            
        } catch {
            print("Failed to fetch fetchOracleFacts: \(error)")
        }
    }
    
    private func  changeOracleFacts(){
        
        let changeOracleId = Int.random(in: 1...10)
        fetchOracleFacts(randomOracleId: changeOracleId)
        animateDescriptionText()
        
    }
    
}

struct DidYouKnowView_Previews: PreviewProvider {
    static var previews: some View {
        DidYouKnowView()
    }
}
