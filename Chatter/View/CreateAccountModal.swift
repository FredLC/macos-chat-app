//
//  CreateAccountModal.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-17.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class CreateAccountModal: NSView {

    // Outlets
    @IBOutlet weak var view : NSView!
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed("CreateAccountModal", owner: self, topLevelObjects: nil)
        self.addSubview(self.view)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        setupView()
    }
    
    func setupView() {
        self.view.frame = NSRect(x: 0, y: 0, width: 475, height: 300)
        view.layer?.backgroundColor = CGColor.white
        view.layer?.cornerRadius = 7
    }
    
}
