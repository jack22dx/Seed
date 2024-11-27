import SwiftUI

struct ActivityCardView: View {
    var title: String
    var progress: Int
    var colors: [Color]
    var days: [String]
    var completed: [Bool]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 150)
                .shadow(radius: 5)
            
            VStack(spacing: 15) {
                // Title and Progress
                HStack {
                    Text(title)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 4)
                            .frame(width: 40, height: 40)
                        Text("\(progress)")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 20)
                }
                
                // Days of the Week
                HStack(spacing: 15) {
                    ForEach(0..<days.count, id: \.self) { index in
                        ZStack {
                            Circle()
                                .fill(completed[index] ? Color.white : Color.clear)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            Text(days[index])
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }
}
