//
//  OracleTip.swift
//  Seed
//
//  Created by Wayne on 2024/11/26.
//

import SwiftData

@Model
class OraclePrompt {
    
    var type : String
    var id: Int
    var tab: String
    var activity: String
    var level: Int
    var seq: Int
    var text: String

    init( id: Int, type: String, tab: String, activity: String, level: Int, seq: Int, text: String) {
        
        self.id = id
        self.type = type
        self.tab = tab
        self.activity = activity
        self.level = level
        self.seq = seq
        self.text = text
    }
}
