import SwiftUI

struct JournalingTabsView: View {
    @State private var expandedTabIndex: Int? = nil // Tracks which tab is expanded
    @State private var navigateToMoodSelection = false // Tracks navigation
    @State private var selectedActivity: JournalingActivity? = nil // Selected activity for navigation

    // Sample data for journaling activities
    let journalingCategories: [JournalingCategory] = [
        JournalingCategory(
            id: 0,
            name: "Mindfulness",
            activities: [
                JournalingActivity(name: "Gratitude", questions: ["What is one thing you are grateful for today?", "What’s one thing you enjoyed today?"]),
                JournalingActivity(name: "Nature", questions: ["What’s something you observed in nature today?", "When did you last feel stressed?"]),
                JournalingActivity(name: "Peace", questions: ["What brings you a sense of peace or calm?", "What sensations can you notice in your body at this moment?"])
            ]
        ),
        JournalingCategory(
            id: 1,
            name: "Self Awareness",
            activities: [
                JournalingActivity(name: "Presence", questions: ["When did you feel most present today?", "What’s one small act of kindness you can do today?"]),
                JournalingActivity(name: "Thoughts", questions: ["What thoughts keep popping up in your mind recently?", "What memories bring you a sense of joy or peace?"]),
                JournalingActivity(name: "Challenges", questions: ["What is a recent challenge you faced, and how did you respond to it?", "How do you usually react when you feel anxious or stressed?"])
            ]
        ),
        JournalingCategory(
            id: 2,
            name: "Emotions",
            activities: [
                JournalingActivity(name: "Patterns", questions: ["What patterns have you noticed in your emotions over the past week?", "What values or beliefs guide your actions and choices?"]),
                JournalingActivity(name: "Compassion", questions: ["What are some ways you can show compassion towards yourself?", "What past experiences have shaped the way you think and feel today?"]),
                JournalingActivity(name: "Mindfulness", questions: ["How do you respond to difficult emotions, and how could you improve?", "What does mindfulness mean to you, and how do you like to practice it?"])
            ]
        ),
        JournalingCategory(
            id: 3,
            name: "Creativity",
            activities: [
                JournalingActivity(name: "Poem", questions: ["Write a short poem about something you have experienced in the last week.", "What do you fear most? Have your fears changed throughout life?"]),
                JournalingActivity(name: "Peaceful Place", questions: ["What place makes you feel most peaceful? Describe that place using all five senses.", "Identify one area where you’d like to improve. Then, list three specific actions you can take to create that change."]),
                JournalingActivity(name: "Daily Log", questions: ["Write your daily log from 8 am to 8 pm and categorize your activities as either helping or hindering you.", "Identify goals for the next week and break them down into action verbs."])
            ]
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Journaling")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    Spacer() // Pushes the tabs lower on the screen

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(journalingCategories) { category in
                                JournalingCategoryCard(
                                    index: category.id,
                                    expandedTabIndex: $expandedTabIndex,
                                    title: category.name,
                                    activities: category.activities,
                                    onActivitySelected: { activity in
                                        selectedActivity = activity
                                        navigateToMoodSelection = true
                                    }
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }

                    Spacer() // Ensures consistent spacing below the tabs

                    NavigationLink(
                        destination: selectedActivity.map { activity in
                            MoodSelectionView(activity: activity)
                        },
                        isActive: $navigateToMoodSelection
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct JournalingCategoryCard: View {
    let index: Int
    @Binding var expandedTabIndex: Int?
    var title: String
    var activities: [JournalingActivity]
    var onActivitySelected: (JournalingActivity) -> Void

    // Tab colors based on index
    var cardColor: Color {
        switch index {
        case 0: return Color.blue.opacity(0.7)
        case 1: return Color.yellow.opacity(0.7)
        case 2: return Color.red.opacity(0.7)
        case 3: return Color.green.opacity(0.7)
        default: return Color.gray.opacity(0.7)
        }
    }

    var body: some View {
        Button(action: {
            withAnimation { expandedTabIndex = expandedTabIndex == index ? nil : index }
        }) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(cardColor)
                    .shadow(radius: 5)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(title)
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                            .foregroundColor(.white)
                            .shadow(radius: 5)

                        Spacer()

                        Image(systemName: expandedTabIndex == index ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                    }

                    if expandedTabIndex == index {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(activities) { activity in
                                Button(action: { onActivitySelected(activity) }) {
                                    Text(activity.name)
                                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 16))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white.opacity(0.9))
                                        .foregroundColor(cardColor)
                                        .clipShape(Capsule())
                                        .shadow(radius: 5)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                .padding(20)
            }
            .frame(height: expandedTabIndex == index ? CGFloat(240) : 100)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
