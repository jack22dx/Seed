import SwiftUI
import SwiftData


struct WeeklySummaryView: View {
    @State private var navigateToGardenView = false
    @State private var navigateToActivitiesView = false
    @State private var navigateToSummaryView = false
    
    //for oracle prompt
    @Environment(\.modelContext) private var modelContext
    @State var type: String = "journaling";
    @State var prompt_result: [OraclePrompt] = []
    @State var answer_result: [OraclePromptAnswer] = []


    @Query private var lessons: [LessonInfor]  // Automatically query all lessons from the model context
    var journalingLessonCount: Int {
        lessons.first(where: { $0.name == "Journaling" })?.count ?? 0
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background with PlayerView
                    PlayerView()
                        .ignoresSafeArea()

                    VStack {
                        // Header
                        Text("This Week’s Summary")
                            .font(Font.custom("Visby", size: 30))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.top, geometry.size.height * 0.03)
                            .padding(.bottom,50)

                        // Summary Cards
                        VStack(spacing: geometry.size.height * 0.05) {
                            DynamicCard(
                                title: "Meditation",
                                description: "You meditated for a total of 25 minutes. Well done on reaching Level 3!",
                                cardColor: Color.cyan,
                                tipsDestination: MeditationTipsView(),
                                geometry: geometry,
                                hasExclamation: true
                            )
                            .frame(height: geometry.size.height * 0.18)
                            .padding(.horizontal, geometry.size.width * 0.05)
                            .lineSpacing(10)

                            DynamicMoodCard(
                                title: "Journaling",
                                description: "Journaling to record your emotions and gain a deeper understanding of your inner self",
                                moods: ["😃", "🙂", "😐", "😐", "🙂", "😔", "😔"],
                                cardColor: Color.red.opacity(0.6),
                                tipsDestination: MoodTipsView(prompt_result: prompt_result, answer_result: answer_result),
                                geometry: geometry
                            )
                            .frame(height: geometry.size.height * 0.22)
                            .padding(.horizontal, geometry.size.width * 0.05)
                            .lineSpacing(10)

                            DynamicCard(
                                title: "Digital Detox",
                                description: "You detoxed for a total of 2 hours 15 minutes so far. Good job!",
                                cardColor: Color.orange.opacity(0.7),
                                tipsDestination: DetoxTipsView(),
                                geometry: geometry,
                                hasExclamation: true
                            )
                            .frame(height: geometry.size.height * 0.18)
                            .padding(.horizontal, geometry.size.width * 0.05)
                            .lineSpacing(10)
                        }

                        Spacer()

                        // Bottom Navigation Bar
                        BottomNavigationBar(
                            navigateToGardenView: $navigateToGardenView,
                            navigateToActivitiesView: $navigateToActivitiesView,
                            navigateToSummaryView: $navigateToSummaryView
                        )
                      // Respect safe area
                        .padding(.top,58)
                    }
                    .onAppear(){
                        
                        fetchOraclePrompt()
                        fetchOraclePromptAnswer()
                    }
                }
            }
        }
        .navigationTransition(.fade(.cross).animation(.easeInOut(duration: 2.0)))
    }
    
    func fetchOraclePrompt() {
        
        let fetchRequest = FetchDescriptor<OraclePrompt>(
            predicate: #Predicate {
                $0.type == type
            },
            sortBy: [
                SortDescriptor(\OraclePrompt.id),  // Sort by id
                SortDescriptor(\OraclePrompt.level),  // Sort by level
                SortDescriptor(\OraclePrompt.seq)     // Then sort by seq
            ]
        )

        do {
            
            let fetchedResults = try modelContext.fetch(fetchRequest)
            
            prompt_result = fetchedResults
            
        } catch {
            print("Failed to fetch OraclePrompt: \(error)")
        }
    }
    
    func fetchOraclePromptAnswer() {
        
        let fetchRequest = FetchDescriptor<OraclePromptAnswer>(
            predicate: #Predicate {
                $0.type == type
            },
            sortBy: [
                SortDescriptor(\OraclePromptAnswer.prompt_id),  // Sort by id
                SortDescriptor(\OraclePromptAnswer.level),  // Sort by level
            ]
        )

        do {
            
            let fetchedResults = try modelContext.fetch(fetchRequest)
            
            answer_result = fetchedResults
            
        } catch {
            print("Failed to fetch OraclePromptAnswer: \(error)")
        }
    }
}

// MARK: - Dynamic Card Component
struct DynamicCard<Destination: View>: View {
    var title: String
    var description: String
    var cardColor: Color
    var tipsDestination: Destination
    var geometry: GeometryProxy
    var hasExclamation: Bool = false // Option to include exclamation point

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(cardColor)
                .shadow(radius: 5)

