import SwiftUI
import WebKit
import SwiftData

struct VirtualGardenView: View {
    @State private var gardenElements: [GardenElement] = [
        GardenElement(id: UUID(), name: "Sunflower", type: .png("sunflower"), position: CGPoint(x: 250, y: 300), scale: 1.0,isVisible: true),
        GardenElement(id: UUID(), name: "Trees", type: .png("trees"), position: CGPoint(x: 300, y: 200), scale: 1.5,isVisible: true),
        GardenElement(id: UUID(), name: "Purple Flower", type: .png("purpleflower"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
        GardenElement(id: UUID(), name: "Rabbit", type: .gif("rabbit"), position: CGPoint(x: 100, y: 300), scale: 1.0,isVisible: true),
        GardenElement(id: UUID(), name: "Butterfly", type: .gif("butterfly"), position: CGPoint(x: 200, y: 100), scale: 1.0,isVisible: true),
        GardenElement(id: UUID(), name: "Bird", type: .gif("bird"), position: CGPoint(x: 300, y: 50), scale: 1.0,isVisible: true)
    ]
    @State private var navigateToGardenView = false
    @State private var navigateToActivitiesView = false
    @State private var navigateToSummaryView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Scrollable Garden
                ScrollView(.horizontal) {
                    ZStack(alignment: .top) {
                        // Wide container for scrolling
                        Color.clear
                            .frame(width: UIScreen.main.bounds.width * 3, height: UIScreen.main.bounds.height)
                        
                        // Sky Background
                        Image("Sky")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 3, height: UIScreen.main.bounds.height)
                            .ignoresSafeArea()
                        
                        // Mountains Layer
                        Image("Mountains")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height )
                            .offset(y: 60)
                            .offset(x: 100)
                            .scaleEffect(1.5)

                        
                            .offset(x: 100)
                            .scaleEffect(1.5)

                        // Grass Layer
                        Image("Grass")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 3, height: UIScreen.main.bounds.height * 0.4)
                            .offset(y: UIScreen.main.bounds.height * 0.44)
                            .ignoresSafeArea()
                        
                        // River
                        Image("river")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 4.0)
                            .scaleEffect(1.5)
                            .offset(y: 160)
                        
                        
                        ForEach($gardenElements) { $element in
                            GardenElementView(element: $element)
                        }
                    }
                }
                
                // Top Controls: Plus and Gear
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
                
                // Fixed Bottom Navigation Bar
                VStack {
                    Spacer()
                    BottomNavigationBar(
                        navigateToGardenView: $navigateToGardenView,
                        navigateToActivitiesView: $navigateToActivitiesView,
                        navigateToSummaryView: $navigateToSummaryView
                    )
                    .padding(.bottom, 50) // Add spacing from the bottom
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
    var isVisible:Bool
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
    @Query private var lessons: [LessonInfor]
    
    private var meditationLessonCount: Int {
        getLessonCount(name: "Meditation")
    }
    private func getLessonCount(name: String) -> Int {
        lessons.first(where: { $0.name == name })?.count ?? 0
    }
    
    var categorizedAssets: [String: [GardenElement]] {
        [
            "Meditation": [
                //Do not delete
                GardenElement(id: UUID(), name: "Sunflower", type: .png("sunflower"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: meditationLessonCount > 0),
                GardenElement(id: UUID(), name: "Butterfly", type: .gif("butterfly"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: meditationLessonCount > 0),
                GardenElement(id: UUID(), name: "Bonsai Tree", type: .png("bonsaitree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: meditationLessonCount > 0),
                GardenElement(id: UUID(), name: "Palm Tree", type: .png("palmtree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: meditationLessonCount > 0),
                GardenElement(id: UUID(), name: "Purple Tree", type: .png("purpletree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: meditationLessonCount >  0),
                GardenElement(id: UUID(), name: "Orange Butterfly", type: .png("orangebutterfly"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: meditationLessonCount > 0),
                GardenElement(id: UUID(), name: "Treeseed", type: .png("treeseed"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: meditationLessonCount > 0),
                //                GardenElement(id: UUID(), name: "Pink Flower", type: .png("pinkflower"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                //                GardenElement(id: UUID(), name: "Sunflower", type: .png("sunflower"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
                //                GardenElement(id: UUID(), name: "Butterfly", type: .gif("butterfly"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                //                GardenElement(id: UUID(), name: "Bonsai Tree", type: .png("bonsaitree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                //                GardenElement(id: UUID(), name: "Palm Tree", type: .png("palmtree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                //                GardenElement(id: UUID(), name: "Purple Tree", type: .png("purpletree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                //                GardenElement(id: UUID(), name: "Orange Butterfly", type: .png("orangebutterfly"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible:true),
                //                GardenElement(id: UUID(), name: "Treeseed", type: .png("treeseed"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                //                GardenElement(id: UUID(), name: "Pink Flower", type: .png("pinkflower"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true)
            ],
            "Journaling": [
                //Do not delete
                //                GardenElement(id: UUID(), name: "Rose", type: .png("rose"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Journaling") > 0),
                //                GardenElement(id: UUID(), name: "Cherry Blossom", type: .png("cherryblossom"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Journaling") > 0),
                //                GardenElement(id: UUID(), name: "Deer", type: .png("deer"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Journaling") > 0),
                //                GardenElement(id: UUID(), name: "Bouquet", type: .png("bouquet"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Journaling") > 0),
                //                GardenElement(id: UUID(), name: "Purple Rose", type: .png("purplerose"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Journaling") > 0),
                //                GardenElement(id: UUID(), name: "Christmastree", type: .png("christmastree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Meditation") > 0),
                //                GardenElement(id: UUID(), name: "Mushroom", type: .png("mushroom"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Journaling") > 0),
                //                GardenElement(id: UUID(), name: "Mountains", type: .png("mountains"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Journaling") > 0)
                GardenElement(id: UUID(), name: "Rose", type: .png("rose"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
                GardenElement(id: UUID(), name: "Cherry Blossom", type: .png("cherryblossom"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                GardenElement(id: UUID(), name: "Deer", type: .png("deer"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                GardenElement(id: UUID(), name: "Bouquet", type: .png("bouquet"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                GardenElement(id: UUID(), name: "Purple Rose", type: .png("purplerose"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                GardenElement(id: UUID(), name: "Christmastree", type: .png("christmastree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: true),
                GardenElement(id: UUID(), name: "Mushroom", type: .png("mushroom"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
                GardenElement(id: UUID(), name: "Mountains", type: .png("mountains"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
            ],
            "Digital Detox": [
                //Do not delete
                GardenElement(id: UUID(), name: "Turtle", type: .png("turtle"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Digital Detox") > 1),
                GardenElement(id: UUID(), name: "Pine Tree", type: .png("pinetree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Digital Detox") > 1),
                GardenElement(id: UUID(), name: "Snow Mountain", type: .png("snowmountain"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Meditation") > 4),
                GardenElement(id: UUID(), name: "Yellow Tree", type: .png("yellowtree"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Digital Detox") > 4),
                GardenElement(id: UUID(), name: "Rabbit", type: .gif("rabbit"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Digital Detox") > 12),
                GardenElement(id: UUID(), name: "Duck", type: .gif("duck"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Digital Detox") > 12),
                GardenElement(id: UUID(), name: "Cat", type: .gif("cat"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Digital Detox") > 20),
                GardenElement(id: UUID(), name: "Bird", type: .gif("bird"), position: CGPoint(x: 150, y: 450), scale: 1.0,isVisible: getLessonCount(name: "Digital Detox") > 20)
            ]
        ]
    }
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) { // Vertical scrollable list
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(categorizedAssets.keys.sorted(), id: \.self) { category in
                        VStack(alignment: .leading) {
                            Text(category)
                                .font(.headline)
                                .padding(.bottom, 8)
                            LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: 16) {
                                ForEach(categorizedAssets[category] ?? []) { element in
                                    Button(action: {
                                        gardenElements.append(element)
                                    }) {
                                        VStack {
                                            if case .png(let imageName) = element.type {
                                                Image(imageName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 80, height: 80)
                                            } else if case .gif(let gifName) = element.type {
                                                GIFView(gifName: gifName)
                                                    .frame(width: 80, height: 80)
                                            }
                                            Text(element.name)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Add Elements")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// Sample elements to add
var sampleElements: [GardenElement] {
    [
        GardenElement(id: UUID(), name: "New Tree", type: .png("trees"), position: CGPoint(x: 100, y: 100), scale: 1.0,isVisible: true),
        GardenElement(id: UUID(), name: "New Rabbit", type: .gif("rabbit"), position: CGPoint(x: 150, y: 150), scale: 1.0,isVisible: true)
    ]
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

// MARK: - Bottom Navigation Bar
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
    }
}

// MARK: - Preview
struct VirtualGardenView_Previews: PreviewProvider {
    static var previews: some View {
        VirtualGardenView()
    }
}
