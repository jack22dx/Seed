import SwiftUI
import SwiftData
import Charts

struct DetoxSummaryView: View {
    let elapsedTime: TimeInterval // Time spent during the detox

    @State private var navigateToNextView = false
    @Query private var lessons: [LessonInfor]
    @Query private var elementForGarden: [ElementForGarden]
    @Environment(\.modelContext) private var modelContext


    var body: some View {
//        let lightblue = Color(hue: 0.55, saturation: 0.6, brightness: 0.9, opacity: 1.0)
        let lightgreen = Color(hue: 0.33, saturation: 0.5, brightness: 0.8, opacity: 0.7)
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
        let weeklyData = [
            ("Mon", 15),
            ("Tue", 20),
            ("Wed", 25),
            ("Thu", 10),
            ("Fri", 30),
            ("Sat", 25),
            ("Sun", 20)
        ] // Sample data for weekly detox times (in minutes)

        let elapsedMinutes = Int(elapsedTime) / 60

        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                Color.red
                    .opacity(0.2) // Adjust transparency as needed
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Title
                    Text("Daphne the Deer")
                        .font(Font.custom("Visby", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    // Deer Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)

                        Image("deer") // Replace with your detox deer icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }

                    // Time Completed
                    VStack(spacing: 5) {
                        Text("Time Completed")
                            .font(Font.custom("Visby", size: 18))
                            .foregroundColor(.white)
                            .shadow(radius: 5)

                        Text("\(elapsedMinutes) min")
                            .font(Font.custom("Visby", size: 20))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)

                    // Level Progress
                    ZStack {
                        Circle()
                            .stroke(lightgreen, lineWidth: 8)
                            .frame(width: 80, height: 80)

                        Text("Level 2")
                            .font(Font.custom("Visby", size: 18))
                            .foregroundColor(.white)
                    }

                    // Weekly Detox Graph
                    VStack(spacing: 10) {
                        Text("Weekly Detox Summary")
                            .font(Font.custom("Visby", size: 18))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.bottom, 20)

                        Chart {
                            ForEach(weeklyData, id: \.0) { day, time in
                                BarMark(
                                    x: .value("Day", day),
                                    y: .value("Minutes", time)
                                )
                                .foregroundStyle(lightgreen)
                            }
                        }
                        .padding(.horizontal, 40)
                        .frame(height: 150)
                        .chartXAxis {
                            AxisMarks(position: .bottom)
                        }
                    }

                    // Detox Time Label
                    Text("Minutes Detoxed")
                        .font(Font.custom("Visby", size: 18))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(.bottom, 20)

                    // Continue Button
                    Button(action: {
                        navigateToNextView = true
                        incrementCount(for: "Meditation")
                        
                    }) {
                        Text("Continue")
                            .font(Font.custom("Visby", size: 18))
                            .padding()
                            .frame(minWidth: 150)
                            .background(buttonColors[1])
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                    .navigationDestination(isPresented: $navigateToNextView)
                    {
                        DetoxStreakView()
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
        .navigationBarHidden(true)
    }
//    private func incrementCount(for name: String,elementName: String)
    private func incrementCount(for name: String)
    {
        guard let function = lessons.first(where: { $0.name == name }) else {
            print("No lesson found with name: \(name)")
            return
        }
        
//        // 修改 isVisible 為 true
//         if let element = elementForGarden.first(where: { $0.elementName == elementName }) {
//             element.isVisible = true
//         }
        
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

struct DetoxSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DetoxSummaryView(elapsedTime: 1500) // Example elapsed time in seconds (e.g., 25 minutes)
    }
}