            VStack(alignment: .center, spacing: 10) {
                // Title
                Text(title)
                    .font(Font.custom("Visby", size: 20))
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                // Description
                Text(description + (hasExclamation ? "!" : ""))
                    .font(Font.custom("Visby", size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - Dynamic Mood Card Component
struct DynamicMoodCard<Destination: View>: View {
    var title: String
    var description: String
    var moods: [String]
    var cardColor: Color
    var tipsDestination: Destination
    var geometry: GeometryProxy
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 15)
                .fill(cardColor)
                .shadow(radius: 5)

            VStack(alignment: .center, spacing: 10) {
                // Title
                Text(title)
                    .font(Font.custom("Visby", size: 20))
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                // Description without full stop
                Text(description)
                    .font(Font.custom("Visby", size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)

                // Mood Emojis
                HStack(spacing: geometry.size.width * 0.02) {
                    ForEach(moods, id: \.self) { mood in
                        Text(mood)
                            .font(.largeTitle) // Emoji size
                    }
                }
                .padding(.vertical, 5)

                // Tips Button in the center
                NavigationLink(destination: tipsDestination) {
                    Text("Tips")
                        .font(Font.custom("Visby", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - Tips Views
struct MeditationTipsView: View {
    
    var body: some View {
        ZStack {
            PlayerView()
                .ignoresSafeArea()

            VStack {
                Text("Meditation Tips")
                    .font(Font.custom("Visby", size: 30))
                    .foregroundColor(.white)
                    .padding()

                Text("""
                    1. Start with 5 minutes daily.
                    2. Focus on your breath.
                    3. Try a 2-minute body scan exercise.
                """)
                    .font(Font.custom("Visby", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .lineSpacing(10)

                Spacer()
            }
        }
    }
}

struct MoodTipsView: View {
    
    var prompt_result: [OraclePrompt]
    var answer_result : [OraclePromptAnswer]


    var body: some View {
        
        
        
        let match_prompt: [OraclePrompt] = answer_result.compactMap { answer in
            // 找到 prompt_result 中符合 prompt_id 的 OraclePrompt
            return prompt_result.first(where: { $0.id == answer.prompt_id })
        }
        
        let mindfulness_prompt = match_prompt.filter { $0.tab == "mindfulness" }.sorted { ($0.level == $1.level) ? $0.seq < $1.seq : $0.level < $1.level }
        let self_awareness_prompt = match_prompt.filter { $0.tab == "self awareness" }.sorted { ($0.level == $1.level) ? $0.seq < $1.seq : $0.level < $1.level }
        let emotions_prompt = match_prompt.filter { $0.tab == "emotions" }.sorted { ($0.level == $1.level) ? $0.seq < $1.seq : $0.level < $1.level }
        let creativity_prompt = match_prompt.filter { $0.tab == "creativity" }.sorted { ($0.level == $1.level) ? $0.seq < $1.seq : $0.level < $1.level }
        
        JournalView(match_prompt: match_prompt, answer_result: answer_result,mindfulness_prompt: mindfulness_prompt, self_awareness_prompt: self_awareness_prompt, emotions_prompt: emotions_prompt, creativity_prompt: creativity_prompt)
    }
    

}

struct JournalView: View {
    
    var match_prompt: [OraclePrompt]
    var answer_result: [OraclePromptAnswer]
    var mindfulness_prompt: [OraclePrompt]
    var self_awareness_prompt: [OraclePrompt]
    var emotions_prompt: [OraclePrompt]
    var creativity_prompt: [OraclePrompt]

    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    ForEach(match_prompt, id: \.id) { entry in  // 以 entry.id 作為唯一識別符
                        Section(header: headerView(for: entry.tab, activity: entry.activity)) {
                            Text(entry.text)
                                .font(.headline)
                                .padding(.bottom, 5)
                            //                                // 顯示 TextField 來讓用戶輸入
                            //                                TextField("Your response...", text: Binding(
                            //                                    get: { entry.response ?? "" }, // 如果 response 是可選的，提供默認值
                            //                                    set: { entry.response = $0 }
                            //                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .listRowBackground(backgroundColor(for: entry.tab)) // 區分每個分類的背景顏色
//                        Section(header: headerView(for: entry.tab, activity: entry.activity)) {
//                            Text(entry.question)
//                                .font(.headline)
//                                .padding(.bottom, 5)
////                                TextField("Your response...")
////                                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                        }
//                        .listRowBackground(backgroundColor(for: entry.tab)) // 區分每個分類的背景顏色
                    }
                }
                .navigationTitle("Weekly Journal")
                .listStyle(InsetGroupedListStyle())
            }
        }
    }

    // 自定義標題樣式
    func headerView(for category: String, activity: String) -> some View {
        HStack {
            Text("\(category) - \(activity)")
                .font(.headline)
                .foregroundColor(textColor(for: category)) // 根據分類設置文字顏色
                .padding()
        }
        .background(backgroundColor(for: category)) // 背景顏色
        .cornerRadius(10)
    }

    // 根據分類返回不同的背景顏色
    func backgroundColor(for category: String) -> Color {
        switch category {
        case "mindfulness": return Color.green.opacity(0.2)
        case "self awareness": return Color.blue.opacity(0.2)
        case "emotions": return Color.red.opacity(0.2)
        case "creativity": return Color.yellow.opacity(0.2)
        default: return Color.gray.opacity(0.2)
        }
    }

    // 根據分類返回不同的文字顏色
    func textColor(for category: String) -> Color {
        switch category {
        case "mindfulness": return Color.green
        case "self awareness": return Color.blue
        case "emotions": return Color.red
        case "creativity": return Color.yellow
        default: return Color.gray
        }
    }
}

struct DetoxTipsView: View {
    var body: some View {
        ZStack {
            PlayerView()
                .ignoresSafeArea()

            VStack {
                Text("Digital Detox Tips")
                    .font(Font.custom("Visby", size: 30))
                    .foregroundColor(.white)
                    .padding()

                Text("""
                    1. Schedule screen-free time daily.
                    2. Turn off non-essential notifications.
                    3. Replace screen time with hobbies or exercise.
                """)
                    .font(Font.custom("Visby", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .lineSpacing(10)

                Spacer()
            }
        }
    }
}

// MARK: - Preview
//struct WeeklySummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeeklySummaryView()
//    }
//}
