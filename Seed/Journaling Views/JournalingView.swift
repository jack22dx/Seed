import SwiftUI
import NavigationTransitions
import SwiftData

struct JournalingView: View {
    
    static let gardenElements: [GardenElementData] = [
        GardenElementData(name: "mountains", type: .png("mountains")),
        GardenElementData(name: "mushroom", type: .gif("mushroom")),
        GardenElementData(name: "christmastree", type: .png("christmastree")),
        GardenElementData(name: "purplerose", type: .png("purplerose")),
        GardenElementData(name: "deer", type: .png("deer")),
        GardenElementData(name: "cherryblossom", type: .png("cherryblossom")),
        GardenElementData(name: "rose", type: .png("rose"))
    ]
    @Query private var lessons: [LessonInfor]  // Automatically query all lessons from the model context
    var journalingLessonCount: Int {
        lessons.first(where: { $0.name == "Journaling" })?.count ?? 0
    }
    // Compute selected garden element based on time
    var selectedGardenElement: GardenElementData {
        let filteredElements: [GardenElementData]
        switch journalingLessonCount {
        case ...3:
            filteredElements = Self.gardenElements.filter { ["rose", "cherryblossom"].contains($0.name) }
        case 3...6:
            filteredElements = Self.gardenElements.filter { ["deer", "purplerose"].contains($0.name) }
        case 7...:
            filteredElements = Self.gardenElements.filter { ["christmastree", "mushroom", "mountains"].contains($0.name) }
        default:
            filteredElements = []
        }
        
        return filteredElements.randomElement() ?? Self.gardenElements.first { $0.name == "sunflower" }!
    }
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    @State private var showWelcomeText = true
    @State private var displayedText = ""
    @State private var navigateToTabs = false

    var body: some View {
        
        let selectedElement = selectedGardenElement
//        let backgroundGradient = LinearGradient(
//            gradient: Gradient(colors: [Color.yellow.opacity(0.7), Color.orange.opacity(0.6)]),
//            startPoint: .top,
//            endPoint: .bottom
//        )
        
        let lightPink = Color(hue: 0.89, saturation: 0.4, brightness: 1.0, opacity: 1.0)
        let fullText = "Journaling can reduce stress by helping you process emotions, clarify thoughts, and release pent-up feelings, promoting better mental health."
        let learnMoreText = "In this section, reflect on your emotions with guided questions. Answer freely and review your entries anytime on the summary page."

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

                        // Start Button (fades in and moves to center)
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
                        .navigationDestination(isPresented: $navigateToMoodSelection){
                            MoodSelectionView(selectedGardenElement:selectedElement)
                                .navigationBarHidden(true)
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

struct JournalingView_Previews: PreviewProvider {
    static var previews: some View {
        JournalingView()
    }
}
