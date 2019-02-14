//
//  ClickBlockingView.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-13.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class ClickBlockingView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func mouseUp(with event: NSEvent) {}
    override func mouseDown(with event: NSEvent) {}
    override func mouseMoved(with event: NSEvent) {}
    override func mouseDragged(with event: NSEvent) {}
    
}
