//
//  Untitled.swift
//  StudentCRUDApp_V
//
//  Created by Yitzu Liu on 13/11/2024.
//
import SwiftData
@Model // Annotation to indicate that this class is a model for data management / 注解，表示该类是数据管理模型
class LessonInfor {
    var name: String // Course name / 课程名称
    var count: Int // Course count / 课程计数
    var Monday: Bool // Monday / 星期一
    var Tuesday: Bool // Tuesday / 星期二
    var Wednesday: Bool // Wednesday / 星期三
    var Thursday: Bool // Thursday / 星期四
    var Friday: Bool // Friday / 星期五
    var Saturday: Bool // Saturday / 星期六
    var Sunday: Bool // Sunday / 星期日
    
    init(name: String, count: Int = 0, Monday: Bool = false, Tuesday: Bool = false,
         Wednesday: Bool = false, Thursday: Bool = false, Friday: Bool = false,
         Saturday: Bool = false, Sunday: Bool = false) { // Initializer / 初始化器
        self.name = name // Assign course name / 赋值课程名称
        self.count = count // Assign course count / 赋值课程计数
        self.Monday = Monday // Assign Monday / 赋值星期一
        self.Tuesday = Tuesday // Assign Tuesday / 赋值星期二
        self.Wednesday = Wednesday // Assign Wednesday / 赋值星期三
        self.Thursday = Thursday // Assign Thursday / 赋值星期四
        self.Friday = Friday // Assign Friday / 赋值星期五
        self.Saturday = Saturday // Assign Saturday / 赋值星期六
        self.Sunday = Sunday // Assign Sunday / 赋值星期日
    }
}

