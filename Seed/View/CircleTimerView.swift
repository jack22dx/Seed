////
////  CircleTimerView.swift
////  Seed
////
////  Created by Wayne on 2024/11/16.
////
//
//import SwiftUI
//import SwiftData
//
//struct CircularTimerView: View {
//    @State private var elapsedTime: TimeInterval = 0.0 // 累計經過的時間
//    @State private var isRunning: Bool = false        // 記錄計時器是否正在運行
//    @State private var timer: Timer?                  // 計時器
//    
//    var body: some View {
//        
//        let lightblue = Color(hue: 0.55, saturation: 0.6, brightness: 0.9, opacity: 1.0)
//        let disabledColor = Color.gray.opacity(0.5) // 停用狀態的顏色
//        
//        ZStack {
//            // 背景播放器
//            PlayerView()
//                .ignoresSafeArea() // 讓播放器背景填滿螢幕
//
//            // 計時器視圖
//            VStack(spacing: 60) {
//                // 圓形進度條與時間顯示
//                ZStack {
//                    // 背景圓形
//                    Circle()
//                        .stroke(Color.white.opacity(0.3), lineWidth: 10)
//                        .frame(width: 300, height: 300)
//                    
//                    // 進度圓弧
//                    Circle()
//                        .trim(from: 0.0, to: progress())
//                        .stroke(Color.teal, style: StrokeStyle(lineWidth: 10, lineCap: .round))
//                        .rotationEffect(.degrees(-90)) // 起始位置在上方
//                        .frame(width: 300, height: 300)
//                    
//                    // 中間的時間文字
//                    Text(timeString(from: elapsedTime))
//                        .font(.system(size: 40, weight: .bold, design: .monospaced)).foregroundColor(.white).opacity(0.8)
//                }
//                
//                // 按鈕區域
//                HStack(spacing: 20) {
//                    // 開始/繼續按鈕
//                    Button(action: isRunning ? resumeTimer : startTimer) {
//                        HStack {
//                            Image(systemName: disableButton() ? "timer" : "play.fill" )
//                            Text(disableButton() ? "Start" :"Resume")
//                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: disableButton() ? 18:16))
//                                .foregroundColor(.white)
//                        }
//                        .frame(width: 100, height: 50)
//                        .background(!isRunning ? lightblue : disabledColor) // 禁用狀態下顯示灰色背景
//                        .foregroundColor(!isRunning ? .white : .gray)  // 禁用狀態下顯示灰色文字
//                        .cornerRadius(40)
//                    }
//                    .disabled(isRunning) // 這裡呼叫 disableButton 方法
//
//                    
//                    // 停止按鈕
//                    Button(action: stopTimer) {
//                        HStack {
//                            Image(systemName: "stop.fill")
//                            Text("Stop")
//                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
//                                .foregroundColor(.white)
//                        }
//                        .frame(width: 100, height: 50)
//                        .background(isRunning ? lightblue : disabledColor) // 禁用狀態下顯示灰色背景
//                        .foregroundColor(isRunning ? .white : .gray)  // 禁用狀態下顯示灰色文字
//                        .cornerRadius(40)
//                    }
//                    .disabled(!isRunning)
//                    
//                    // 重置按鈕
//                    Button(action: resetTimer) {
//                        HStack {
//                            Image(systemName: "arrow.counterclockwise")
//                            Text("Reset")
//                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 18))
//                                .foregroundColor(.white)
//                        }
//                        .frame(width: 100, height: 50)
//                        .background(lightblue)
//                        .foregroundColor(.white)
//                        .cornerRadius(40)
//                    }
//                    .disabled(elapsedTime == 0.0) // 當時間為 0 時禁用
//                }
//            }
//            .padding(0)
//        }
//    }
//    
//    // 判斷按鈕是否應該禁用
//    private func disableButton() -> Bool {
//        
//
//        if isRunning  {
//            return true
//            
//        } else {
//            
//            if elapsedTime == 0{
//                return true
//            }else{
//                return false
//            }
//        }
//        
//    }
//    
//    // 計算進度：以 60 秒為單位填滿圓弧
//    private func progress() -> CGFloat {
//        return CGFloat((elapsedTime.truncatingRemainder(dividingBy: 60)) / 60)
//    }
//    
//    // 時間格式化：顯示 HH:MM:SS
//    private func timeString(from time: TimeInterval) -> String {
//        let hours = Int(time) / 3600
//        let minutes = (Int(time) % 3600) / 60
//        let seconds = Int(time) % 60
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
//    
//    // 開始計時
//    private func startTimer() {
//        
//        isRunning = true
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            elapsedTime += 1.0
//        }
//    }
//    
//    // 繼續計時
//    private func resumeTimer() {
//        isRunning = true
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            elapsedTime += 1.0
//        }
//    }
//    
//    // 停止計時
//    private func stopTimer() {
//        isRunning = false
//        timer?.invalidate()
//        timer = nil
//    }
//    
//    // 重置計時
//    private func resetTimer() {
//        stopTimer() // 停止計時
//        elapsedTime = 0.0
//    }
//}
//
//struct CircularTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircularTimerView()
//    }
//}
