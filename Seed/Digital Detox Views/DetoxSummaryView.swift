import SwiftUI
import Charts

struct DetoxSummaryView: View {
    let elapsedTime: TimeInterval // Time spent during the detox

    @State private var navigateToNextView = false

    var body: some View {
        let lightblue = Color(hue: 0.55, saturation: 0.6, brightness: 0.9, opacity: 1.0)
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
                    NavigationLink(destination: DetoxStreakView() // Replace with your next view
                        .navigationBarHidden(true),
                                   isActive: $navigateToNextView) {
                        Button(action: {
                            navigateToNextView = true
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
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
        .navigationBarHidden(true)
    }
}

struct DetoxSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DetoxSummaryView(elapsedTime: 1500) // Example elapsed time in seconds (e.g., 25 minutes)
    }
}
