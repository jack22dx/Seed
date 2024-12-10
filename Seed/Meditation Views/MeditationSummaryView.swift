import SwiftUI
import Charts
import SwiftData

struct MeditationSummaryView: View {
    var selectedGardenElement: GardenElementData
    var selectedTime : String
    @State private var navigateToNextView = false
    @Query private var lessons: [LessonInfor]
    @Query private var elementForGarden: [ElementForGarden]
    @Environment(\.modelContext) private var modelContext
    var displayText: String {
        let timeString = selectedTime
        return timeString + " min 35 seconds"
    }
    @State private var navigateToMeditationStreak = false
    
    
    var body: some View {
        //        let lightblue = Color(hue: 0.55, saturation: 0.6, brightness: 0.9, opacity: 1.0)
        let lightpink = Color(hue: 0.89, saturation: 0.4, brightness: 1, opacity: 0.7)
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
            
            let selectedElement = selectedGardenElement
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                
                Color.blue
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Title
                    Text(selectedGardenElement.name.capitalized)
                        .font(.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    // Tree Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)
                        
                        switch selectedGardenElement.type {
                        case .png(let imageName):
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        case .gif(let gifName):
                            GIFView(gifName: gifName)
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                    }
                    
                    // Time Trained
                    VStack(spacing: 5) {
                        Text("Time Trained")
                            .font(.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Text(displayText)
                            .font(.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 20))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                    
                    // Level Progress
                    ZStack {
                        Circle()
                            .stroke(lightpink, lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Text("Level 1")
                            .font(.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .foregroundColor(.white)
                    }
                    
                    // Meditation Graph
                    VStack(spacing: 10) {
                        Text("Meditation")
                            .font(.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.bottom, 20)
                        
                        Chart {
                            ForEach(0..<5, id: \.self) { index in
                                BarMark(
                                    x: .value("Time", ["Start", "20s", "30s", "40s", "End"][index]),
                                    y: .value("Heart Rate", [100, 80, 60, 40, 20][index])
                                )
                                .foregroundStyle(lightpink)
                            }
                        }
                        .padding(.horizontal, 40)
                        .frame(height: 120)
                        .chartXAxis {
                            AxisMarks(position: .bottom)
                        }
                    }
                    
                    // Heart Rate Label
                    Text("Heart Rate")
                        .font(.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(.bottom, 20)
                    
                    // Continue Button
                    Button(action: {
                        navigateToMeditationStreak = true
                        incrementCount(for:"Meditation",elementName: selectedElement.name)
                    }) {
                        Text("Continue")
                            .font(.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .padding()
                            .frame(minWidth: 150)
                            .background(buttonColors[1])
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                        
                    }
                    .navigationDestination(isPresented: $navigateToMeditationStreak) {
                        MeditationStreakView(selectedGardenElement: selectedElement, selectedTime:selectedTime)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
        .navigationBarHidden(true)
    }
    
    private func incrementCount(for name: String,elementName: String) {
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
    
}

struct MeditationSummaryView_Previews: PreviewProvider {
    static var gardenElement = GardenElementData(name: "flower", type: .png("flower"))
    
    static var previews: some View {
        MeditationSummaryView(selectedGardenElement: gardenElement, selectedTime:"3 min 35 sec")
    }
}
