import SwiftUI
import NavigationTransitions

struct ActivitiesView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                PlayerView()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Greeting
                    Text("Good Morning, Jack.")
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 30))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .shadow(radius: 5)
                    
                    // Activities
                    VStack(spacing: 40) {
                        // Meditation Card with NavigationLink
                        NavigationLink(
                            destination: MeditationActivitiesView()
                                .navigationTransition(.fade(.cross))
                        ) {
                            ActivityCard(
                                title: "Meditation",
                                progress: 2,
                                colors: [Color.cyan, Color.teal],
                                days: ["M", "T", "W", "T", "F", "S", "S"],
                                completed: [true, false, false, false, false, false, false]
                            )
                            .padding(.trailing, 20)
                            .padding(.leading, 20)
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button style
                        
                        // Journaling Card
                        ActivityCard(
                            title: "Journaling",
                            progress: 5,
                            colors: [Color.purple, Color.yellow],
                            days: ["M", "T", "W", "T", "F", "S", "S"],
                            completed: [true, true, true, false, false, false, false]
                        )
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
                        
                        // Digital Detox Card
                        ActivityCard(
                            title: "Digital Detox",
                            progress: 3,
                            colors: [Color.orange, Color.green],
                            days: ["M", "T", "W", "T", "F", "S", "S"],
                            completed: [true, true, false, false, false, false, false]
                        )
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
                    }
                    
                    Spacer()
                    
                    // Bottom Navigation
                    HStack {
                        Image(systemName: "leaf.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                            .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            print("Play button tapped")
                        }) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                )
                        }
                        
                        Spacer()
                        
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 40)
            }
        }
    }
}

struct ActivityCard: View {
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
                        .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 24))
                        .foregroundColor(.white)
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 4)
                            .frame(width: 40, height: 40)
                        Text("\(progress)")
                            .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 20))
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
                                .font(Font.custom("FONTSPRING DEMO - Visby CF Demi Bold", size: 14))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
//
//  Activitiesview.swift
//  Seed
//
//  Created by Jack on 17/11/2024.
//

