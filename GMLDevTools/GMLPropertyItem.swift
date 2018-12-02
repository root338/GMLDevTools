//
//  GMLPropertyItem.swift
//  GMLDevTools
//
//  Created by apple on 2018/12/2.
//  Copyright © 2018年 apple. All rights reserved.
//

import Cocoa

enum GMLClassType : String {
    case null = "NSNull"
    case string = "NSString"
    case dictionary = "NSDictionary"
    case number = "NSNumber"
    case array = "NSArray"
    case custom = "<#Custom Class#>"
}

enum GMLClassProperties : String {
    case nonatomic = "nonatomic"
    case copy = "copy"
    case strong = "strong"
    case assign = "assign"
    case atomic = "atomic"
    case readonly = "readonly"
    case readwrite = "readwrite"
    case weak = "weak"
    case nullable = "nullable"
}

struct GMLPropertyItem {
    
    let level: Int
    let classType: GMLClassType
    let includeProperties: [GMLClassProperties]
    let name: String
    private(set) var subItem: [GMLPropertyItem]?
    
    var propertyString : String {
        var propertiesText : String?
        for propertiesValue in includeProperties {
            if propertiesText == nil {
                propertiesText = propertiesValue.rawValue
            }else {
                propertiesText!.append(", \(propertiesValue.rawValue)")
            }
        }
        
        return "@property (\(propertiesText!)) \(classType.rawValue) *\(name);"
    }
    
    mutating func addSubitem(_ item: GMLPropertyItem) {
        subItem?.append(item)
    }
}
