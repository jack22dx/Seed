import SwiftUI
import WebKit

struct VirtualGardenView: View {
    // State to track garden elements
    @State private var gardenElements: [GardenElement] = [
        GardenElement(id: UUID(), name: "Sunflower", type: .png("sunflower"), position: CGPoint(x: 250, y: 300), scale: 1.0),
        GardenElement(id: UUID(), name: "Trees", type: .png("trees"), position: CGPoint(x: 300, y: 200), scale: 1.5),
        GardenElement(id: UUID(), name: "Purple Flower", type: .png("purpleflower"), position: CGPoint(x: 150, y: 450), scale: 1.0),
        GardenElement(id: UUID(), name: "Rabbit", type: .gif("rabbit"), position: CGPoint(x: 100, y: 300), scale: 1.0),
        GardenElement(id: UUID(), name: "Butterfly", type: .gif("butterfly"), position: CGPoint(x: 200, y: 100), scale: 1.0),
        GardenElement(id: UUID(), name: "Bird", type: .gif("bird"), position: CGPoint(x: 300, y: 50), scale: 1.0)
    ]
    @State private var navigateToGardenView = false
    @State private var navigateToActivitiesView = false
    @State private var navigateToSummaryView = false
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Sky Background
                Image("Sky")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                
                // Mountains Layer
                Image("Mountains")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.6)
                    .offset(y: 60) // Adjust position
                
              
                
                // Grass Layer
                Image("Grass")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.4) // Base frame
                    .scaleEffect(2.5) // Scale 300%
                    .offset(y: UIScreen.main.bounds.height * 0.44) // Adjust to sit at the bottom
                    .ignoresSafeArea() // Ensure it fills the screen appropriately

                Image("river")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.9)
                    .scaleEffect(1.5)
                    .offset(y: 200) // Adjust position
             

              

                // Draggable Garden Elements
                ForEach($gardenElements) { $element in
                    GardenElementView(element: $element)
                }

                // Top controls: Plus and Gear
                VStack {
                    HStack {
                        NavigationLink(destination: AddElementsView(gardenElements: $gardenElements)) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)
                                .padding(.leading, 20)
                        }

                        Spacer()

                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.top, 20)

                    Spacer()
                }

                // Bottom Navigation Bar
                VStack {
                    Spacer()
                    BottomNavigationBar(
                        navigateToGardenView: $navigateToGardenView,
                        navigateToActivitiesView: $navigateToActivitiesView,
                        navigateToSummaryView: $navigateToSummaryView
                    )
                }

            }
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
    }
}


// MARK: - Garden Element
struct GardenElement: Identifiable {
    let id: UUID
    let name: String
    var type: GardenElementType
    var position: CGPoint
    var scale: CGFloat
}

enum GardenElementType {
    case png(String)
    case gif(String)
}

// MARK: - Garden Element View
struct GardenElementView: View {
    @Binding var element: GardenElement
    @State private var dragOffset: CGSize = .zero
    @State private var currentScale: CGFloat = 1.0

    var body: some View {
        Group {
            switch element.type {
            case .png(let imageName):
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100 * element.scale, height: 100 * element.scale)
            case .gif(let gifName):
                GIFView(gifName: gifName)
                    .frame(width: 100 * element.scale, height: 100 * element.scale)
            }
        }
        .position(x: element.position.x + dragOffset.width,
                  y: element.position.y + dragOffset.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    element.position.x += dragOffset.width
                    element.position.y += dragOffset.height
                    dragOffset = .zero
                }
        )
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    currentScale = value
                }
                .onEnded { value in
                    element.scale *= currentScale
                    currentScale = 1.0
                }
        )
    }
}

// MARK: - GIF View
struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        if let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath))
            webView.load(gifData!, mimeType: "image/gif", characterEncodingName: "", baseURL: URL(fileURLWithPath: gifPath))
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// MARK: - Add Elements View
struct AddElementsView: View {
    @Binding var gardenElements: [GardenElement]

    var body: some View {
        NavigationStack {
            VStack {
                Text("Add New Elements")
                    .font(.headline)
                    .padding()

                ScrollView {
                    ForEach(sampleElements) { element in
                        Button(action: {
                            gardenElements.append(element)
                        }) {
                            HStack {
                                if case .png(let imageName) = element.type {
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                                Text(element.name)
                                    .font(.body)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Add Elements")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Sample elements to add
    var sampleElements: [GardenElement] {
        [
            GardenElement(id: UUID(), name: "New Tree", type: .png("trees"), position: CGPoint(x: 100, y: 100), scale: 1.0),
            GardenElement(id: UUID(), name: "New Rabbit", type: .gif("rabbit"), position: CGPoint(x: 150, y: 150), scale: 1.0)
        ]
    }
}

// MARK: - Settings View
struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .padding()

                Spacer()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview
struct VirtualGardenView_Previews: PreviewProvider {
    static var previews: some View {
        VirtualGardenView()
    }
}

struct BottomNavigationBar: View {
    @Binding var navigateToGardenView: Bool
    @Binding var navigateToActivitiesView: Bool
    @Binding var navigateToSummaryView: Bool

    var body: some View {
        HStack {
            // Leaf Button
            NavigationLink(destination: VirtualGardenView().navigationBarHidden(true),
                           isActive: $navigateToGardenView) {
                Button(action: { navigateToGardenView = true }) {
                    Image("leaf")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                }
            }

            Spacer()

            // Play Button
            NavigationLink(destination: ActivitiesView().navigationBarHidden(true),
                           isActive: $navigateToActivitiesView) {
                Button(action: { navigateToActivitiesView = true }) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        )
                }
            }

            Spacer()

            // Pink Button
            NavigationLink(destination: WeeklySummaryView().navigationBarHidden(true),
                           isActive: $navigateToSummaryView) {
                Button(action: { navigateToSummaryView = true }) {
                    Circle()
                        .fill(Color.pink)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                        )
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 60)
    }
}
