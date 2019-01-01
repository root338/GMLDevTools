//
//  GMLPropertiesSelectView.swift
//  GMLDevTools
//
//  Created by GML on 2018/12/9.
//  Copyright © 2018 apple. All rights reserved.
//

import Cocoa

class GMLPropertiesSelectView: NSView {
    
    var properties : [GMLClassProperties] = [
        .nullable,
        .nonatomic,
        .copy,
        .strong,
    ]
    
    var buttons = [GMLClassProperties : NSButton]()
    
    let scrollView = NSScrollView.init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupContentView() {
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = false
        if self.scrollView.superview == nil {
            self.addSubview(self.scrollView)
        }
        
        
    }
    
    func propertyButton(value: GMLClassProperties) -> NSButton {
        var btn = buttons[value]
        guard btn == nil else {
            return btn!
        }
        
        btn = NSButton.init(radioButtonWithTitle: value.rawValue, target: nil, action: nil)
        buttons[value] = btn
        return btn!
    }
    
    
}

private extension GMLPropertiesSelectView {
    
}
