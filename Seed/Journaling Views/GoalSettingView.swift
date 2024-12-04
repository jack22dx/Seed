import SwiftUI
import NavigationTransitions
import SwiftData

struct GoalSettingView: View {
    @State private var goalText: String = "" // For the user input in the text area
    @State private var navigateToStreakView = false // State to track navigation

    //for oracle
    @Environment(\.modelContext) private var modelContext
    @State private var oracleTips_journaling: [OracleTip] = []
    
    var body: some View {
        NavigationStack { // Ensure NavigationStack wraps the view hierarchy
            ZStack {
                // Background gradient and overlay
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
                    Text("What’s a goal you’d like to work towards tomorrow?")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 25))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .shadow(radius: 5)
                    
                    // Tips Button in the center
                    NavigationLink(destination: JournalingOracleTipsView(oracleTips: oracleTips_journaling)) {
                            Text("Tips")
                            .font(Font.custom("Visby", size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(Color.red)
                            .opacity(0.8) // Adjust transparency as needed
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 30)
                    
                    // Text Input Area
                    TextEditor(text: $goalText)
                        .padding()
                        .frame(height: 200)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // Continue Button
                    Button(action: {
                        navigateToStreakView = true // Trigger navigation
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
                    .padding(.bottom, 50)
                    .background(
                        NavigationLink("", destination: JournalingStreakView().navigationBarHidden(true), isActive: $navigateToStreakView)
                            .hidden() // Make the NavigationLink invisible
                    )
                }
                .onDisappear {
                    
                    fetchOracleTips()
                }
            }
            .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 1.0)))// Avoid default NavigationLink styling
        
        }
    }
    
    func fetchOracleTips() {
                
        let fetchRequest = FetchDescriptor<OracleTip>(
            predicate: #Predicate { $0.type == "journaling" },
            sortBy: [
                SortDescriptor(\OracleTip.level),  // Sort by level
                SortDescriptor(\OracleTip.seq)     // Then sort by seq
            ]
        )
        
        do {
            
           let  oracleTips = try modelContext.fetch(fetchRequest)
            
            if (oracleTips_journaling.isEmpty) {
                
                oracleTips_journaling.removeAll();

                for tip in oracleTips {
                    
                    oracleTips_journaling.append(tip)
                }
            }
            
       } catch {
           print("Failed to fetch OracleTips: \(error)")
       }
    }
}

struct GoalSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GoalSettingView()
    }
}
