import SwiftUI
import NavigationTransitions

struct MeditationView: View {
    @State private var navigateToMeditationStart = false // Tracks navigation state
    
    var body: some View {
        let lightblue = Color(hue: 0.55, saturation: 0.6, brightness: 0.9, opacity: 1.0)
        
        NavigationStack {
            ZStack {
                // Video Player Background
                PlayerView()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Top image section with circular gradient background
                    ZStack {
                        Circle() // White circle with 70% opacity
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 250, height: 250)
                        
                        Image("treeseed") // Replace with the name of your image asset
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    Spacer()
                    
                    // Main content
                    VStack(spacing: 10) {
                        Text("Crimson Oak Tree")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 28))
                            .foregroundColor(Color.white)
                            .padding(.bottom, 5)
                            .shadow(radius: 10)
                        
                        Text("3 minutes 35 seconds")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        
                        Text("Guided Meditation")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                    }
                    
                    Spacer()
                    
                    // Start Button
                    NavigationLink(destination: MeditationStartView(),
            
                        isActive: $navigateToMeditationStart) {
                        
                        Button(action: {
                            navigateToMeditationStart = true // Trigger navigation
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 40) // Use a rounded rectangle for the button background
                                    .fill(lightblue)
                                    .frame(width: 120, height: 50) // Adjust rectangle size as needed
                                    .shadow(radius: 2)
                                
                                Text("Start")
                                    .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes default button styling
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .background(Color("BackgroundColor").ignoresSafeArea())
                .navigationBarHidden(true)
            }
            .navigationBarHidden(true)
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
        .navigationBarHidden(true)
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView()
    }
}
