import SwiftUI
import NavigationTransitions

struct MeditationView: View {
    @State private var navigateToMeditationStart = false
    var selectedTime: String?
    
    // Garden elements data source
    static let gardenElements: [GardenElementData] = [
        GardenElementData(name: "sunflower", type: .png("sunflower")),
        GardenElementData(name: "butterfly", type: .gif("butterfly")),
        GardenElementData(name: "bonsaitree", type: .png("bonsaitree")),
        GardenElementData(name: "palmtree", type: .png("palmtree")),
        GardenElementData(name: "purpletree", type: .png("purpletree")),
        GardenElementData(name: "orangebutterfly", type: .png("orangebutterfly")),
        GardenElementData(name: "treeseed", type: .png("treeseed"))
    ]
    
    // Compute selected garden element based on time
    var selectedGardenElement: GardenElementData {
        guard let time = selectedTime, let timeInt = Int(time) else {
            return Self.gardenElements.first { $0.name == "sunflower" }!
        }
        
        let filteredElements: [GardenElementData]
        switch timeInt {
        case ...3:
            filteredElements = Self.gardenElements.filter { ["sunflower", "butterfly"].contains($0.name) }
        case 3...6:
            filteredElements = Self.gardenElements.filter { ["bonsaitree", "palmtree"].contains($0.name) }
        case 7...:
            filteredElements = Self.gardenElements.filter { ["purpletree", "orangebutterfly", "treeseed"].contains($0.name) }
        default:
            filteredElements = []
        }
        
        return filteredElements.randomElement() ?? Self.gardenElements.first { $0.name == "sunflower" }!
    }
    
    var displayText: String {
        let timeString = selectedTime ?? "3"
        return timeString + " min 35 seconds"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlayerView().ignoresSafeArea()
                
                Color.blue.opacity(0.2).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Circular image container
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 250, height: 250)
                        
                        // Render image based on type
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
                    }
                    
                    // Garden element name
                    Text(selectedGardenElement.name.capitalized)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Time display
                    Text(displayText ?? "3 min 35 seconds")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Navigation Link with Start Button
                    NavigationLink(destination: MeditationStartView(selectedTime:selectedTime ?? "3", selectedGardenElement: selectedGardenElement),
                                   isActive: $navigateToMeditationStart) {
                        Button("Start") {
                            navigateToMeditationStart = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
    }
}

// Preview provider
struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView(selectedTime: "3")
    }
}
