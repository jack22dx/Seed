import SwiftUI

// JournalingData.swift
import SwiftUI




struct MoodSelectionView: View {
    let activity: JournalingActivity // Receives the selected activity
    @State private var moodValue: Double = 1.0 // Slider value to represent mood
    @State private var navigateToQuestionsView = false // Tracks navigation to QuestionsView

    var body: some View {
        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                Color.yellow
                    .opacity(0.2)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    // Decorative Circle with Image
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 5)

                        Image("purplerose") // Replace with your custom asset
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

                    // Mood Slider with Icons
                    VStack {
                        HStack {
                            Image("sad") // Replace with a sad face asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color.blue.opacity(0.8))

                            Spacer()

                            Image("middle") // Replace with a neutral face asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color.orange.opacity(0.8))

                            Spacer()

                            Image("smile") // Replace with a happy face asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color.green.opacity(0.8))
                        }
                        .padding(.horizontal, 30)

                        Slider(value: $moodValue, in: 1...3, step: 1)
                            .accentColor(.white)
                            .padding(.horizontal, 50)
                            .padding(.top, 20)
                    }
                    .padding(.bottom, 50)

                    Spacer()

                    // Continue Button with Navigation
                    NavigationLink(
                        destination: QuestionsView(activity: activity)
                            .navigationBarHidden(true),
                        isActive: $navigateToQuestionsView
                    ) {
                        Button(action: {
                            navigateToQuestionsView = true
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
                }
            }
        }
    }
}

struct MoodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MoodSelectionView(activity: JournalingActivity(
            name: "Gratitude",
            questions: ["What is one thing you are grateful for today?", "What’s one thing you enjoyed today?"]
        ))
    }
}
