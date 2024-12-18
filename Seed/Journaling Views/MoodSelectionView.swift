import SwiftUI
import NavigationTransitions
import SwiftData

struct MoodSelectionView: View {
    
    var selectedGardenElement: GardenElementData
    @State private var moodValue: Double = 1.0 // Slider value to represent mood
    @State private var navigateToGratitudeView = false // Tracks navigation to GratitudeView
    @Query private var lessons: [LessonInfor]// Automatically query all lessons from the model context
    var journalingLessonCount: Int {
        lessons.first(where: { $0.name == "Journaling" })?.count ?? 0
    }
    @State private var type: String = "journaling"
    @State private var tab: String = "mindfulness"
    @State private var activity: String = "nature"
    @State var oracle_prompt: String = ""
    @State var oracle_prompt_id: Int = 0;
    
    
    @Environment(\.modelContext) private var modelContext
    
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
                    
                    // Decorative Circle with Image
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 5)
                        
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
                    }
                    .padding(.bottom, 30)
                    
                    // Title Text
                    Text("How are you feeling right now?")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                        .shadow(radius: 5)
                    
                    // Mood Icons and Slider
                    VStack {
                        HStack {
                            // Mood Faces
                            Image("sad") // Replace with custom sad face asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color.blue.opacity(0.8))
                            
                            Spacer()
                            
                            Image("middle") // Replace with custom neutral face asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color.orange.opacity(0.8))
                            
                            Spacer()
                            
                            Image("smile") // Replace with custom happy face asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color.green.opacity(0.8))
                        }
                        .padding(.horizontal, 30)
                        
                        // Slider
                        Slider(
                            value: $moodValue,
                            in: 1...3,
                            step: 1
                        )
                        .accentColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 50)
                    
                    Spacer()
                    
                    // Continue Button with Fade Transition
                    NavigationStack{
                        Button(action: {
                            saveOraclePromptAnswer(id: oracle_prompt_id, answer: String(format: "%.0f", moodValue))
                            navigateToGratitudeView = true
                        }){
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
                                .shadow(radius: 5)
                        }
                        .onTapGesture {
                            navigateToGratitudeView = true
                        }
                        .navigationDestination(isPresented: $navigateToGratitudeView) {
                            GratitudeView(selectedGardenElement: selectedElement, type: type, tab: tab, activity: activity, level : journalingLessonCount)
                                .navigationBarHidden(true)
                        }
                    }
                    .padding(.bottom, 50)
                    .buttonStyle(PlainButtonStyle())
                    .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 1.0)))// Fade transition// Avoid default NavigationLink styling
                }
            }
            .onAppear{
                
                fetchOraclePrompt()
            }
        }
    }
    
    func fetchOraclePrompt() {

        let fetchRequest = FetchDescriptor<OraclePrompt>(
            predicate: #Predicate {
                $0.type == type &&
//                $0.tab == tab &&
//                $0.activity == activity &&
                $0.level == journalingLessonCount &&
                $0.seq == 1
            },
            sortBy: [
                SortDescriptor(\OraclePrompt.level),  // Sort by level
                SortDescriptor(\OraclePrompt.seq)     // Then sort by seq
            ]
        )

        do {
            
            let fetchedResults = try modelContext.fetch(fetchRequest)
            
            if let firstPrompt = fetchedResults.first {
               
               oracle_prompt = firstPrompt.text
               oracle_prompt_id = firstPrompt.id
               
           } else {
               
               print("No oracle prompts found matching the criteria.")
           }

        } catch {
            print("Failed to fetch OraclePrompt: \(error)")
        }
    }
    
    func saveOraclePromptAnswer(id: Int, answer: String) {
                    
        let promptAnswer = OraclePromptAnswer(
            type: type,
            prompt_id: id,
            tab: tab,
            activity: activity,
            level:  journalingLessonCount,
            answer: answer,
            date: Date()
        )
        
        do {
            modelContext.insert(promptAnswer)
            try modelContext.save()
            print("OraclePromptAnswer saved successfully.")
        } catch {
            print("Failed to save OraclePromptAnswer: \(error)")
        }
    }
}

//struct MoodSelectionView_Previews: PreviewProvider {
//    static var gardenElements: GardenElementData =
//    GardenElementData(name: "christmastree", type: .png("christmastree"))
//    static var previews: some View {
//        MoodSelectionView(selectedGardenElement: gardenElements)
//    }
//}
