//
//  NSAlert+GMLShowMessage.swift
//  GMLDevTools
//
//  Created by apple on 2018/12/2.
//  Copyright © 2018年 apple. All rights reserved.
//

import Cocoa

extension NSAlert {
    class func show(message: String, title: String = "提示") {
        
        let alert = NSAlert.init()
        alert.alertStyle = .warning
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "确定")
        alert.beginSheetModal(for: NSApplication.shared.keyWindow!) { (response) in
            
        }
    }
}
