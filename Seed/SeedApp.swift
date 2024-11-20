
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
        container = try! ModelContainer(for: LessonInfor.self) // Initialize data model container /初始化数据模型容器
        context = container.mainContext // Get main context /获取主上下文
        initializeFunctionsIfNeeded() // Initialize data when the app starts / 在应用启动时初始化数据
        resetService = ResetService(context: context) // Set up the weekly reset service / 设置每周重置服务
    }
    
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            //WelcomeView()
            //.environment(\.managedObjectContext, persistenceController.container.viewContext)
            ActivitiesView()
            WelcomeView()
            //.environment(\.managedObjectContext, persistenceController.container.viewContext)
//            ActivitiesView()
                .environment(\.modelContext, container.mainContext)
        }
        .modelContainer(for: [LessonInfor.self]) // Configure data model / 配置数据模型
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
        
        do {
            try context.save() // Save context / 保存上下文
        } catch {
            print("Failed to save during initialization: \(error)") // Initialization save failed / 初始化保存失败
        }
    }
}
