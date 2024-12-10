import SwiftUI
import NavigationTransitions
import SwiftData

struct JournalingView: View {
    @Query private var lessons: [LessonInfor]
    
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    @State private var showWelcomeText = true
    @State private var displayedText = ""
    @State private var isComplete = false
    @State private var isLearnMorePressed = false // Tracks whether "Learn More" has been pressed
    @State private var animationTaskID = UUID()  // Unique ID for tracking animation tasks
    @State private var navigateToMoodSelection = false // Tracks navigation to MoodSelectionView
    
    //    for oracle
    @Environment(\.modelContext) private var modelContext
    @State private var oracleFacts_journaling: [OracleFact] = []
    @State private var clickTimes = 0;
    @State private var  fullText = "A digital detox can reduce stress, improve focus, and boost your mood by giving your mind a chance to rest."
    
    
    var body: some View {
        let gardenElements: [GardenElementData] = [
            GardenElementData(name: "mountains", type: .png("mountains")),
            GardenElementData(name: "mushroom", type: .gif("mushroom")),
            GardenElementData(name: "christmastree", type: .png("christmastree")),
            GardenElementData(name: "purplerose", type: .png("purplerose")),
            GardenElementData(name: "deer", type: .png("deer")),
            GardenElementData(name: "cherryblossom", type: .png("cherryblossom")),
            GardenElementData(name: "rose", type: .png("rose"))
        ]
        
        var journalingLessonCount: Int {
            lessons.first(where: { $0.name == "Journaling" })?.count ?? 0
        }
        
        var selectedGardenElement: GardenElementData {
            let filteredElements: [GardenElementData]
            switch journalingLessonCount {
            case ...3:
                filteredElements = gardenElements.filter { ["rose", "cherryblossom"].contains($0.name) }
            case 3...6:
                filteredElements = gardenElements.filter { ["deer", "purplerose"].contains($0.name) }
            case 7...:
                filteredElements = gardenElements.filter { ["christmastree", "mushroom", "mountains"].contains($0.name) }
            default:
                filteredElements = gardenElements.filter { ["sunflower"].contains($0.name) }
            }
            return filteredElements.randomElement() ?? gardenElements.first { $0.name == "sunflower" }!
        }
        
        let selectedElement = selectedGardenElement
        
        let lightPink = Color(hue: 0.89, saturation: 0.4, brightness: 1.0, opacity: 1.0)
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
                                changeOracleFacts();
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
                        Button(action: {
                            clickTimes = clickTimes + 1
                            
                            if(clickTimes == 1){
                                
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    isLearnMorePressed = true;
                                    // Trigger fade-out
                                }
                                cancelTextAnimation() // Cancel any running animation
                                startTextAnimation(fullText: learnMoreText) // Start new text animation
                            }
                            
                            if(clickTimes > 1){
                                
                                navigateToMoodSelection = true
                                
                            }
                            
                        }) {
                            Text(clickTimes == 1 ? "Continue" : "Start")
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
                        .navigationDestination(isPresented: $navigateToMoodSelection){
                            MoodSelectionView(selectedGardenElement:selectedElement)
                                .navigationBarHidden(true)
                        }
                    }
                    .frame(maxWidth: .infinity) // Ensures proper centering
                    .padding(.bottom, 50)
                    .animation(.easeInOut(duration: 1.0), value: isLearnMorePressed) // Animates position changes
                }
            }
            .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 1.0))) // Fade transition between views
        }
    }
    
    /// Starts a word-by-word text animation.
    func startTextAnimation(fullText: String) {
        displayedText = ""
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
    
    func fetchOracleFacts(randomOracleId: Int) {
        
        let fetchRequest = FetchDescriptor<OracleFact>(
            predicate: #Predicate { $0.id == randomOracleId && $0.type == "journaling"}
        )
        
        do {
            
            let  oracleFacts = try modelContext.fetch(fetchRequest)
            
            if (oracleFacts_journaling.isEmpty) {
                
                fullText = oracleFacts
                    .map { $0.text }
                    .joined(separator: " ")
            }
            
        } catch {
            print("Failed to fetch fetchOracleFacts: \(error)")
        }
    }
    
    private func  changeOracleFacts(){
        let changeOracleId = Int.random(in: 1...8)
        fetchOracleFacts(randomOracleId: changeOracleId)
        startTextAnimation(fullText: fullText)
        
    }
}

struct JournalingView_Previews: PreviewProvider {
    static var previews: some View {
        JournalingView()
    }
}
