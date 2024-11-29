import SwiftUI
import Charts
import SwiftData

struct MeditationSummaryView: View {
    @State private var navigateToNextView = false
    @Query private var lessons: [LessonInfor]// Automatically query all lessons from the model context
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        let lightblue = Color(hue: 0.55, saturation: 0.6, brightness: 0.9, opacity: 1.0)
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
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                Color.blue
                        .opacity(0.2) // Adjust transparency as needed
                        .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Title
                    Text("Crimson Oak Tree")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    // Tree Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)
                        
                        Image("treeseed") // Replace with your tree icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    
                    // Time Trained
                    VStack(spacing: 5) {
                        Text("Time Trained")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Text("3 min 35 sec")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 20))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom,20)
                    
                    // Level Progress
                    ZStack {
                        Circle()
                            .stroke(lightpink, lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Text("Level 1")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .foregroundColor(.white)
                    }
                    
                    
                    // Meditation Graph
                    VStack(spacing: 10) {
                        Text("Meditation")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.bottom,20)
                        
                        Chart {
                            ForEach(0..<5, id: \.self) { index in
                                BarMark(
                                    x: .value("Time", ["Start", "20s", "30s", "40s", "End"][index]),
                                    y: .value("Heart Rate", [100, 80, 60, 40, 20][index])
                                )
                                .foregroundStyle(lightpink)
                            }
                        }
                        .padding(.horizontal,40)
                        .frame(height: 120)
                        .chartXAxis {
                            AxisMarks(position: .bottom)
                            
                        }
                    }
                    
                    // Heart Rate Label
                    Text("Heart Rate")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(.bottom,20)
                    
                    
                    
                    // Continue Button
                    NavigationLink(destination: MeditationStreakView() // Replace with your next view
                        .navigationBarHidden(true),
                                   isActive: $navigateToNextView) {
                        Button(action: {
                            incrementCount(for: "Meditation")
                            navigateToNextView = true
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
                    }
                }
                .padding(.horizontal, 20)
            }
            
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
        .navigationBarHidden(true)
    }
    
    private func incrementCount(for name: String) {
        // Increment count logic
        if let function = lessons.first(where: { $0.name == name }) {
            function.count += 1 // Increment count
            // Update current day's attendance
            let calendar = Calendar.current
            let currentDay = calendar.component(.weekday, from: Date())
            var currentDayEnglish = ""
            switch currentDay {
            case 1:
                function.Sunday = true
                currentDayEnglish = "Sunday"
            case 2:
                function.Monday = true
                currentDayEnglish = "Monday"
            case 3:
                function.Tuesday = true
                currentDayEnglish = "Tuesday"
            case 4:
                function.Wednesday = true
                currentDayEnglish = "Wednesday"
            case 5:
                function.Thursday = true
                currentDayEnglish = "Thursday"
            case 6:
                function.Friday = true
                currentDayEnglish = "Friday"
            case 7:
                function.Saturday = true
                currentDayEnglish = "Saturday"
            default:
                print("Unexpected day of the week encountered.")
            }
            
            // Save the updated model context
            do {
                try modelContext.save() // Save changes to the model context
                print("\(currentDayEnglish)'s Mission Complete:")
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
}

struct MeditationSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationSummaryView()
    }
}
