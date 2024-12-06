import SwiftUI
import NavigationTransitions
import SwiftData


struct DetoxStreakView: View {
    @State private var navigateToActivities = false
    @State private var navigateToGarden = false
    @Query private var lessons: [LessonInfor]
    
    var body: some View {
        
        let completedDays = getCompletedData(name: "Digital Detox") // Replace "Lesson Name" with actual name
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
                Color.red
                    .opacity(0.2) // Adjust transparency as needed
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title
                    Text("Daphne the Deer")
                        .font(Font.custom("Visby", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    // Tree Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)
                        
                        Image("deer") // Replace with your tree icon for journaling
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    
                    // Congratulatory Text
                    Text("Well Done! You have unlocked your first detox seed.")
                        .font(Font.custom("Visby", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 5)
                        .lineSpacing(10)
                        .padding(.bottom, 30)
                    
                    // Weekly Streak Section
                    VStack(spacing: 10) {
                        HStack {
                            Spacer() // Add space before the first day
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
                                        .font(Font.custom("Visby", size: 14))
                                        .foregroundColor(.white)
                                }
                            }
                            Spacer() // Add space after the last day
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
                        .navigationDestination(isPresented:$navigateToActivities)
                        {
                            ActivitiesView().navigationBarHidden(true)
                        }
                        
                        // My Garden Button
                        Button(action: {
                            navigateToGarden = true
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
                        .navigationDestination(isPresented: $navigateToGarden)
                        {
                            VirtualGardenView().navigationBarHidden(true)
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

struct DetoxStreakView_Previews: PreviewProvider {
    static var previews: some View {
        DetoxStreakView()
    }
}
