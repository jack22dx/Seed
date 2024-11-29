import SwiftUI

struct MeditationStreakView: View {
    @State private var navigateToMeditations = false
    @State private var navigateToGarden = false
    
    var body: some View {
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
                    Text("Crimson Oak Tree")
                        .font(Font.custom("Visby", size: 30))
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
                            ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                                ZStack {
                                    Circle()
                                        .fill(day == "M" ? Color.green : Color.clear)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                    
                                    Text(day)
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
                        Button(action: {
                            navigateToMeditations = true
                        }) {
                            Text("Meditations")
                                .font(Font.custom("Visby", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(buttonColors[0])
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .background(
                            NavigationLink("", destination: MeditationActivitiesView().navigationBarHidden(true), isActive: $navigateToMeditations)
                        )
                        
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
                        .background(
                            NavigationLink("", destination: VirtualGardenView().navigationBarHidden(true), isActive: $navigateToGarden)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
            .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
            .navigationBarHidden(true)
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
    static var previews: some View {
        MeditationStreakView()
    }
}