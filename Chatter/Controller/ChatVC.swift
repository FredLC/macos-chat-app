//
//  ChatVC.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-12.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class ChatVC: NSViewController {
    
    // Outlets
    @IBOutlet weak var channelTitle: NSTextField!
    @IBOutlet weak var channelDescription: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var usersTypingLabel: NSTextField!
    @IBOutlet weak var messageBoxOutline: NSView!
    @IBOutlet weak var messageTextField: NSTextField!
    @IBOutlet weak var sendButton: NSButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    func setupView() {
        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor.white
        
        messageBoxOutline.wantsLayer = true
        messageBoxOutline.layer?.backgroundColor = CGColor.white
        messageBoxOutline.layer?.borderColor = NSColor.controlShadowColor.cgColor
        messageBoxOutline.layer?.borderWidth = 2
        messageBoxOutline.layer?.cornerRadius = 5
        
        sendButton.styleButtonText(button: sendButton, buttonName: "Send", fontColor: .darkGray, alignment: .center, font: AVENIR_BOLD, size: 13.0)
        
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            channelTitle.stringValue = "#general"
            channelDescription.stringValue = "This is where we chatsss"
        } else {
            channelTitle.stringValue = "Please Log In"
            channelDescription.stringValue = ""
        }
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            // send message
        } else {
            let loginDict: [String : ModalType] = [USER_INFO_MODAL : ModalType.login]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: loginDict)
        }
    }
}
