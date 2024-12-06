import SwiftUI
import NavigationTransitions
import SwiftData


struct MoodSelectionView: View {
    @State private var moodValue: Double = 1.0 // Slider value to represent mood
    @State private var navigateToGratitudeView = false // Tracks navigation to GratitudeView
    @Query private var lessons: [LessonInfor]// Automatically query all lessons from the model context
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        let backgroundGradient = LinearGradient(
            gradient: Gradient(colors: [Color.yellow.opacity(0.7), Color.orange.opacity(0.6)]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        NavigationStack {
            ZStack {
                // Background gradient
                PlayerView()
                    .ignoresSafeArea()
                Color.yellow
                    .opacity(0.2) // Adjust transparency as needed
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Decorative Circle with Image
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 5)
                        
                        Image("purplerose") // Replace with your flower asset if available
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.purple)
                    }
                    .padding(.bottom, 30)
                    
                    // Title Text
                    Text("How do you feel today?")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                        .shadow(radius: 5)
                    
                    // Mood Icons and Slider
                    VStack {
                        HStack {
                            // Mood Faces
                            Image("sad") // Replace with custom sad face asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color.blue.opacity(0.8))
                            
                            Spacer()
                            
                            Image("middle") // Replace with custom neutral face asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color.orange.opacity(0.8))
                            
                            Spacer()
                            
                            Image("smile") // Replace with custom happy face asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color.green.opacity(0.8))
                        }
                        .padding(.horizontal, 30)
                        
                        // Slider
                        Slider(
                            value: $moodValue,
                            in: 1...3,
                            step: 1
                        )
                        .accentColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 50)
                    
                    Spacer()
                    
                    // Continue Button with Fade Transition
                    NavigationLink(destination: GratitudeView()
                        .navigationBarHidden(true),
                                   
                                   isActive: $navigateToGratitudeView) {
                        Button(action: {
                            navigateToGratitudeView = true
                            //                            incrementCount(for:"Journaling")incrementCount
                        }) {
                            Text("Continue")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [Color.green, Color.teal]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                )
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                        }
                    }
                                   .padding(.bottom, 50)
                                   .buttonStyle(PlainButtonStyle())
                                   .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 1.0)))// Fade transition// Avoid default NavigationLink styling
                }
            }
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
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
}

struct MoodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MoodSelectionView()
    }
}
