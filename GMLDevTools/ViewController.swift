//
//  ViewController.swift
//  GMLDevTools
//
//  Created by apple on 2018/12/2.
//  Copyright © 2018年 apple. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet var resultTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.isAutomaticQuoteSubstitutionEnabled = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func handleToPropertyAction(_ sender: Any) {
        
        let text = textView.attributedString().string
        guard let data = text.data(using: .utf8) else {
            return
        }
        
        do {
            var obj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            print(obj)
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func handleInputContent(_ inputContent: Any, level: Int) -> GMLPropertyItem {
        
        assert(isCollectType(value: inputContent), "不是一个可解析类型")
        
        let classTypeValue = classType(value: inputContent)
        let includePropertiesValue = properties()
        let name : String
        
        if let dict = inputContent as? [String : Any] {
            for (key, value) in dict {
                var item = createItem(name: key, value: value, level: level)
                item.addSubitem(handleInputContent(value, level: level - 1))
            }
        }else if let array = inputContent as? [Any] {
            for obj in array {
                var item = createItem(name: <#T##String#>, value: <#T##Any#>, level: <#T##Int#>)
                
            }
        }
        
        return items
    }
    
    func createItem(name: String, value: Any, level: Int) -> GMLPropertyItem {
        
        let item = GMLPropertyItem.init(level: level, classType: classType(value: value), includeProperties: properties(), name: name, subItem: nil)
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

