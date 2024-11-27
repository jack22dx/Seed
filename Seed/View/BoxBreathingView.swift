//
//  BoxBreathing.swift
//  Seed
//
//  Created by Wayne on 2024/11/16.
//

import SwiftUI
import SwiftData

struct BoxBreathingView: View {
    
//    @Environment(\.modelContext) private var context // Get the environment variable for the database context
//    @AppStorage("acno") var acno: String = ""  // 使用 @AppStorage 來取得 acno 的值
    
    @State private var progress: CGFloat = 0.0
    @State private var remainingSeconds: Int = 4
    @State private var currentPhase: Int = 0
    
    @State private var startTime: Date? // 記錄進入時間
    @State private var endTime: Date? // 記錄退出時間
    
    let phaseDuration: Double = 4.0 // 每條邊的時間
    let totalPhases = 4 // 正方形有4個邊
    let timerInterval: Double = 1.0 // 秒數倒數的間隔

    // 階段名稱
    let phaseNames = ["Breathe in", "Hold", "Breathe out", "Relax"]

    var body: some View {
        
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.6 // 正方形大小占螢幕60%
            let offset = size / 2 + 40 // 文字與正方形距離

            ZStack {
                // 背景播放器
                PlayerView()
                    .ignoresSafeArea() // 讓播放器背景填滿螢幕


                // 正方形進度與框
                ZStack {
                    
                    // 顯示標題文字
                    VStack {
                        Text("Box Breathing")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 28))
                            .foregroundColor(Color.white)
                            .padding(.top, 80)
                            .shadow(radius: 10)

                        Spacer()
                    }
                    
                    // 正方形框
                    Rectangle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 4)
                        .frame(width: size, height: size)

                    // 動態進度條
                    SquareProgress(progress: progress)
                        .stroke(Color.white, lineWidth: 8)
                        .frame(width: size, height: size)

                    // 階段名稱與倒數計時文字
                    VStack {
                        
                        Text(phaseNames[currentPhase]) // 階段名稱
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                            .padding(.bottom, 4)

                        Text("\(remainingSeconds) Seconds") // 倒數計時
                            .foregroundColor(.white)
                            .font(.system(size: 28))
                            .bold()
                    }
                }
            }

            .onAppear {
//                startTime = Date() // 記錄進入時間
                startBreathingCycle()
            }
            .onDisappear {
//                endTime = Date() // 記錄退出時間
//                saveSessionData() // 保存數據
            }
        }
    }

    func startBreathingCycle() {
        
        // 初始化進度條動畫
        withAnimation(.linear(duration: phaseDuration)) {
            progress = 1.0
        }

        // 啟動每秒更新的計時器
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            remainingSeconds -= 1

            if remainingSeconds <= 0 {
                // 切換到下一個階段
                currentPhase = (currentPhase + 1) % totalPhases
                remainingSeconds = Int(phaseDuration)
                
                // 重置進度條並啟動下一段動畫
                progress = 0.0
                withAnimation(.linear(duration: phaseDuration)) {
                    progress = 1.0
                }
            }
        }
    }
    
    func saveSessionData() {
        
//        do{
//            print("要save")
//            
//            guard let startTime = startTime, let endTime = endTime else {
//                return
//            }
            
//            guard let container = try? ModelContainer(for: UserLog.self) else {
//                print("no container")
//                return }
//            guard let container = try? ModelContainer(for: UserLog.self), // Attempt to get the model container for Student
//                  let url = container.configurations.first?.url.path(percentEncoded: false) else { // Get the URL of the database
//                print("Could not find database location") // Print error message if not found
//                return // Return from the function
//            }
//            print("Database location!!!!!: \(url)")
//            
//            let context = container.mainContext
//            let timeSpent = endTime.timeIntervalSince(startTime)
//            let pageName = "Box Breathing"
            
            // 模擬保存到 SwiftData (請替換為真實的 SwiftData 模型與存儲邏輯)
//            let userLog = UserLog(acno: acno, pageName: pageName, startTime: startTime, endTime: endTime, duration: timeSpent)
            
            
//            context.insert(userLog)
//            try context.save()
            
//            print("Saved UserLog data: \(userLog.acno)")
            
            // 在此處添加將數據保存到 SwiftData 的邏輯
//        }catch{
//            
//            print("Saved UserLog data error: \(error)")
//        }
    }
    
    
}


struct SessionData {
    var acno: String
    var pageName: String
    var startTime: Date
    var endTime: Date
    var duration: TimeInterval
}

struct SquareProgress: Shape {
    var progress: CGFloat

    func path(in rect: CGRect) -> Path {
        let side = rect.width
        let perimeter = side * 4
        let progressLength = progress * perimeter

        var path = Path()

        // 起始點
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))

        // 繪製進度條順時針運行
        if progressLength <= side {
            path.addLine(to: CGPoint(x: rect.minX + progressLength, y: rect.minY))
        } else if progressLength <= 2 * side {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + (progressLength - side)))
        } else if progressLength <= 3 * side {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - (progressLength - 2 * side), y: rect.maxY))
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - (progressLength - 3 * side)))
        }

        return path
    }
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
}

struct BoxBreathingView_Previews: PreviewProvider {
    static var previews: some View {
        BoxBreathingView()
    }
}
