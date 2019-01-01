//
//  GMLJSONVC.swift
//  GMLDevTools
//
//  Created by GML on 2018/12/8.
//  Copyright © 2018 apple. All rights reserved.
//

import Cocoa

class GMLJSONVC: NSViewController {
    
    
    @IBOutlet var JSONTextView: NSTextView!
    
    @IBOutlet weak var nullable: NSButton!
    @IBOutlet weak var strong: NSButton!
    @IBOutlet weak var assign: NSButton!
    @IBOutlet weak var copyButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
