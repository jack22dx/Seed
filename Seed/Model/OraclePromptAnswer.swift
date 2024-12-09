//
//  OracleTip.swift
//  Seed
//
//  Created by Wayne on 2024/11/26.
//

import SwiftData
import Foundation


@Model
class OraclePromptAnswer {
    
    var type : String
    var prompt_id: Int
    var tab: String
    var activity: String
    var level: Int
    var answer: String
    var date: Date

    init(type: String, prompt_id: Int, tab:String, activity:String, level:Int, answer: String, date: Date) {
        
        self.type = type
        self.prompt_id = prompt_id
        self.tab = tab
        self.activity = activity
        self.level = level
        self.answer = answer
        self.date = date
    }
}
