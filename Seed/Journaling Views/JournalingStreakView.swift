import SwiftUI

struct JournalingStreakView: View {
    @State private var navigateToActivities = false // Tracks navigation to ActivitiesView
    @State private var navigateToGarden = false // Tracks navigation to VirtualGardenView

    let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]
    @State private var completedDays: [Bool] = [true, false, true, false, true, true, false] // Example data for streak

    var body: some View {
        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                Color.yellow
                    .opacity(0.2)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    // Title
                    Text("Elegant Purple Rose")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    // Decorative Circle with Image
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)

                        Image("purplerose") // Replace with your custom image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }

                    // Congratulatory Text
                    Text("Well Done! You have unlocked your first journaling seed.")
                        .font(Font.custom("FONTSPRING DEMO- Visby CF Demi Bold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 5)
                        .lineSpacing(10)
                        .padding(.bottom, 30)

                    // Weekly Streak Section
                    VStack(spacing: 10) {
                        HStack {
                            Spacer()
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
                                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 14))
                                        .foregroundColor(.white)
                                }
                            }
                            Spacer() 
                        }
                        .padding(.horizontal, 20)

                        Text("Weekly journaling streak")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
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
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.red]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .background(
                            NavigationLink("", destination: ActivitiesView().navigationBarHidden(true), isActive: $navigateToActivities)
                                .hidden()
                        )

                        // My Garden Button
                        Button(action: {
                            navigateToGarden = true
                        }) {
                            Text("My Garden")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.green, Color.teal]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .background(
                            NavigationLink("", destination: VirtualGardenView().navigationBarHidden(true), isActive: $navigateToGarden)
                                .hidden()
                        )
                    }
                }
            }
            .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
            .navigationBarHidden(true)
        }
    }
}

struct JournalingStreakView_Previews: PreviewProvider {
    static var previews: some View {
        JournalingStreakView()
    }
}
