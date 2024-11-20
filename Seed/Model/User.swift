//
//  User.swift
//  Seed
//
//  Created by Wayne on 2024/11/17.
//

import SwiftData

@Model
class User {
    @Attribute(.unique) var acno: String // 使用帳號作為主鍵
    var name: String
    var email: String
    var userLog: [UserLog] = [] // 與 UserLog 表的關聯（一對多）

    init(acno: String, name: String, email: String) {
        self.acno = acno
        self.name = name
        self.email = email
    }
}
