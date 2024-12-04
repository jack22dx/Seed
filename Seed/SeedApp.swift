
//  SeedApp.swift
//  Seed
//
//  Created by Jack on 4/11/2024.
//

import SwiftUI
import SwiftData

@main
struct SeedApp: App {
    
    private let container: ModelContainer // Data model container / 数据模型容器
    private let context: ModelContext // Data context / 数据上下文
    private var resetService: ResetService? // Reset service / 重置服务
    init() {
        container = try! ModelContainer(for: LessonInfor.self,  OracleTip.self, OracleFact.self, OraclePrompt.self, OraclePromptAnswer.self  )
        context = container.mainContext // Get main context /获取主上下文
        initializeFunctionsIfNeeded() // Initialize data when the app starts / 在应用启动时初始化数据
        resetService = ResetService(context: context) // Set up the weekly reset service / 设置每周重置服务
    }
    
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
        
            WelcomeView()
     
            
            //.environment(\.managedObjectContext, persistenceController.container.viewContext)
//            ActivitiesView()
                .environment(\.modelContext, container.mainContext)
        }
        .modelContainer(for: [LessonInfor.self,  OracleTip.self, OracleFact.self,  OraclePrompt.self ]) // Configure data model / 配置数据模型
    }
    private func initializeFunctionsIfNeeded() {
        let functionNames = ["Meditation", "Journaling", "Digital Detox"] // Course names / 课程名称
        
        for name in functionNames {
            let fetchRequest = FetchDescriptor<LessonInfor>(predicate: #Predicate { $0.name == name }) // Fetch course information / 获取课程信息
            let existing = try? context.fetch(fetchRequest) // Query existing courses / 查询现有课程
            if existing?.isEmpty ?? true {
                let newLesson = LessonInfor(name: name) // Create new course / 创建新课程
                context.insert(newLesson) // Insert new course / 插入新课程
            }
        }
        
        //oracle_tip
        if isOracleTipRecordExist(for: 1, in: context) { // check oracle_tip data
        
            let oracleTips = [
                
                //meditation
                OracleTip(type: "meditation", level: 1, seq: 1, text: "Find a quiet, comfortable place where you won’t be disturbed."),
                OracleTip(type: "meditation", level: 1, seq: 2, text: "Sit in a relaxed position or lie down if preferred."),
                OracleTip(type: "meditation", level: 1, seq: 3, text: "Don’t worry about stopping your thoughts; instead, gently bring your focus back when your mind wanders."),
                OracleTip(type: "meditation", level: 1, seq: 4, text: "Consistent practice will help you get the most out of meditation."),
                OracleTip(type: "meditation", level: 1, seq: 5, text: "Experiment with different techniques, like guided meditation, breathing exercises, or body scan meditations."),
                OracleTip(type: "meditation", level: 1, seq: 6, text: "Try incorporating meditation into your daily routine, such as after waking up or before sleeping."),
                OracleTip(type: "meditation", level: 1, seq: 7, text: "Be patient; meditation is a skill that takes time and practice."),
                OracleTip(type: "meditation", level: 1, seq: 8, text: "Write about your meditation experience in your journal to reflect on your progress."),
                OracleTip(type: "meditation", level: 1, seq: 9, text: "Try setting an intention for your meditation, such as achieving greater calmness or clarity."),
                
                //journeling
                OracleTip(type: "journaling", level: 1, seq: 1, text: "Find a quiet, comfortable place where you won’t be disturbed."),
                OracleTip(type: "journaling", level: 1, seq: 2, text: "Don’t worry about your trail of thoughts; instead, write about whatever is on your mind."),
                OracleTip(type: "journaling", level: 1, seq: 3, text: "Consistent practice will help you get the most out of journaling."),
                OracleTip(type: "journaling", level: 1, seq: 4, text: "Try incorporating journaling into your daily routine, such as upon waking (dream journaling) or before sleeping."),
                OracleTip(type: "journaling", level: 1, seq: 5, text: "Don’t worry about grammar or spelling, focus on expressing your thoughts freely."),
                OracleTip(type: "journaling", level: 1, seq: 6, text: "Use bullet points or lists if writing full sentences feels overwhelming."),
                OracleTip(type: "journaling", level: 1, seq: 7, text: "Your journaling doesn't have to be in Seed, try drawing something to reflect your feelings."),
                
                //detox
                OracleTip(type: "detox", level: 1, seq: 1, text: "Try setting regular times of day to digitally detox."),
                OracleTip(type: "detox", level: 1, seq: 2, text: "Use your phones screen time settings to monitor which apps you spend the most time in."),
                OracleTip(type: "detox", level: 1, seq: 3, text: "Try leaving your phone in another room or your bag when you are working/studying."),
                OracleTip(type: "detox", level: 1, seq: 4, text: "Try replacing time you usually spend on your phone with other activities such as reading or exercise."),
                OracleTip(type: "detox", level: 1, seq: 5, text: "Start off small and gradually increase the amount of time you detox."),
                OracleTip(type: "detox", level: 1, seq: 6, text: "Turn off your phones notifications to avoid the distraction."),
                OracleTip(type: "detox", level: 1, seq: 7, text: "Try deleting any apps you find to be too distracting."),
                OracleTip(type: "detox", level: 1, seq: 8, text: "Changing your phone to grayscale mode can help reduce your screentime.")
            ]

            // 按照 level 和 seq 屬性進行排序
            let sortedOracleTips = oracleTips.sorted {
                if $0.level == $1.level {
                    return $0.seq < $1.seq
                }
                return $0.level < $1.level
            }

            sortedOracleTips.forEach { tip in
                context.insert(tip)
            }
            
//            for tip in sortedOracleTips {
//                print("Level: \(tip.level), Seq: \(tip.seq), Text: \(tip.text)")
//            }

        }else{
            
            print("has oracle_tip data");
        }
      
        //oracle_fact
        if isOracleFactRecordExist(for: 1, in: context) { // check oracle_fact data
        
            let oracleFacts = [
                
                //meditation
                OracleFact(type: "meditation", id: 1, text: "Regular meditation can help to lower cortisol, the stress hormone."),
                OracleFact(type: "meditation", id: 2, text: "Mindful meditation can help reduce anxiety."),
                OracleFact(type: "meditation", id: 3, text: "Meditation can help reduce blood pressure over time."),
                OracleFact(type: "meditation", id: 4, text: "Regular meditation can improve sleep."),
                OracleFact(type: "meditation", id: 5, text: "Meditation can help with addictions and cravings."),
                OracleFact(type: "meditation", id: 6, text: "Just eight weeks of mindfulness meditation can significantly improve mood and well-being."),
                OracleFact(type: "meditation", id: 7, text: "Loving-kindness meditation increases positive emotions and social connections."),
                OracleFact(type: "meditation", id: 8, text: "Meditation enhances self-awareness, helping you better understand your emotions."),
                OracleFact(type: "meditation", id: 9, text: "Deep breathing stimulates the vagus nerve, promoting relaxation."),
                OracleFact(type: "meditation", id: 10, text: "Regular meditation can help cultivate compassion."),
                
                //journaling
                OracleFact(type: "journaling", id: 1, text: "Expressive writing can help reduce stress by providing an outlet for emotions."),
                OracleFact(type: "journaling", id: 2, text: "Writing about positive experiences can enhance your mood."),
                OracleFact(type: "journaling", id: 3, text: "Journaling before bed may improve sleep by clearing the mind."),
                OracleFact(type: "journaling", id: 4, text: "Writing about trauma or difficult experiences can help with emotional healing."),
                OracleFact(type: "journaling", id: 5, text: "Journaling helps track patterns, triggers, and progress in your mindulness journey."),
                OracleFact(type: "journaling", id: 6, text: "Expressive writing engages both analytical and artistic parts of the brain, enhancing self-expression."),
                OracleFact(type: "journaling", id: 7, text: "Regular journaling can improve problem-solving skills by encouraging deeper reflection on challenges."),
                OracleFact(type: "journaling", id: 8, text: "Regular journaling can help develop your introspective skills, and help you better understand your emotions."),

                
                //detox
                OracleFact(type: "detox", id: 1, text: "Digital detoxing can help improve sleep quality by reducing blue light exposure before bedtime."),
                OracleFact(type: "detox", id: 2, text: "Taking breaks from your phone enhances focus and productivity during work or study."),
                OracleFact(type: "detox", id: 3, text: "A digital detox can help you foster deeper connections with family and friends through in-person interaction."),
                OracleFact(type: "detox", id: 4, text: "Stepping away from your phone promotes mindfulness and being present in the moment."),
                OracleFact(type: "detox", id: 5, text: "Less screen time can help prevent eye strain and improve overall eye health."),
                OracleFact(type: "detox", id: 6, text: "Digital detoxing can help improve your mood."),
                OracleFact(type: "detox", id: 7, text: "Studies have found a strong and significant assosciation between social media use and depression."),

            ]

            oracleFacts.forEach { fact in
                context.insert(fact)
            }
            
//            for fact in oracleFacts {
//                print("type: \(fact.type), id: \(fact.id), Text: \(fact.text)")
//            }

        }else{
            
            print("has oracle_fact data");
        }
        
        //oracle_prompt
        if isOraclePromptRecordExist(for: 1, in: context) { // check oracle_fact data
        
            let oraclePrompts = [
                
                //journaling
                OraclePrompt(type: "journaling", id: 1, text: "How are you feeling right now?"),
                OraclePrompt(type: "journaling", id: 2, text: "What is one thing you are grateful for today?"),
                OraclePrompt(type: "journaling", id: 3, text: "What’s one thing you enjoyed today?"),
                OraclePrompt(type: "journaling", id: 4, text: "What’s something you observed in nature today?"),
                OraclePrompt(type: "journaling", id: 5, text: "When did you last feel stressed?"),
                OraclePrompt(type: "journaling", id: 6, text: "What brings you a sense of peace or calm?"),
                OraclePrompt(type: "journaling", id: 7, text: "What sensations can you notice in your body at this moment?"),
                OraclePrompt(type: "journaling", id: 8, text: "When did you feel most present today?"),
                OraclePrompt(type: "journaling", id: 9, text: "What’s one small act of kindness you can do today?"),
                OraclePrompt(type: "journaling", id: 10, text: "What thoughts keep popping up in your mind recently?"),
                OraclePrompt(type: "journaling", id: 11, text: "What memories bring you a sense of joy or peace?"),
                OraclePrompt(type: "journaling", id: 12, text: "What is a recent challenge you faced, and how did you respond to it?"),
                OraclePrompt(type: "journaling", id: 13, text: "How do you usually react when you feel anxious or stressed?"),
                OraclePrompt(type: "journaling", id: 14, text: "What patterns have you noticed in your emotions over the past week?"),
                OraclePrompt(type: "journaling", id: 15, text: "What values or beliefs guide your actions and choices?"),
                OraclePrompt(type: "journaling", id: 16, text: "What are some ways you can show compassion towards yourself?"),
                OraclePrompt(type: "journaling", id: 17, text: "What past experiences have shaped the way you think and feel today?"),
                OraclePrompt(type: "journaling", id: 18, text: "How do you respond to difficult emotions, and how could you improve?"),
                OraclePrompt(type: "journaling", id: 19, text: "What does mindfulness mean to you, and how do you like to practice it?"),
                OraclePrompt(type: "journaling", id: 20, text: "Write a short poem about something you have experienced in the last week.")

            ]

            oraclePrompts.forEach { prompt in
                context.insert(prompt)
            }
            
//            for prompt in oraclePrompts {
//                print("id: \(prompt.id), Text: \(prompt.text)")
//            }

        }else{
            
            print("has oracle_prompt data");
        }
        
        do {
            try context.save() // Save context / 保存上下文
//            printDatabaseLocation(container: container);


        } catch {
            print("Failed to save during initialization: \(error)") // Initialization save failed / 初始化保存失败
        }
    }
    
    // Overloaded helper method for checking `OracleTip` records by level
    private func isOracleTipRecordExist(for level: Int, in context: ModelContext) -> Bool {
        let fetchRequest_oracle = FetchDescriptor<OracleTip>(predicate: #Predicate { $0.level == level })
        do {
            let existing_oracle = try context.fetch(fetchRequest_oracle)
            return existing_oracle.isEmpty
        } catch {
            print("Failed to fetch for OracleTip level \(level): \(error)")
            return false
        }
    }
    
    // Overloaded helper method for checking `OracleFact` records by id
    private func isOracleFactRecordExist(for id: Int, in context: ModelContext) -> Bool {
        let fetchRequest_oracle = FetchDescriptor<OracleFact>(predicate: #Predicate { $0.id == id })
        do {
            let existing_oracle = try context.fetch(fetchRequest_oracle)
            return existing_oracle.isEmpty
        } catch {
            print("Failed to fetch for OracleFact id \(id): \(error)")
            return false
        }
    }

    // Overloaded helper method for checking `OraclePrompt` records by id
    private func isOraclePromptRecordExist(for id: Int, in context: ModelContext) -> Bool {
        let fetchRequest_oracle = FetchDescriptor<OraclePrompt>(predicate: #Predicate { $0.id == id })
        do {
            let existing_oracle = try context.fetch(fetchRequest_oracle)
            return existing_oracle.isEmpty
        } catch {
            print("Failed to fetch for OracleFact id \(id): \(error)")
            return false
        }
    }
    
    private func printDatabaseLocation(container: ModelContainer) {
        // 檢查是否能找到 URL
        guard let url = container.configurations.first?.url else {
            print("Could not find database location")
            return
        }
        print("Database location: \(url.absoluteString)")
    }
}
