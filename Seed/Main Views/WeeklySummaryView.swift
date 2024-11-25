import SwiftUI

struct WeeklySummaryView: View {
    @State private var navigateToGardenView = false
    @State private var navigateToActivitiesView = false
    @State private var navigateToSummaryView = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background with PlayerView
                    PlayerView()
                        .ignoresSafeArea()

                    VStack {
                        // Header
                        Text("This Week’s Summary")
                            .font(Font.custom("Visby", size: 30))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.top, geometry.size.height * 0.03)
                            .padding(.bottom,50)

                        // Summary Cards
                        VStack(spacing: geometry.size.height * 0.05) {
                            DynamicCard(
                                title: "Meditation",
                                description: "You meditated for a total of 25 minutes. Well done on reaching Level 3!",
                                cardColor: Color.cyan,
                                tipsDestination: MeditationTipsView(),
                                geometry: geometry,
                                hasExclamation: true
                            )
                            .frame(height: geometry.size.height * 0.18)
                            .padding(.horizontal, geometry.size.width * 0.05)
                            .lineSpacing(10)

                            DynamicMoodCard(
                                title: "Mood Tracker",
                                description: "Last 7 days Mood Tracker: Reflect on your moods",
                                moods: ["😃", "🙂", "😐", "😐", "🙂", "😔", "😔"],
                                cardColor: Color.red.opacity(0.6),
                                tipsDestination: MoodTipsView(),
                                geometry: geometry
                            )
                            .frame(height: geometry.size.height * 0.22)
                            .padding(.horizontal, geometry.size.width * 0.05)
                            .lineSpacing(10)

                            DynamicCard(
                                title: "Digital Detox",
                                description: "You detoxed for a total of 2 hours 15 minutes so far. Good job!",
                                cardColor: Color.orange.opacity(0.7),
                                tipsDestination: DetoxTipsView(),
                                geometry: geometry,
                                hasExclamation: true
                            )
                            .frame(height: geometry.size.height * 0.18)
                            .padding(.horizontal, geometry.size.width * 0.05)
                            .lineSpacing(10)
                        }

                        Spacer()

                        // Bottom Navigation Bar
                        BottomNavigationBar(
                            navigateToGardenView: $navigateToGardenView,
                            navigateToActivitiesView: $navigateToActivitiesView,
                            navigateToSummaryView: $navigateToSummaryView
                        )
                      // Respect safe area
                        .padding(.top,58)
                    }
                    
                }
            }
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
    }
}

// MARK: - Dynamic Card Component
struct DynamicCard<Destination: View>: View {
    var title: String
    var description: String
    var cardColor: Color
    var tipsDestination: Destination
    var geometry: GeometryProxy
    var hasExclamation: Bool = false // Option to include exclamation point

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(cardColor)
                .shadow(radius: 5)

            VStack(alignment: .center, spacing: 10) {
                // Title
                Text(title)
                    .font(Font.custom("Visby", size: 20))
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                // Description
                Text(description + (hasExclamation ? "!" : ""))
                    .font(Font.custom("Visby", size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)

                // Tips Button in the center
                NavigationLink(destination: tipsDestination) {
                    Text("Tips")
                        .font(Font.custom("Visby", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - Dynamic Mood Card Component
struct DynamicMoodCard<Destination: View>: View {
    var title: String
    var description: String
    var moods: [String]
    var cardColor: Color
    var tipsDestination: Destination
    var geometry: GeometryProxy

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 15)
                .fill(cardColor)
                .shadow(radius: 5)

            VStack(alignment: .center, spacing: 10) {
                // Title
                Text(title)
                    .font(Font.custom("Visby", size: 20))
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                // Description without full stop
                Text(description)
                    .font(Font.custom("Visby", size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)

                // Mood Emojis
                HStack(spacing: geometry.size.width * 0.02) {
                    ForEach(moods, id: \.self) { mood in
                        Text(mood)
                            .font(.largeTitle) // Emoji size
                    }
                }
                .padding(.vertical, 5)

                // Tips Button in the center
                NavigationLink(destination: tipsDestination) {
                    Text("Tips")
                        .font(Font.custom("Visby", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - Tips Views
struct MeditationTipsView: View {
    var body: some View {
        ZStack {
            PlayerView()
                .ignoresSafeArea()

            VStack {
                Text("Meditation Tips")
                    .font(Font.custom("Visby", size: 30))
                    .foregroundColor(.white)
                    .padding()

                Text("""
                    1. Start with 5 minutes daily.
                    2. Focus on your breath.
                    3. Try a 2-minute body scan exercise.
                """)
                    .font(Font.custom("Visby", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .lineSpacing(10)

                Spacer()
            }
        }
    }
}

struct MoodTipsView: View {
    var body: some View {
        ZStack {
            PlayerView()
                .ignoresSafeArea()

            VStack {
                Text("Mood Tracker Tips")
                    .font(Font.custom("Visby", size: 30))
                    .foregroundColor(.white)
                    .padding()

                Text("""
                    1. Keep a daily journal to track your moods.
                    2. Reflect on triggers for negative emotions.
                    3. Celebrate small moments of joy.
                """)
                    .font(Font.custom("Visby", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .lineSpacing(10)

                Spacer()
            }
        }
    }
}

struct DetoxTipsView: View {
    var body: some View {
        ZStack {
            PlayerView()
                .ignoresSafeArea()

            VStack {
                Text("Digital Detox Tips")
                    .font(Font.custom("Visby", size: 30))
                    .foregroundColor(.white)
                    .padding()

                Text("""
                    1. Schedule screen-free time daily.
                    2. Turn off non-essential notifications.
                    3. Replace screen time with hobbies or exercise.
                """)
                    .font(Font.custom("Visby", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .lineSpacing(10)

                Spacer()
            }
        }
    }
}

// MARK: - Preview
struct WeeklySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklySummaryView()
    }
}
