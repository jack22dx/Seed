import SwiftUI
import NavigationTransitions
import SwiftData

struct GratitudeView: View {
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
    @State private var gratitudeText: String = "" // For the user input in the text area
    @State private var navigateToSelfReflection = false // Tracks navigation to SelfReflectionView
    
    var body: some View {
        let selectedElement = selectedGardenElement
        NavigationStack {
            ZStack {
                // Background gradient
                PlayerView()
                    .ignoresSafeArea()
                Color.yellow
                    .opacity(0.2) // Adjust transparency as needed
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Decorative Circle with Flower Image
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 5)
                        
                        // Render image based on type
                        switch selectedElement.type {
                        case .png(let imageName):
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        case .gif(let gifName):
                            GIFView(gifName: gifName)
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        //                        Image("purplerose") // Replace with your flower asset if available
                        //                            .resizable()
                        //                            .scaledToFit()
                        //                            .frame(width: 90, height: 90)
                        //                            .foregroundColor(Color.purple)
                    }
                    .padding(.bottom, 30)
                    
                    // Title Text
                    Text("What’s one thing you’re grateful for today?")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .shadow(radius: 5)
                    
                    // Tips Button
                    Button(action: {
                        print("Tips button tapped")
                    }) {
                        Text("Tips")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .padding()
                            .frame(width: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.red.opacity(0.9), Color.orange.opacity(0.9)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                            )
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                    
                    // Text Input Area
                    TextEditor(text: $gratitudeText)
                        .padding()
                        .frame(height: 150)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // Continue Button with Fade Transition
                    Button(action: {
                        navigateToSelfReflection = true // Set the state to trigger navigation
                    }) {
                        Text("Continue")
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
                            .shadow(radius: 5)// Smooth fade
                    }
                    // Navigation Destination
                    .navigationDestination(isPresented: $navigateToSelfReflection) {
                        SelfReflectionView( selectedGardenElement: selectedElement)
                            .navigationBarHidden(true)
                    }
                    .padding(.bottom, 50)
                    .buttonStyle(PlainButtonStyle()).navigationTransition(.fade(.cross).animation(.easeInOut(duration: 1.0))) // Avoid default NavigationLink styling
                }
            }
        }
    }
}

struct GratitudeView_Previews: PreviewProvider {
    static var previews: some View {
        GratitudeView()
    }
}
