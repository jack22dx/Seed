//
//  ElementForGarden.swift
//  Seed
//
//  Created by Yitzu Liu on 05/12/2024.
//
//
//import SwiftData
//@Model // Annotation to indicate that this class is a model for data management / 注解，表示该类是数据管理模型
//class ElementForGarden {
//    var elementName : String
//    var isVisible : Bool
//    
//    init(elementName: String, isVisible: Bool) {
//        self.elementName = elementName
//        self.isVisible = isVisible
//    }
//}
import Foundation

struct GardenElementData {
    let name: String
    let type: GardenElementType
}
enum GardenElementDataType {
    case png(String)
    case gif(String)
}
