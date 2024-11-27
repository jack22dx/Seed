import SwiftUI
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
import SwiftData

struct MeditationStreakView: View {
    @State private var navigateToMeditations = false
    @State private var navigateToGarden = false
    @Query private var lessons: [LessonInfor]  // Automatically query all lessons from the model context
    
    var body: some View {
        
        let completedDays = getCompletedData(name: "Meditation") // Replace "Lesson Name" with actual name
        let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]
        
<<<<<<< HEAD
=======
import NavigationTransitions

<<<<<<<< HEAD:Seed/Journaling Views/JournalingStreakView.swift
struct JournalingStreakView: View {
    @State private var navigateToActivities = false
========
struct MeditationStreakView: View {
    @State private var navigateToMeditations = false
>>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views):Seed/Meditation Views/MeditationStreakView.swift
    @State private var navigateToGarden = false
    
    var body: some View {
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
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
<<<<<<< HEAD
                Color.blue
=======
<<<<<<<< HEAD:Seed/Journaling Views/JournalingStreakView.swift
                Color.yellow
========
                Color.blue
>>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views):Seed/Meditation Views/MeditationStreakView.swift
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
                        .opacity(0.2) // Adjust transparency as needed
                        .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title
<<<<<<< HEAD
                    Text("Crimson Oak Tree")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
<<<<<<< HEAD
=======
                    Text("Elegant Purple Rose")
                        .font(Font.custom("Visby", size: 30))
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    // Tree Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)
                        
<<<<<<< HEAD
<<<<<<< HEAD
                        Image("treeseed")
=======
                        Image("purplerose") // Replace with your tree icon for journaling
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
                        Image("treeseed")
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    
                    // Congratulatory Text
<<<<<<< HEAD
                    Text("Well Done! You have unlocked your first seed.")
=======
                    Text("Well Done! You have unlocked your first journaling seed.")
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
                        .font(Font.custom("Visby", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 5)
<<<<<<< HEAD
<<<<<<< HEAD
=======
                        .lineSpacing(10)
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
                        .padding(.bottom, 30)
                    
                    // Weekly Streak Section
                    VStack(spacing: 10) {
<<<<<<< HEAD
<<<<<<< HEAD
                        HStack(spacing: 10) {
                            ForEach(dayLabels.indices, id: \.self) { index in
                                ZStack {
                                    Circle()
                                        .fill(completedDays[index] ? Color.green : Color.clear)
=======
                        HStack {
                            Spacer() // Add space before the first day
                            ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                                ZStack {
                                    Circle()
                                        .fill(day == "M" ? Color.green : Color.clear) // Highlight Monday as an example
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
                        HStack(spacing: 10) {
                            ForEach(dayLabels.indices, id: \.self) { index in
                                ZStack {
                                    Circle()
                                        .fill(completedDays[index] ? Color.green : Color.clear)
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                    
<<<<<<< HEAD
<<<<<<< HEAD
                                    Text(dayLabels[index])
                                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                            }
                        }
                        Text("Weekly streak")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
=======
                                    Text(day)
                                        .font(Font.custom("Visby", size: 14))
=======
                                    Text(dayLabels[index])
                                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 20))
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                            }
                        }
<<<<<<< HEAD
                        .padding(.horizontal, 20) // Ensure extra padding for the edges
                        
                        Text("Weekly journaling streak")
                            .font(Font.custom("Visby", size: 18))
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
                        Text("Weekly streak")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.top, 10)
                    }
                    .padding(.bottom, 100)
                    
                    // Navigation Buttons
                    HStack(spacing: 30) {
<<<<<<< HEAD
<<<<<<< HEAD
                        NavigationLink(destination: MeditationActivitiesView().navigationBarHidden(true)) {
                            Text("Meditations")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
=======
                        // Activities Button
                        Button(action: {
                            navigateToActivities = true
                        }) {
                            Text("Activities")
                                .font(Font.custom("Visby", size: 18))
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
                        NavigationLink(destination: MeditationActivitiesView().navigationBarHidden(true)) {
                            Text("Meditations")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
                                .padding()
                                .frame(minWidth: 150)
                                .background(buttonColors[0])
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
<<<<<<< HEAD
<<<<<<< HEAD
                        
                        NavigationLink(destination: VirtualGardenView().navigationBarHidden(true)) {
                            Text("My Garden")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
=======
                        .background(
                            NavigationLink("", destination: ActivitiesView().navigationBarHidden(true), isActive: $navigateToActivities)
                        )
                        
                        // My Garden Button
                        Button(action: {
                            navigateToGarden = true
                        }) {
                            Text("My Garden")
                                .font(Font.custom("Visby", size: 18))
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
                        
                        NavigationLink(destination: VirtualGardenView().navigationBarHidden(true)) {
                            Text("My Garden")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
                                .padding()
                                .frame(minWidth: 150)
                                .background(buttonColors[1])
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
<<<<<<< HEAD
<<<<<<< HEAD
=======
                        .background(
                            NavigationLink("", destination: VirtualGardenView().navigationBarHidden(true), isActive: $navigateToGarden)
                        )
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
            .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
            .navigationBarHidden(true)
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
        }}
    private func getCompletedData(name: String) -> [Bool] {
        // Return completed days (Mon-Sun) for a lesson
        if let lesson = lessons.first(where: { $0.name == name }) {
            return [
                lesson.Monday, lesson.Tuesday, lesson.Wednesday, lesson.Thursday,
                lesson.Friday, lesson.Saturday, lesson.Sunday
            ]
        } else {
            return Array(repeating: false, count: 7) // Default if lesson not found
<<<<<<< HEAD
=======
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
=======
>>>>>>> 4a34895 (add, function for lesson completed, level control in garden,streak view retrieve database)
        }
    }
}

<<<<<<< HEAD
=======
<<<<<<<< HEAD:Seed/Journaling Views/JournalingStreakView.swift
struct JournalingStreakView_Previews: PreviewProvider {
    static var previews: some View {
        JournalingStreakView()
========
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
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
    static var previews: some View {
        MeditationStreakView()
<<<<<<< HEAD
=======
>>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views):Seed/Meditation Views/MeditationStreakView.swift
>>>>>>> 09b3651 (Updated activites view fonts and mountains in garden. Added Journaling views)
    }
}
