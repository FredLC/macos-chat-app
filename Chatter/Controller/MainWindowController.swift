//
//  MainWindowController.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-12.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.minSize = NSMakeSize(950, 600)
        window?.delegate = self
    }
    
    func windowDidMiniaturize(_ notification: Notification) {
        UserDataService.instance.isMinimizing = true
    }
    
    func windowDidDeminiaturize(_ notification: Notification) {
        UserDataService.instance.isMinimizing = false
    }

}
