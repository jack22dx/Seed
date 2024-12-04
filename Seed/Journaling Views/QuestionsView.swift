import SwiftUI



struct QuestionsView: View {
    let activity: JournalingActivity // Receives the selected activity
    @State private var currentQuestionIndex: Int = 0 // Tracks the current question index
    @State private var answer: String = "" // User's answer for the current question
    @State private var navigateToStreakView = false // Tracks navigation to JournalingStreakView

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

                    // Decorative Circle with Activity Image
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 5)

                        Image("purplerose") // Replace with your custom asset
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                    }
                    .padding(.bottom, 30)

                    // Question Title
                    Text(activity.questions[currentQuestionIndex])
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .shadow(radius: 5)

                    // Tips Button
                    Button(action: {
                        print("Tips button tapped")
                    }) {
                        Text("Tips")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .padding()
                            .frame(width: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.red.opacity(0.9), Color.orange.opacity(0.9)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                            )
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)

                    // Text Input Area
                    TextEditor(text: $answer)
                        .padding()
                        .frame(height: 150)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)

                    Spacer()

                    // Continue Button
                    Button(action: handleContinue) {
                        Text(currentQuestionIndex < activity.questions.count - 1 ? "Next" : "Finish")
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
                    .padding(.bottom, 50)
                    .background(
                        NavigationLink(
                            destination: JournalingStreakView()
                                .navigationBarHidden(true),
                            isActive: $navigateToStreakView
                        ) {
                            EmptyView()
                        }
                    )
                }
            }
        }
    }

    /// Handles "Next" or "Finish" button actions
    private func handleContinue() {
        if currentQuestionIndex < activity.questions.count - 1 {
            // Move to the next question
            currentQuestionIndex += 1
            answer = "" // Reset the answer field
        } else {
            // Navigate to JournalingStreakView
            navigateToStreakView = true
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView(activity: JournalingActivity(
            name: "Gratitude",
            questions: ["What is one thing you are grateful for today?", "What’s one thing you enjoyed today?"]
        ))
    }
}

