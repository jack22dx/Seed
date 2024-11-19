import SwiftUI

struct MeditationActivitiesView: View {
    var body: some View {
        ZStack {
            // Background Color
            PlayerView()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title
                Text("Meditation")
                    .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .shadow(radius: 5)
                
                // Meditation Cards
                ScrollView {
                    VStack(spacing: 20) {
                        MeditationCard(
                            title: "Breath Work",
                            time: "1 min",
                            imageName: "treeIcon", // Replace with your image name
                            description: nil,
                            isExpanded: false
                        )
                        
                        MeditationCard(
                            title: "Guided Session",
                            time: "3 min",
                            imageName: "palmIcon", // Replace with your image name
                            description: "This guided meditation incorporates awareness of sounds, bodily sensations, thoughts or feelings.",
                            isExpanded: true
                        )
                        
                        MeditationCard(
                            title: "Mindful Imagery",
                            time: "4 min",
                            imageName: "pineIcon", // Replace with your image name
                            description: nil,
                            isExpanded: false
                        )
                        
                        MeditationCard(
                            title: "Body Scan",
                            time: "3 min",
                            imageName: "treeIcon", // Replace with your image name
                            description: nil,
                            isExpanded: false
                        )
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Bottom Navigation
                HStack {
                    Image(systemName: "leaf.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        print("Play button tapped")
                    }) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                            )
                    }
                    
                    Spacer()
                    
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .padding()
                }
                .padding(.horizontal, 30)
            }
            .padding(.top, 40)
        }
    }
}

struct MeditationCard: View {
    var title: String
    var time: String
    var imageName: String
    var description: String?
    var isExpanded: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .frame(height: isExpanded ? 200 : 100)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    // Icon
                    Image(imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    
                    // Title and Time
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 20))
                            .foregroundColor(.white)
                        Text(time)
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Check Icon
                    if isExpanded {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                // Description (if expanded)
                if let description = description, isExpanded {
                    Text(description)
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 14))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
    }
}

struct MeditationActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationActivitiesView()
    }
}

