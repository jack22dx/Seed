import SwiftUI
import Foundation

/// Represents a single journaling activity with a name and related questions.
struct JournalingActivity: Identifiable {
    let id: UUID = UUID()
    let name: String
    let questions: [String]
}

/// Represents a category of journaling activities with multiple activities.
struct JournalingCategory: Identifiable {
    let id: Int // Use Int for compatibility with JournalingTabsView
    let name: String
    let activities: [JournalingActivity]
}

/// Sample dataset for journaling activities, divided into four categories.
let journalingCategories: [JournalingCategory] = [
    JournalingCategory(
        id: 0, // Explicit id for each category
        name: "Mindfulness",
        activities: [
            JournalingActivity(name: "Gratitude", questions: [
                "What is one thing you are grateful for today?",
                "What’s one thing you enjoyed today?"
            ]),
            JournalingActivity(name: "Nature", questions: [
                "What’s something you observed in nature today?",
                "When did you last feel stressed?"
            ]),
            JournalingActivity(name: "Peace", questions: [
                "What brings you a sense of peace or calm?",
                "What sensations can you notice in your body at this moment?"
            ])
        ]
    ),
    JournalingCategory(
        id: 1,
        name: "Self-Awareness",
        activities: [
            JournalingActivity(name: "Presence", questions: [
                "When did you feel most present today?",
                "What’s one small act of kindness you can do today?"
            ]),
            JournalingActivity(name: "Thoughts", questions: [
                "What thoughts keep popping up in your mind recently?",
                "What memories bring you a sense of joy or peace?"
            ]),
            JournalingActivity(name: "Challenges", questions: [
                "What is a recent challenge you faced, and how did you respond to it?",
                "How do you usually react when you feel anxious or stressed?"
            ])
        ]
    ),
    JournalingCategory(
        id: 2,
        name: "Emotions",
        activities: [
            JournalingActivity(name: "Patterns", questions: [
                "What patterns have you noticed in your emotions over the past week?",
                "What values or beliefs guide your actions and choices?"
            ]),
            JournalingActivity(name: "Compassion", questions: [
                "What are some ways you can show compassion towards yourself?",
                "What past experiences have shaped the way you think and feel today?"
            ]),
            JournalingActivity(name: "Mindfulness", questions: [
                "How do you respond to difficult emotions, and how could you improve?",
                "What does mindfulness mean to you, and how do you like to practice it?"
            ])
        ]
    ),
    JournalingCategory(
        id: 3,
        name: "Creativity",
        activities: [
            JournalingActivity(name: "Poem", questions: [
                "Write a short poem about something you have experienced in the last week.",
                "What do you fear most? Have your fears changed throughout life?"
            ]),
            JournalingActivity(name: "Peaceful Place", questions: [
                "What place makes you feel most peaceful? Describe that place using all five senses.",
                "Identify one area where you’d like to improve. Then, list three specific actions you can take to create that change."
            ]),
            JournalingActivity(name: "Daily Log", questions: [
                "Write your daily log from 8 am to 8 pm and categorize your activities as either helping or hindering you.",
                "Identify goals for the next week and break them down into action verbs."
            ])
        ]
    )
]
