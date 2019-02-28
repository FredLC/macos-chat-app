//
//  ChatCell.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-28.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class ChatCell: NSTableCellView {

    @IBOutlet weak var profileImage: NSImageView!
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var timestampLabel: NSTextField!
    @IBOutlet weak var messageBodyLabel: NSTextField!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        profileImage.layer?.cornerRadius = 6
        profileImage.layer?.borderColor = NSColor.gray.cgColor
        profileImage.layer?.borderWidth = 2
    }
    
    func configureCell(chat: Message) {
        usernameLabel.stringValue = chat.userName
        timestampLabel.stringValue = chat.timeStamp
        messageBodyLabel.stringValue = chat.message
        profileImage.wantsLayer = true
        profileImage.image = NSImage(named: chat.userAvatar)
        profileImage.layer?.backgroundColor = UserDataService.instance.returnCGColor(components: chat.userAvatarColor)
    }
}
