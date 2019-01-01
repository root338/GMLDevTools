//
//  GMLJSONText.swift
//  GMLDevTools
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018 apple. All rights reserved.
//

import Cocoa

/// 处理JSON时的错误
///
/// - encoding: 输入字符串的编码错误
/// - toJSONFaild: 数据转OC对象时错误
/// - irregularData: 内部数据格式错误，比如数组中包含多种数据类型
/// - keyMustIsString: 字典的key必须为 String 类型
enum GMLJSONTextError: Error {
    case encoding
    case toJSONFaild
    case irregularData
    case keyMustIsString
}

class GMLJSONText: NSObject {
    
    let originText : String
    let encoding : String.Encoding
    let jsonObj : Any
    
    init(text: String, encoding: String.Encoding = .utf8) throws {
        
        guard let data = text.data(using: encoding) else {
            throw GMLJSONTextError.encoding
        }
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            self.jsonObj = jsonObj
        }catch {
            throw GMLJSONTextError.toJSONFaild
        }
        self.originText = text
        self.encoding = encoding
        
        super.init()
    }
}

//MARK:- 对外接口
extension GMLJSONText {
    func propertiesText() {
        guard let result = try? analysis(value: jsonObj, level: 0) else {
            print("出错啦")
            return
        }
        
        guard let resultItem = result else {
            return
        }
        
        for item in resultItem {
            if let propertyStr = item.propertyString {
                print(propertyStr)
            }
        }
    }
}

//MARK:- Private Method
fileprivate extension GMLJSONText {
    
    /// 传入数据是否可以继续向下解析
    ///
    /// - Parameters:
    ///   - value: 判断的数据
    ///   - level: 数据在原始数据的等级
    /// - Returns: 返回是否可以向下解析
    /// - Throws: GMLJSONTextError 错误
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
    /// 查看数组是否是同一类型数据
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
    
    func analysis(value: Any, level: Int) throws -> [GMLPropertyItem]? {
        guard try shouldDownAnalysis(value: value, level: level) else {
            return nil
        }
        
        var resultItems = [GMLPropertyItem]()
        if let dict = value as? NSDictionary {
            
            for (key, value) in dict {
                guard let paramKey = key as? String else {
                    throw GMLJSONTextError.keyMustIsString
                }
                var item = createItem(name: paramKey, value: value, level: level)
                
                resultItems.append(item)
                guard let subitem = try analysis(value: value, level: level + 1) else {
                    continue
                }
                item.addSubitem(subitem)
            }
            
        }else if let array = value as? NSArray, let firstObj = array.firstObject {
            var item = createItem(name: nil, value: firstObj, level: level)
            if let subitem = try analysis(value: firstObj, level: level + 1) {
                item.addSubitem(subitem)
            }
            resultItems.append(item)
        }
        return resultItems.count > 0 ? resultItems : nil
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
