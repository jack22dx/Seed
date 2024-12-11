import SwiftUI
import WebKit
import SwiftData

struct AddElementsView: View {
    @Binding var gardenElements: [GardenElement]
    @Query private var lessons: [LessonInfor]
    var onElementAdded: () -> Void // Callback to notify when an element is added

    private var meditationLessonCount: Int {
        getLessonCount(name: "Meditation")
    }

    private func getLessonCount(name: String) -> Int {
        lessons.first(where: { $0.name == name })?.count ?? 0
    }

    // Helper functions to define assets
    private var meditationAssets: [GardenElement] {
        [
            GardenElement(id: UUID(), name: "Sunflower", type: .png("sunflower"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: meditationLessonCount > 0),
            GardenElement(id: UUID(), name: "Butterfly", type: .gif("butterfly"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: meditationLessonCount > 0),
            GardenElement(id: UUID(), name: "Bonsai Tree", type: .png("bonsaitree"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: meditationLessonCount > 0),
            GardenElement(id: UUID(), name: "Palm Tree", type: .png("palmtree"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: meditationLessonCount > 0),
            GardenElement(id: UUID(), name: "Purple Tree", type: .png("purpletree"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: meditationLessonCount > 0),
            GardenElement(id: UUID(), name: "Orange Butterfly", type: .png("orangebutterfly"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: meditationLessonCount > 0),
            GardenElement(id: UUID(), name: "Treeseed", type: .png("treeseed"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: meditationLessonCount > 0)
        ]
    }

    private var journalingAssets: [GardenElement] {
        [
            GardenElement(id: UUID(), name: "Rose", type: .png("rose"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
            GardenElement(id: UUID(), name: "Cherry Blossom", type: .png("cherryblossom"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
            GardenElement(id: UUID(), name: "Deer", type: .png("deer"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
            GardenElement(id: UUID(), name: "Bouquet", type: .png("bouquet"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
            GardenElement(id: UUID(), name: "Purple Rose", type: .png("purplerose"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
            GardenElement(id: UUID(), name: "Christmastree", type: .png("christmastree"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
            GardenElement(id: UUID(), name: "Mushroom", type: .png("mushroom"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true),
            GardenElement(id: UUID(), name: "Mountains", type: .png("mountains"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: true)
        ]
    }

    private var digitalDetoxAssets: [GardenElement] {
        [
            GardenElement(id: UUID(), name: "Turtle", type: .png("turtle"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Digital Detox") > 1),
            GardenElement(id: UUID(), name: "Pine Tree", type: .png("pinetree"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Digital Detox") > 1),
            GardenElement(id: UUID(), name: "Snow Mountain", type: .png("snowmountain"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Meditation") > 4),
            GardenElement(id: UUID(), name: "Yellow Tree", type: .png("yellowtree"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Digital Detox") > 4),
            GardenElement(id: UUID(), name: "Rabbit", type: .gif("rabbit"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Digital Detox") > 12),
            GardenElement(id: UUID(), name: "Duck", type: .gif("duck"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Digital Detox") > 12),
            GardenElement(id: UUID(), name: "Cat", type: .gif("cat"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Digital Detox") > 20),
            GardenElement(id: UUID(), name: "Bird", type: .gif("bird"), position: CGPoint(x: 150, y: 450), scale: 1.0, isVisible: getLessonCount(name: "Digital Detox") > 20)
        ]
    }

    // Consolidated assets dictionary
    var categorizedAssets: [String: [GardenElement]] {
        [
            "Meditation": meditationAssets,
            "Journaling": journalingAssets,
            "Digital Detox": digitalDetoxAssets
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
                                        onElementAdded() // Trigger the callback
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
