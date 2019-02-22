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
    
    func configureCell(channel: Channel) {
        let title = channel.channelTitle ?? ""
        channelName.stringValue = "#\(title)"
    }
    
}
