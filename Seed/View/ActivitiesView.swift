import SwiftUI
import NavigationTransitions
import SwiftData


struct ActivitiesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var lessons: [LessonInfor]  // Automatically query all lessons from the model context
    @State private var isInitialized = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    greetingHeader
                    
                    activitiesSection
                    
                    Spacer()
                    
                    bottomNavigation
                }
                .padding(.top, 40)
                .onAppear {
                    // Ensure data is initialized only once
                    if !isInitialized {
                        initializeLessonsIfNeeded(context: modelContext, lessons: lessons)
                        isInitialized = true
                    }
                }
            }
            
            //            Button(action: {
            //                printDatabaseLocation()
            //                incrementCount(for: "Meditation") // Increment course count
            //                print("Mission Complete tapped for Meditation")
            //            }) {
            //                Text("Completed")
            //            }
        }
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
                printDatabaseLocation()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    private func printDatabaseLocation() {
        guard let container = try? ModelContainer(for: LessonInfor.self),
              let url = container.configurations.first?.url else {
            print("Could not find database location")
            return
        }
        print("Database location: \(url.absoluteString)")
    }
    
    private var greetingHeader: some View {
        Text("Good Morning, Jack.")
            .font(.title)
            .foregroundColor(.white)
            .padding(.bottom, 20)
            .shadow(radius: 5)
    }
    
    private var activitiesSection: some View {
        VStack(spacing: 40) {
            // Fetch and display the lessons correctly
            NavigationLink(destination: MeditationActivitiesView().navigationTransition(.fade(.cross)))
            {
                createActivityCard(
                    title: "Meditation",
                    progress: getProgressForLesson(name: "Meditation"),
                    colors: AppConstants.gradientColors["Meditation"]!,
                    completed: getCompletedData(name: "Meditation")
                )
            }
            NavigationLink(destination: JournalingView().navigationTransition(.fade(.cross))){
                createActivityCard(
                    title: "Journaling",
                    progress: getProgressForLesson(name: "Journaling"),
                    colors: AppConstants.gradientColors["Journaling"]!,
                    completed: getCompletedData(name: "Journaling")
                )
            }
            
            createActivityCard(
                title: "Digital Detox",
                progress: getProgressForLesson(name: "Digital Detox"),
                colors: AppConstants.gradientColors["Digital Detox"]!,
                completed: getCompletedData(name: "Digital Detox")
            )
        }
    }
    
    private func getProgressForLesson(name: String) -> Int {
        // Returns the count for a lesson
        return lessons.first(where: { $0.name == name })?.count ?? 0
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
    
    private func createActivityCard(title: String, progress: Int, colors: [Color], completed: [Bool]) -> some View {
        ActivityCardView(
            title: title,
            progress: progress,
            colors: colors,
            days: AppConstants.weekDays,
            completed: completed
        )
        .padding(.horizontal, 20)
    }
    
    private var bottomNavigation: some View {
        HStack {
            Image(systemName: "leaf.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.green)
                .padding()
            
            Spacer()
            
            Button(action: {
                print("Play button tapped")
            }) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    )
            }
            
            Spacer()
            
            NavigationLink(destination: WeeklySummaryView().navigationBarHidden(true)) {
                Circle()
                    .fill(Color.pink)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    )
            }
        }
        .padding()
    }
}
struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
        
        
    }
}
