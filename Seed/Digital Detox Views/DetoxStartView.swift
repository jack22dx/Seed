import SwiftUI
import NavigationTransitions

struct DetoxStartView: View {
    @State private var elapsedTime: TimeInterval = 0.0 // Cumulative elapsed time
    @State private var isRunning: Bool = false        // Tracks if the timer is running
    @State private var timer: Timer?                  // Timer instance
    @State private var navigateToSummary: Bool = false // Tracks navigation to DetoxSummaryView
    @State private var showTipsPopup: Bool = false     // Tracks if the tips popup is displayed
    
    let totalTime: TimeInterval = 25 * 60 // 25 minutes in seconds
    
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
                    
                    // 提示按鈕
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showTipsPopup.toggle()
                        }
                    }) {
                        Text("Tips")
                            .font(Font.custom("Visby", size: 18))
                            .padding()
                            .frame(width: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.5)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                            )
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                    
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
}

struct DetoxStartView_Previews: PreviewProvider {
    static var previews: some View {
        DetoxStartView()
    }
}
