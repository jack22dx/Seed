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
    var text: String

    init(type: String, id: Int, text: String) {
        
        self.type = type
        self.id = id
        self.text = text
    }
}
