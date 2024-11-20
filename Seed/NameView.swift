import SwiftUI
import NavigationTransitions

struct NameView: View {
    @State private var name: String = "" // Tracks user input
    @State private var showContinueButton = false // Controls the appearance of the continue button
    @State private var outerCircleScale: CGFloat = 1.0
    @State private var innerCircleScale: CGFloat = 1.0
    @AppStorage("userName") private var userName: String = "" // Persistent storage for the user's name

    var body: some View {
        let lightpink = Color(hue: 0.89, saturation: 0.4, brightness: 1, opacity: 1.0)
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
                
                VStack(spacing: 30) {
                    // Pulsing circle at the top
                    ZStack {
                        Circle()
                            .stroke(lightpink.opacity(0.3), lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .scaleEffect(outerCircleScale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    outerCircleScale = 1.2 // Pulsing effect for the outer circle
                                }
                            }
                        
                        Circle()
                            .fill(lightpink.opacity(0.6))
                            .frame(width: 40, height: 40)
                            .scaleEffect(innerCircleScale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    innerCircleScale = 0.9 // Pulsing effect for the inner circle
                                }
                            }
                    }
                    .padding(.bottom, -30)
                    
                    // Title
                    Text("What's your name?")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Text Field
                    TextField("Enter your name", text: $name)
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 20))
                        .padding()
                        .background(Color.white.opacity(1))
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                        .onChange(of: name) { _ in
                            withAnimation(.easeInOut) {
                                showContinueButton = !name.isEmpty
                            }
                        }
                    
                    Spacer()
                    
                    // Continue Button
                    if showContinueButton {
                        NavigationLink(destination: ContentView()) {
                            Text("Continue")
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                .padding()
                                .frame(minWidth: 150)
                                .background(buttonColors[1])
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                userName = name // Save the name for later use
                            }
                        )
                    }
                    
                    Spacer()
                }
                .padding(.top, 50)
            }
            .background(Color.black.opacity(0.7).ignoresSafeArea())
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2)))
        .navigationBarHidden(true)
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView()
    }
}
