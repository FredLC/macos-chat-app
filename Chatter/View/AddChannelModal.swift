//
//  AddChannelModal.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-22.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class AddChannelModal: NSView {

    // Outlets
    @IBOutlet weak var view : NSView!
    @IBOutlet weak var channelNameTextField: NSTextField!
    @IBOutlet weak var channelDescriptionTextField: NSTextField!
    @IBOutlet weak var createChannelButton: NSButton!
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed("AddChannelModal", owner: self, topLevelObjects: nil)
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
        
        createChannelButton.layer?.backgroundColor = chatGreen.cgColor
        createChannelButton.layer?.cornerRadius = 7
        createChannelButton.styleButtonText(button: createChannelButton, buttonName: "Create Channel", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 14.0)
    }
    
    @IBAction func descriptionSent(_ sender: Any) {
        createChannelButton.performClick(nil)
    }
    
    @IBAction func createChannelButtonClicked(_ sender: Any) {
        SocketService.instance.addChannel(channelName: channelNameTextField.stringValue, channelDescription: channelDescriptionTextField.stringValue) { (success) in
            if success {
                NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
            }
        }
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
}
