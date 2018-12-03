//
//  GMLJSONText.swift
//  GMLDevTools
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018 apple. All rights reserved.
//

import Cocoa

enum GMLJSONTextError: Error {
    case toDataError
    case toJSONError
    case irregularData
    case keyMustIsString
}

class GMLJSONText: NSObject {
    
    let originText : String
    let encoding : String.Encoding
    let jsonObj : Any
    
    init(text: String, encoding: String.Encoding = .utf8) throws {
        super.init()
        guard let data = text.data(using: encoding) else {
            throw GMLJSONTextError.toDataError
        }
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            self.jsonObj = jsonObj
        }catch {
            throw GMLJSONTextError.toJSONError
        }
        self.originText = text
        self.encoding = encoding
    }
    
    
    
}

//MARK:- 对外接口
extension GMLJSONText {
    
}

//MARK:- Private Method
fileprivate extension GMLJSONText {
    
    func shouldDownAnalysis(value: Any, level: Int) throws ->Bool {
        if value is NSDictionary {
            return true
        }else if value is NSArray {
            let classType = try internalClassType(for: value as! NSArray)
            if classType == .array || classType == .dictionary {
                return true
            }
        }
        return false
    }
    
    func internalClassType(for array: NSArray) throws ->GMLClassType {
        var classTypeValue : GMLClassType?
        for value in array {
            let type = classType(value: value)
            if classTypeValue == nil {
                classTypeValue = type
            }else {
                if classTypeValue != type {
                    throw GMLJSONTextError.irregularData
                }
            }
        }
        return classTypeValue!
    }
    
    func analysis(value: Any, level: Int) throws -> GMLPropertyItem? {
        guard try shouldDownAnalysis(value: value, level: level) else {
            return nil
        }
        
        if let dict = value as? NSDictionary {
            for (key, value) in dict {
                guard let paramKey = key as? String else {
                    throw GMLJSONTextError.keyMustIsString
                }
                var item = createItem(name: paramKey, value: value, level: level)
                guard let subitem = try analysis(value: value, level: level - 1) else {
                    break
                }
                item.addSubitem(subitem)
            }
        }else if let array = value as? NSArray {
            
        }
    }
    
    func handleArray(_ value: [Any]) {
        
    }
    
    func handleInputContent(_ inputContent: Any, level: Int) -> GMLPropertyItem {
        
        let classTypeValue = classType(value: inputContent)
        let includePropertiesValue = properties()
        let name : String
        
        if let dict = inputContent as? [String : Any] {
            for (key, value) in dict {
                var item = createItem(name: key, value: value, level: level)
                item.addSubitem(handleInputContent(value, level: level - 1))
            }
        }else if let array = inputContent as? [Any] {
            
            var item = createItem(name: nil, value: array.first!, level: level)
        }
        
        return items
    }
    
    func createItem(name: String?, value: Any, level: Int) -> GMLPropertyItem {
        let item = GMLPropertyItem.init(level: level, classType: classType(value: value), includeProperties: properties(), name: name, subItem: nil, error: nil)
        return item
    }
    
    func classType(value: Any) -> GMLClassType {
        let classType : GMLClassType
        
        if value is Array<Any> {
            classType = .array
        }else if value is Dictionary<String, Any> {
            classType = .dictionary
        }else if value is String {
            classType = .string
        }else if value is NSNumber {
            classType = .number
        }else if value is NSNull {
            classType = .null
        }else {
            classType = .custom
        }
        return classType
    }
    
    func properties() -> [GMLClassProperties] {
        let properties : [GMLClassProperties] = [.nonatomic, .copy]
        return properties
    }
    
    func isCollectType(value: Any) -> Bool {
        if value is Array<Any>, value is Dictionary<String, Any> {
            return true
        }else {
            return false
        }
    }
}
