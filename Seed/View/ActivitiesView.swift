import SwiftUI
import NavigationTransitions
import SwiftData

struct ActivitiesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var lessons: [LessonInfor]  // Automatically query all lessons from the model context
    @State private var isInitialized = false
    @State private var navigateToGardenView = false
    @State private var navigateToActivitiesView = false
    @State private var navigateToSummaryView = false

    var body: some View {
        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    greetingHeader

                    activitiesSection

                    Spacer()

                    CustomBottomNavigationBar(
                        navigateToGardenView: $navigateToGardenView,
                        navigateToActivitiesView: $navigateToActivitiesView,
                        navigateToSummaryView: $navigateToSummaryView
                    )
                    .padding(.bottom, 50) // Add spacing from the bottom
                }
                .padding(.top, 40)
                .onAppear {
                    if !isInitialized {
                        initializeData()
                    }
                }
            }

            Button(action: handleMissionComplete) {
                Text("Completed")
            }
        }
    }

    // MARK: - Private Methods

    private func initializeData() {
        initializeLessonsIfNeeded(context: modelContext, lessons: lessons)
        isInitialized = true
    }

    private func handleMissionComplete() {
        printDatabaseLocation()
        incrementCount(for: "Meditation")
        print("Mission Complete tapped for Meditation")
    }

    private func incrementCount(for name: String) {
        if let function = lessons.first(where: { $0.name == name }) {
            function.count += 1

            let currentDayEnglish = updateCurrentDayAttendance(for: function)
            
            // Save the updated model context
            do {
                try modelContext.save()
                print("\(currentDayEnglish)'s Mission Complete:")
                printDatabaseLocation()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    private func updateCurrentDayAttendance(for lesson: LessonInfor) -> String {
        let calendar = Calendar.current
        let currentDay = calendar.component(.weekday, from: Date())
        var currentDayEnglish = ""

        switch currentDay {
        case 1: lesson.Sunday = true; currentDayEnglish = "Sunday"
        case 2: lesson.Monday = true; currentDayEnglish = "Monday"
        case 3: lesson.Tuesday = true; currentDayEnglish = "Tuesday"
        case 4: lesson.Wednesday = true; currentDayEnglish = "Wednesday"
        case 5: lesson.Thursday = true; currentDayEnglish = "Thursday"
        case 6: lesson.Friday = true; currentDayEnglish = "Friday"
        case 7: lesson.Saturday = true; currentDayEnglish = "Saturday"
        default: print("Unexpected day of the week encountered.")
        }

        return currentDayEnglish
    }

    private func printDatabaseLocation() {
        guard let container = try? ModelContainer(for: LessonInfor.self),
              let url = container.configurations.first?.url else {
            print("Could not find database location")
            return
        }
        print("Database location: \(url.absoluteString)")
    }

    // MARK: - Subviews

    private var greetingHeader: some View {
        Text("Good Morning, Jack.")
            .font(Font.custom("Visby", size: 30))
            .foregroundColor(.white)
            .padding(.bottom, 20)
            .shadow(radius: 5)
    }

    private var activitiesSection: some View {
        VStack(spacing: 40) {
            NavigationLink(destination: MeditationActivitiesView().navigationTransition(.fade(.cross))) {
                createActivityCard(
                    title: "Meditation",
                    progress: getProgressForLesson(name: "Meditation"),
                    colors: AppConstants.gradientColors["Meditation"]!,
                    completed: getCompletedData(name: "Meditation")
                )
            }

            NavigationLink(destination: JournalingView().navigationTransition(.fade(.cross))) {
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

    private func getProgressForLesson(name: String) -> Int {
        return lessons.first(where: { $0.name == name })?.count ?? 0
    }

    private func getCompletedData(name: String) -> [Bool] {
        if let lesson = lessons.first(where: { $0.name == name }) {
            return [
                lesson.Monday, lesson.Tuesday, lesson.Wednesday, lesson.Thursday,
                lesson.Friday, lesson.Saturday, lesson.Sunday
            ]
        } else {
            return Array(repeating: false, count: 7)
        }
    }
}

// MARK: - Custom Bottom Navigation Bar Component

struct CustomBottomNavigationBar: View {
    @Binding var navigateToGardenView: Bool
    @Binding var navigateToActivitiesView: Bool
    @Binding var navigateToSummaryView: Bool

    var body: some View {
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

// MARK: - Previews

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
