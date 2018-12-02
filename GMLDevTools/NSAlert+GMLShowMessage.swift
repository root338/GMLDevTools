//
//  NSAlert+GMLShowMessage.swift
//  GMLDevTools
//
//  Created by apple on 2018/12/2.
//  Copyright © 2018年 apple. All rights reserved.
//

import Cocoa

extension NSAlert {
    class func showMessage(_ msg: String) {
        let alert = NSAlert.init()
        alert.messageText = msg
        
        alert.addButton(withTitle: "确定")
        
    }
}
