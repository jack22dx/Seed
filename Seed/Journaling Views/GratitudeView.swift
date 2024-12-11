import SwiftUI
import NavigationTransitions
import SwiftData

struct GratitudeView: View {
    var selectedGardenElement: GardenElementData
    //for oracle
    @Environment(\.modelContext) private var modelContext
    @State private var oracleTips_journaling: [OracleTip] = []
    
    @Query private var lessons: [LessonInfor]  // Automatically query all lessons from the model context
    var journalingLessonCount: Int {
        lessons.first(where: { $0.name == "Journaling" })?.count ?? 0
    }
    
    @State private var gratitudeText: String = "" // For the user input in the text area
    @State private var navigateToSelfReflection = false // Tracks navigation to SelfReflectionView
    
    //for prompt
    var type: String
    var tab : String
    var activity : String
    var level : Int
    @State var oracle_prompt: String = ""
    @State var oracle_prompt_id: Int = 0;
    
    var body: some View {
        
//         let gardenElements: [GardenElementData] = [
//            GardenElementData(name: "mountains", type: .png("mountains")),
//            GardenElementData(name: "mushroom", type: .gif("mushroom")),
//            GardenElementData(name: "christmastree", type: .png("christmastree")),
//            GardenElementData(name: "purplerose", type: .png("purplerose")),
//            GardenElementData(name: "deer", type: .png("deer")),
//            GardenElementData(name: "cherryblossom", type: .png("cherryblossom")),
//            GardenElementData(name: "rose", type: .png("rose"))
//        ]
//        
//        // Compute selected garden element based on time
//        var selectedGardenElement: GardenElementData {
//            let filteredElements: [GardenElementData]
//            switch journalingLessonCount {
//            case ...3:
//                filteredElements = gardenElements.filter { ["rose", "cherryblossom"].contains($0.name) }
//            case 3...6:
//                filteredElements = gardenElements.filter { ["deer", "purplerose"].contains($0.name) }
//            case 7...:
//                filteredElements = gardenElements.filter { ["christmastree", "mushroom", "mountains"].contains($0.name) }
//            default:
//                filteredElements = []
//            }
//            
//            return filteredElements.randomElement() ?? gardenElements.first { $0.name == "sunflower" }!
//        }

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
                    // Title Text
                    ScrollView{
                        Text(oracle_prompt.isEmpty ? "What’s one thing you’re grateful for today?" : oracle_prompt)
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                            .shadow(radius: 5)
                    }
                    
                    // Tips Button
                    // Tips Button in the center
                    NavigationLink(destination: JournalingOracleTipsView(oracleTips: oracleTips_journaling)) {
                            Text("Tips")
                            .font(Font.custom("Visby", size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(Color.red)
                            .opacity(0.8) // Adjust transparency as needed
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 30)
                    
                    // Text Input Area
                    TextEditor(text: $gratitudeText)
                        .padding()
                        .frame(height: 180)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // Continue Button with Fade Transition
                    Button(action: {
                        saveOraclePromptAnswer(id: oracle_prompt_id, answer: gratitudeText)
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
                        SelfReflectionView( selectedGardenElement: selectedElement, type: type, tab: tab, activity: activity, level : level)
                            .navigationBarHidden(true)
                    }
                    .padding(.bottom, 50)
                    .buttonStyle(PlainButtonStyle()).navigationTransition(.fade(.cross).animation(.easeInOut(duration: 1.0))) // Avoid default NavigationLink styling
                }
                .onAppear{
                    
                    fetchOracleTips()
                    fetchOraclePrompt()
                }
            }
        }
    }
    func fetchOracleTips() {
                
        let fetchRequest = FetchDescriptor<OracleTip>(
            predicate: #Predicate { $0.type == "journaling" },
            sortBy: [
                SortDescriptor(\OracleTip.level),  // Sort by level
                SortDescriptor(\OracleTip.seq)     // Then sort by seq
            ]
        )
        
        do {
            
           let  oracleTips = try modelContext.fetch(fetchRequest)
            
            if (oracleTips_journaling.isEmpty) {
                
                oracleTips_journaling.removeAll();

                for tip in oracleTips {
                    
                    oracleTips_journaling.append(tip)
                }
            }
            
       } catch {
           print("Failed to fetch OracleTips: \(error)")
       }
    }
    
    func fetchOraclePrompt() {
        
        let fetchRequest = FetchDescriptor<OraclePrompt>(
            predicate: #Predicate {
                $0.type == type &&
//                $0.tab == tab &&
//                $0.activity == activity &&
                $0.level == level &&
                $0.seq == 2
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
            level:  level,
            answer: answer,
            date: Date()
        )
        
        do {
            modelContext.insert(promptAnswer)
            try modelContext.save()  // 儲存到資料庫
            print("OraclePromptAnswer saved successfully.")
        } catch {
            print("Failed to save OraclePromptAnswer: \(error)")
        }
    }
}

// MARK: - Tips Views
struct JournalingOracleTipsView: View {
    
    let oracleTips: [OracleTip]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                
                Color.yellow
                    .opacity(0.2) // Adjust transparency as needed
                    .ignoresSafeArea()
                
                VStack {
                    Text("Journaling Tips")
                        .font(Font.custom("Visby", size: 30))
                        .foregroundColor(.white)
                        .padding()
                    
                    ScrollView {
                        
                        // Use ForEach to display the oracleTips
                        ForEach(oracleTips, id: \.seq) { tip in
                            Text("\(tip.seq). \(tip.text)")
                                .font(Font.custom("Visby", size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .lineSpacing(10)
                        }
                    }
                    .frame(height: geometry.size.height * 0.6) // screen height 60%
                    
                    // scroll more icon
                    VStack {
                        Spacer()
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.bottom, 8)
                        Text("Scroll down for more")
                            .font(Font.custom("Visby", size: 14))
                            .foregroundColor(.white)
                    }
                    .opacity(0.8)
                    
                    Spacer()
                }
            }
        }
    }
}
//struct GratitudeView_Previews: PreviewProvider {
//    static var gardenElements: GardenElementData =
//    GardenElementData(name: "christmastree", type: .png("christmastree"))
//    static var previews: some View {
//        GratitudeView(selectedGardenElement: gardenElements)
//    }
//}
