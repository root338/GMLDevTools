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
        guard text.count > 0 else {
            NSAlert.show(message: "内容不能为空")
            return
        }
        do {
            let jsonText = try GMLJSONText.init(text: text)
            jsonText.propertiesText()
        } catch {
            NSAlert.show(message: "创建解析类失败，请检查JSON数据是否正确")
        }
        
        
    }
}

