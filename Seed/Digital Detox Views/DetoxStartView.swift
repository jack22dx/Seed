import SwiftUI
import NavigationTransitions
import SwiftData


struct DetoxStartView: View {
    @State private var elapsedTime: TimeInterval = 0.0 // Cumulative elapsed time
    @State private var isRunning: Bool = false        // Tracks if the timer is running
    @State private var timer: Timer?                  // Timer instance
    @State private var navigateToSummary: Bool = false // Tracks navigation to DetoxSummaryView
    @State private var showTipsPopup: Bool = false     // Tracks if the tips popup is displayed
    
    let totalTime: TimeInterval = 25 * 60 // 25 minutes in seconds
    
    //for oracle
    @Environment(\.modelContext) private var modelContext
    @State private var oracleTips_detox: [OracleTip] = []
    @State private var clickTipBtn: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                Color.red.opacity(0.2).ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // 標題與鹿的頭像
                    VStack(spacing: 10) {
                        Text("Daphne the Deer")
                            .font(Font.custom("Visby", size: 25))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.bottom, 20)
                            .padding(.top, 50)

                        
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.6))
                                .frame(width: 100, height: 100)
                                .shadow(radius: 10)
                            
                            Image("deer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        }
                        .padding(.bottom, 20)
                        
                        Text("Detox Mode")
                            .font(Font.custom("Visby", size: 20))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    
                    // 倒數計時器
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 10)
                            .frame(width: 250, height: 250)
                        
                        Circle()
                            .trim(from: 0.0, to: progress())
                            .stroke(Color.yellow, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 250, height: 250)
                        
                        Text(timeString(from: totalTime - elapsedTime))
                            .font(Font.custom("Visby", size: 40))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    
                    .padding(.bottom, 20) // 底部間距

                    // 提示按鈕
                    Button(action: {
                        timer?.invalidate() // Pause the timer
                        isRunning = false
                        self.clickTipBtn = true
                    }) {
                        Text("Tips")
                            .font(Font.custom("Visby", size: 18))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(Color.orange.opacity(0.5))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    NavigationLink(
                        destination: DetoxOracleTipsView(oracleTips: oracleTips_detox),
                        isActive: $clickTipBtn // 使用狀態綁定
                    ){}
                    
                    // 控制按鈕 (播放/暫停，停止)
                    HStack(spacing: 40) {
                        Button(action: isRunning ? stopTimer : startTimer) {
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                .font(.system(size: 24))
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            stopTimer()
                            navigateToSummary = true
                        }) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 24))
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.bottom, 50)
                }
                .padding()
                
                // 彈出視窗
                if showTipsPopup {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showTipsPopup = false
                                }
                            }
                        
                        VStack(spacing: 20) {
                            Text("Tips to Avoid Distractions")
                                .font(Font.custom("Visby", size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(0.8)))
                                .shadow(radius: 10)
                            
                            Text("""
                                • Turn off notifications on your devices.
                                • Put your phone in another room.
                                • Use a physical notepad for urgent reminders.
                                • Let others know you're unavailable.
                                """)
                                .font(Font.custom("Visby", size: 18))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.leading)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.2)))
                            
                            Button("Close") {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showTipsPopup = false
                                }
                            }
                            .font(Font.custom("Visby", size: 18))
                            .padding()
                            .frame(width: 120)
                            .background(Color.gray.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(40)
                        }
                        .padding()
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        .transition(.opacity)
                    }
                }
            }
            .onAppear {
                if !isRunning {
                    startTimer()
                }
                fetchOracleTips()
            }
            .navigationDestination(isPresented: $navigateToSummary) {
                DetoxSummaryView(elapsedTime: elapsedTime)
            }
        }
    }
    
    private func progress() -> CGFloat {
        return CGFloat(elapsedTime / totalTime)
    }
    
    private func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1.0
            if elapsedTime >= totalTime {
                stopTimer()
                navigateToSummary = true
            }
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func fetchOracleTips() {
        
        let fetchRequest = FetchDescriptor<OracleTip>(
            predicate: #Predicate { $0.type == "detox" },
            sortBy: [
                SortDescriptor(\OracleTip.level),  // Sort by level
                SortDescriptor(\OracleTip.seq)     // Then sort by seq
            ]
        )
        
        do {
            
            let  oracleTips = try modelContext.fetch(fetchRequest)
            
            if (oracleTips_detox.isEmpty) {
                
                oracleTips_detox.removeAll();
                
                for tip in oracleTips {
                    
                    oracleTips_detox.append(tip)
                }
            }
            
        } catch {
            print("Failed to fetch OracleTips: \(error)")
        }
    }
}

// MARK: - Tips Views
struct DetoxOracleTipsView: View {
    
    let oracleTips: [OracleTip]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                PlayerView()
                    .ignoresSafeArea()
                Color.red.opacity(0.2).ignoresSafeArea()

                VStack {
                    Text("Digital Detox Tips")
                        .font(Font.custom("Visby", size: 30))
                        .foregroundColor(.white)
                        .padding()
                    
                    ScrollView {
                        
                        // Use ForEach to display the oracleTips
                        ForEach(oracleTips, id: \.seq) { tip in
                            Text("\(tip.seq). \(tip.text)")
                                .font(Font.custom("Visby", size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .lineSpacing(10)
                        }
                    }
                    .frame(height: geometry.size.height * 0.6) // screen height 60%
                    
                    // scroll more icon
                    VStack {
                        Spacer()
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.bottom, 8)
                        Text("Scroll down for more")
                            .font(Font.custom("Visby", size: 14))
                            .foregroundColor(.white)
                    }
                    .opacity(0.8)
                    
                    Spacer()
                }
            }
        }
    }
}

struct DetoxStartView_Previews: PreviewProvider {
    static var previews: some View {
        DetoxStartView()
    }
}
