//
//  OracleTip.swift
//  Seed
//
//  Created by Wayne on 2024/11/26.
//

import SwiftData

@Model
class OraclePromptAnswer {
    
    var type : String
    var prompt_id: Int
    var answer: String

    init(type: String, prompt_id: Int, answer: String) {
        
        self.type = type
        self.prompt_id = prompt_id
        self.answer = answer
    }
}
