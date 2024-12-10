import SwiftUI
import NavigationTransitions
import SwiftData

struct JournalingStreakView: View {
    var selectedGardenElement: GardenElementData
    @State private var navigateToActivities = false
    @State private var navigateToGarden = false
    @Query private var lessons: [LessonInfor]  // Automatically query all lessons from the model context
    @Environment(\.modelContext) private var modelContext
    @Query private var elementForGarden: [ElementForGarden]
    
    var body: some View {
        let selectedElement = selectedGardenElement
        let completedDays = getCompletedData(name: "Journaling") // Replace "Lesson Name" with actual name
        let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]
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
                PlayerView()
                    .ignoresSafeArea()
                Color.yellow
                    .opacity(0.2) // Adjust transparency as needed
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title
                    Text("Elegant Purple Rose")
                        .font(Font.custom("Visby", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    // Tree Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)
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
                    
                    // Congratulatory Text
                    Text("Well Done! You have unlocked your first journaling seed.")
                        .font(Font.custom("Visby", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 5)
                        .lineSpacing(10)
                        .padding(.bottom, 30)
                    
                    // Weekly Streak Section
                    VStack(spacing: 10) {
                        HStack {
                            ForEach(dayLabels.indices, id: \.self) { index in
                                ZStack {
                                    Circle()
                                        .fill(completedDays[index] ? Color.green : Color.clear)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                    
                                    Text(dayLabels[index])
                                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                            }
                            Spacer() 
                        }
                        .padding(.horizontal, 20) // Ensure extra padding for the edges
                        
                        Text("Weekly journaling streak")
                            .font(Font.custom("Visby", size: 18))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.top, 10)
                    }
                    .padding(.bottom, 100)
                    
                    // Navigation Buttons
                    HStack(spacing: 30) {
                        // Activities Button
                        Button(action: {
                            navigateToActivities = true
                            incrementCount(for: "Journaling", elementName: selectedElement.name)
                            
                        }) {
                            Text("Activities")
                                .font(Font.custom("Visby", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(buttonColors[0])
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .navigationDestination(isPresented: $navigateToActivities) {
                            ActivitiesView()
                                .navigationBarHidden(true)
                        }
                        
                        // My Garden Button
                        Button(action: {
                            navigateToGarden = true
                            incrementCount(for: "Journaling", elementName: selectedElement.name)
                        }) {
                            Text("My Garden")
                                .font(Font.custom("Visby", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(buttonColors[1])
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .navigationDestination(isPresented: $navigateToGarden) {
                            VirtualGardenView()
                                .navigationBarHidden(true)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
            .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
            .navigationBarHidden(true)
        }
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
    
    private func getCompletedData(name: String) -> [Bool] {
        // Return completed days (Mon-Sun) for a lesson
        if let lesson = lessons.first(where: { $0.name == name }) {
            return [
                lesson.Monday, lesson.Tuesday, lesson.Wednesday, lesson.Thursday,
                lesson.Friday, lesson.Saturday, lesson.Sunday
            ]
        } else {
            return Array(repeating: false, count: 7) // Default if lesson not found
        }
    }
}

struct JournalingStreakView_Previews: PreviewProvider {
    static var gardenElements: GardenElementData =
    GardenElementData(name: "christmastree", type: .png("christmastree"))
    static var previews: some View {
        JournalingStreakView(selectedGardenElement:gardenElements)
    }
}
