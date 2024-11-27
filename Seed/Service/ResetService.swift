//
//  ResetService.swift
//  StudentCRUDApp_V
//
//  Created by Yitzu Liu on 19/11/2024.
//

import SwiftUI
import SwiftData

class ResetService {
    private var timer: Timer? // Timer / 定时器
    private var context: ModelContext // Data context / 数据上下文
    
    init(context: ModelContext) {
        self.context = context // Initialize context / 初始化上下文
        scheduleWeeklyReset() // Schedule weekly reset / 安排每周重置
    }
    
    private func scheduleWeeklyReset() {
        // Cancel any existing timer / 取消任何现有的定时器
        timer?.invalidate()
        
        // Schedule a timer that fires every minute / 安排一个每分钟触发的定时器
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkAndReset() // Check and reset / 检查并重置
        }
    }
    
    private func checkAndReset() {
        let now = Date() // Current time / 当前时间
        let calendar = Calendar.current // Current calendar / 当前日历
        let components = calendar.dateComponents([.weekday, .hour, .minute], from: now) // Get current weekday, hour, and minute / 获取当前的星期、小时和分钟
        
        let isMondayAtMidnight = components.weekday == 2 && components.hour == 0 && components.minute == 0 // Check if it's Monday at midnight / 判断是否是星期一的午夜
        
        if isMondayAtMidnight {
            resetWeekdayAndWeekend() // Reset weekdays and weekends / 重置工作日和周末
        }
    }
    
    
    private func resetWeekdayAndWeekend() {
        let fetchRequest = FetchDescriptor<LessonInfor>() // Fetch request for course information / 获取课程信息的请求
        
        do {
            let allLessons = try context.fetch(fetchRequest) // Fetch all courses / 获取所有课程
            for lesson in allLessons {
                lesson.Monday = false // Reset Monday / 重置星期一
                lesson.Tuesday = false // Reset Tuesday / 重置星期二
                lesson.Wednesday = false // Reset Wednesday / 重置星期三
                lesson.Thursday = false // Reset Thursday / 重置星期四
                lesson.Friday = false // Reset Friday / 重置星期五
                lesson.Saturday = false // Reset Saturday / 重置星期六
                lesson.Sunday = false // Reset Sunday / 重置星期日
            }
            try context.save() // Attempt to save context / 尝试保存上下文
            print("Successfully reset weekdays and weekends.") // Successfully reset weekdays and weekends / 成功重置工作日和周末
        } catch {
            print("Failed to reset weekdays and weekends: \(error)") // Failed to reset weekdays and weekends / 重置失败
        }
    }
}
