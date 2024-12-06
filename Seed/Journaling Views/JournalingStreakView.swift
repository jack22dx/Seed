import SwiftUI

struct JournalingStreakView: View {
    var selectedGardenElement: GardenElementData
    @State private var navigateToActivities = false
    @State private var navigateToGarden = false
    @Query private var lessons: [LessonInfor]  // Automatically query all lessons from the model context
    
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
                        switch selectedGardenElement.type {
                        case .png(let imageName):
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        case .gif(let gifName):
                            GIFView(gifName: gifName)
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        //                        Image("purplerose") // Replace with your tree icon for journaling
                        //                            .resizable()
                        //                            .scaledToFit()
                        //                            .frame(width: 100, height: 100)
                        //                            .clipShape(Circle())
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
                        .navigationDestination(isPresented: $navigateToActivities) {
                            ActivitiesView()
                                .navigationBarHidden(true)
                        }
                        
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
                        .navigationDestination(isPresented: $navigateToGarden) {
                            VirtualGardenView()
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
            .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
            .navigationBarHidden(true)
        }
    }
}

struct JournalingStreakView_Previews: PreviewProvider {
    static var gardenElements: GardenElementData =
    GardenElementData(name: "christmastree", type: .png("christmastree"))
    static var previews: some View {
        JournalingStreakView(selectedGardenElement:gardenElements)
    }
}
