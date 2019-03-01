//
//  SplitView.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-03-01.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class SplitView: NSSplitView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override var dividerThickness: CGFloat {
        get { return 0.0 }
    }
}
