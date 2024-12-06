import SwiftUI
import SwiftData


struct MeditationStreakView: View {
    var selectedGardenElement: GardenElementData
    var selectedTime : String
    
    @State private var navigateToMeditationActivities = false
    @State private var navigateToGarden = false
    @Environment(\.modelContext) private var modelContext
    @Query private var lessons: [LessonInfor]
    
    struct CustomButtonStyle: ButtonStyle {
        let color: LinearGradient
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(Font.custom("Visby", size: 18))
                .padding()
                .frame(minWidth: 150)
                .background(color)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        let selectedElement = selectedGardenElement
        let completedDays = getCompletedData(name: "Meditation") // Replace "Lesson Name" with actual name
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
                Color.blue
                    .opacity(0.2) // Adjust transparency as needed
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title
                    Text(selectedElement.name)
                        .font(Font.custom("Visby", size: 30))
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
//
//                        Image("treeseed") // Replace with your tree icon
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 100)
//                            .clipShape(Circle())
                    }
                    
                    // Congratulatory Text
                    Text("Well Done! You have unlocked your first seed.")
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
                        
                        Text("Weekly streak")
                            .font(Font.custom("Visby", size: 18))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.top, 10)
                    }
                    .padding(.bottom,100)
                    
                    
                    // Navigation Buttons
                    HStack(spacing: 30) {
                            Button("Meditations") {
                                navigateToMeditationActivities = true
                            }
                            .buttonStyle(CustomButtonStyle(color: buttonColors[0]))
                            .navigationDestination(isPresented: $navigateToMeditationActivities) {
                                MeditationActivitiesView()
                                    .navigationBarHidden(true)
                            }
                            
                            Button("My Garden") {
                                navigateToGarden = true
                            }
                            .buttonStyle(CustomButtonStyle(color: buttonColors[1]))
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

// Placeholder Views
struct MeditationsView: View {
    var body: some View {
        Text("Meditations View")
            .foregroundColor(.white)
            .font(.largeTitle)
            .background(Color.black.ignoresSafeArea())
    }
}

struct MyGardenView: View {
    var body: some View {
        Text("My Garden View")
            .foregroundColor(.white)
            .font(.largeTitle)
            .background(Color.black.ignoresSafeArea())
    }
}

struct MeditationStreakView_Previews: PreviewProvider {
    static var gardenElement = GardenElementData(name: "flower", type: .png("flower"))

    static var previews: some View {
        MeditationStreakView(selectedGardenElement: gardenElement, selectedTime:"3 min 35 sec")
    }
}
