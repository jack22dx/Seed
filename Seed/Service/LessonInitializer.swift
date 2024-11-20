import SwiftData

func initializeLessonsIfNeeded(context: ModelContext, lessons: [LessonInfor]) {
    if lessons.isEmpty {
        let lessonNames = ["Meditation", "Journaling", "Digital Detox"]
        for name in lessonNames {
            let newLesson = LessonInfor(name: name)
            context.insert(newLesson)
        }
        try? context.save()
    }
}
