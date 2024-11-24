import SwiftUI
import NavigationTransitions

struct MeditationActivitiesView: View {
    @State private var expandedCardIndex: Int? = nil // Tracks which card is expanded
    @State private var navigateToGardenView = false
    @State private var navigateToActivitiesView = false
    @State private var navigateToSummaryView = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                PlayerView()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Title
                    Text("Meditation")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    // Meditation Cards in a ScrollView
                  
                        VStack(spacing: 8) {
                            MeditationCard(
                                index: 0,
                                expandedCardIndex: $expandedCardIndex,
                                title: "Breath Work",
                                imageName: "treeseed",
                                description: "Breath Work helps you calm your mind and stay focused.",
                                color: Color.cyan,
                                isCompleted: false,
                                times: ["1 min", "3 min", "5 min"]
                            )
                            .padding(.horizontal, 20)

                            MeditationCard(
                                index: 1,
                                expandedCardIndex: $expandedCardIndex,
                                title: "Guided Session",
                                imageName: "palmIcon",
                                description: "This guided meditation incorporates awareness of sounds, bodily sensations, thoughts, or feelings.",
                                color: Color.red.opacity(0.6),
                                isCompleted: false,
                                times: ["3 min", "5 min", "10 min"]
                            )
                            .padding(.horizontal, 20)

                            MeditationCard(
                                index: 2,
                                expandedCardIndex: $expandedCardIndex,
                                title: "Mindful Imagery",
                                imageName: "pineIcon",
                                description: "Visualize calming and peaceful scenes to enhance mindfulness.",
                                color: Color.green.opacity(0.7),
                                isCompleted: false,
                                times: ["5 min", "10 min", "15 min"]
                            )
                            .padding(.horizontal, 20)

                            MeditationCard(
                                index: 3,
                                expandedCardIndex: $expandedCardIndex,
                                title: "Body Scan",
                                imageName: "treeIcon",
                                description: "Become aware of your body and release tension in this guided scan.",
                                color: Color.orange.opacity(0.7),
                                isCompleted: false,
                                times: ["3 min", "7 min", "10 min"]
                            )
                        
                        .padding(.horizontal, 20)
                        
                    }

                    Spacer()
                    
                       
                    // Bottom Navigation Bar
                    BottomNavigationBar(
                        navigateToGardenView: $navigateToGardenView,
                        navigateToActivitiesView: $navigateToActivitiesView,
                        navigateToSummaryView: $navigateToSummaryView
                    )
                  
                  
                }
            }
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
        .navigationBarHidden(true)
    }
}



struct MeditationCard: View {
    let index: Int
    @Binding var expandedCardIndex: Int? // Tracks which card is expanded
    var title: String
    var imageName: String
    var description: String
    var color: Color
    var isCompleted: Bool
    var times: [String] // List of available times
    
    @State private var selectedTime: String? // Tracks selected time
    @State private var navigateToDidYouKnow = false // Tracks navigation state for Guided Session
    
    var body: some View {
        Spacer()
        Button(action: {
            withAnimation {
                expandedCardIndex = expandedCardIndex == index ? nil : index
            }
        }) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        // Icon
                        Image(imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.trailing, 10)
                        
                        // Title
                        Text(title)
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Spacer()
                        
                        // Check Icon (only visible if completed)
                        if isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    // Description and Time Selection (only if expanded)
                    if expandedCardIndex == index {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(description)
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 14))
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                                .fixedSize(horizontal: false, vertical: true) // Enable multiline text
                            
                            // Time Buttons
                            HStack {
                                ForEach(times, id: \.self) { time in
                                    NavigationLink(destination: DidYouKnowView().navigationBarHidden(true), isActive: $navigateToDidYouKnow) {
                                        Button(action: {
                                            withAnimation {
                                                selectedTime = time
                                                if title == "Guided Session" && time == "3 min" {
                                                    navigateToDidYouKnow = true
                                                }
                                            }
                                        }) {
                                            Text(time)
                                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 14))
                                                .padding()
                                                .frame(minWidth: 70)
                                                .background(selectedTime == time ? Color.white.opacity(0.8) : Color.clear)
                                                .foregroundColor(selectedTime == time ? color : .white)
                                                .clipShape(Capsule())
                                                .overlay(
                                                    Capsule()
                                                        .stroke(Color.white, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    // Expand/Collapse Button
                    HStack {
                        Spacer()
                        Image(systemName: expandedCardIndex == index ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
            }
            .frame(height: expandedCardIndex == index ? 240 : 100) // Dynamically adjust height
        }
        .buttonStyle(PlainButtonStyle()) // Disable default button styling
    }
}


struct MeditationActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationActivitiesView()
    }
}
