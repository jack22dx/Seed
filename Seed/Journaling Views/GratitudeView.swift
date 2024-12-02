import SwiftUI
import NavigationTransitions

struct GratitudeView: View {
    @State private var gratitudeText: String = "" // For the user input in the text area
    @State private var navigateToSelfReflection = false // Tracks navigation to SelfReflectionView

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
                    
                    // Decorative Circle with Flower Image
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 5)
                        
                        Image("purplerose") // Replace with your flower asset if available
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .foregroundColor(Color.purple)
                    }
                    .padding(.bottom, 30)
                    
                    // Title Text
                    Text("What’s one thing you’re grateful for today?")
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
                    TextEditor(text: $gratitudeText)
                        .padding()
                        .frame(height: 150)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // Continue Button with Fade Transition
                    NavigationLink(destination: SelfReflectionView()
                                    .navigationBarHidden(true),
                                     // Fade transition
                                   isActive: $navigateToSelfReflection) {
                        Button(action: {
                            navigateToSelfReflection = true
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
                    .buttonStyle(PlainButtonStyle()).navigationTransition(.fade(.cross).animation(.easeInOut(duration: 1.0))) // Avoid default NavigationLink styling
                }
            }
        }
    }
}

struct GratitudeView_Previews: PreviewProvider {
    static var previews: some View {
        GratitudeView()
    }
}
