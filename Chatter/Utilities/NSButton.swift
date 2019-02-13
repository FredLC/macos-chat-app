//
//  NSButton.swift
//  Weathered
//
//  Created by Fred Lefevre on 2019-02-11.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

extension NSButton {
    
    func styleButtonText(button: NSButton, buttonName: String, fontColor: NSColor, alignment: NSTextAlignment, font: String, size: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        button.attributedTitle = NSAttributedString(string: buttonName, attributes: [NSAttributedString.Key.foregroundColor: fontColor, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: NSFont(name: font, size: size)!])
    }
}
