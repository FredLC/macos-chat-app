//
//  ChannelCell.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-22.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class ChannelCell: NSTableCellView {

    @IBOutlet weak var channelName: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func configureCell(channel: Channel, selectedChannel: Int, row: Int) {
        let title = channel.channelTitle ?? ""
        channelName.stringValue = "#\(title)"
        channelName.font = NSFont(name: AVENIR_REGULAR, size: 13.0)
        
        for id in MessageService.instance.unreadChannels {
            if id == channel.id {
                channelName.font = NSFont(name: AVENIR_BOLD, size: 13.0)
            }
        }
        
        wantsLayer = true
        if row == selectedChannel {
            layer?.backgroundColor = chatGreen.cgColor
            channelName.textColor = NSColor.white
        } else {
            layer?.backgroundColor = CGColor.clear
            channelName.textColor = NSColor.controlColor
        }
    }
    
}
