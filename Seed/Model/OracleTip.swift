//
//  OracleTip.swift
//  Seed
//
//  Created by Wayne on 2024/11/26.
//

import SwiftData

@Model
class OracleTip {
    var type : String
    var level: Int
    var seq: Int
    var text: String


    init(type: String, level: Int, seq: Int, text: String) {
        
        self.type = type
        self.level = level
        self.seq = seq
        self.text = text
    }
}
