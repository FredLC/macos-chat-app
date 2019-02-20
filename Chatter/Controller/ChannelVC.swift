//
//  ChannelVC.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-12.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class ChannelVC: NSViewController {
    
    // Outlets
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var addChannelButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    func setupView() {
        view.wantsLayer = true
        view.layer?.backgroundColor = chatPurple.cgColor
        addChannelButton.styleButtonText(button: addChannelButton, buttonName: "Add +", fontColor: .controlColor, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            usernameLabel.stringValue = UserDataService.instance.name
        } else {
            usernameLabel.stringValue = ""
        }
    }
    
    
    @IBAction func addChannelButtonClicked(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            // add channel
        } else {
            let loginDict: [String : ModalType] = [USER_INFO_MODAL : ModalType.login]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: loginDict)
        }
    }
    
}
