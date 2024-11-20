//
//  PagevVisit.swift
//  Seed
//
//  Created by Wayne on 2024/11/15.
//

import SwiftData
import Foundation

@Model
class UserLog {
    
    var acno: String
    var pageName: String
    var startTime: Date
    var endTime: Date
    var duration: Double // 停留時間（秒）


    init(acno: String, pageName: String, startTime: Date, endTime: Date, duration: Double) {
        
        self.acno = acno
        self.pageName = pageName
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
    }
}
