import SwiftUI
import NavigationTransitions
import SwiftData


struct GoalSettingView: View {
    var selectedGardenElement: GardenElementData
    @State private var goalText: String = "" // For the user input in the text area
    @State private var navigateToStreakView = false // State to track navigation
    @Query private var lessons: [LessonInfor]
    @Query private var elementForGarden: [ElementForGarden]
    @Environment(\.modelContext) private var modelContext
    //for oracle
    @State private var oracleTips_journaling: [OracleTip] = []
    
    var body: some View {
        NavigationStack { // Ensure NavigationStack wraps the view hierarchy
            let selectedElement = selectedGardenElement
            ZStack {
                // Background gradient and overlay
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
                    ScrollView{
                        
                        Text("What’s a goal you’d like to work towards tomorrow?")
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
                    TextEditor(text: $goalText)
                        .padding()
                        .frame(height: 200)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    // Continue Button
                    Button(action: {
                        navigateToStreakView = true // Trigger navigation
                        incrementCount(for: "Journaling", elementName: selectedElement.name)
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
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 50)
                }
                .onAppear {
                    
                    fetchOracleTips()
                }
                .navigationDestination(isPresented: $navigateToStreakView) {
                    JournalingStreakView(selectedGardenElement: selectedElement)
                        .navigationBarHidden(true)
                }
            }
            .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 1.0)))// Avoid default NavigationLink styling
            
        }
    }
    //    private func incrementCount(for name: String)
    private func incrementCount(for name: String,elementName: String)
    {
        guard let function = lessons.first(where: { $0.name == name }) else {
            print("No lesson found with name: \(name)")
            return
        }
        
        // 修改 isVisible 為 true
        if let element = elementForGarden.first(where: { $0.elementName == elementName }) {
            element.isVisible = true
        }
        
        function.count += 1
        
        let calendar = Calendar.current
        let currentDay = calendar.component(.weekday, from: Date())
        
        switch currentDay {
        case 1: function.Sunday = true
        case 2: function.Monday = true
        case 3: function.Tuesday = true
        case 4: function.Wednesday = true
        case 5: function.Thursday = true
        case 6: function.Friday = true
        case 7: function.Saturday = true
        default:
            print("Unexpected day of the week encountered.")
            return
        }
        
        do {
            try modelContext.save()
            print("Mission Complete for \(getDayName(for: currentDay))")
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    private func getDayName(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "Unknown Day"
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
}

struct GoalSettingView_Previews: PreviewProvider {
    static var gardenElements: GardenElementData =
    GardenElementData(name: "christmastree", type: .png("christmastree"))
    
    static var previews: some View {
        GoalSettingView(selectedGardenElement:gardenElements)
    }
}
