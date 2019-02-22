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
        tableView.delegate = self
        tableView.dataSource = self
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
            getChannels()
        } else {
            usernameLabel.stringValue = ""
        }
    }
    
    func getChannels() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addChannelButtonClicked(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannelDict: [String: ModalType] = [USER_INFO_MODAL: ModalType.addChannel]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: addChannelDict)
        } else {
            let loginDict: [String : ModalType] = [USER_INFO_MODAL : ModalType.login]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: loginDict)
        }
    }
    
}

extension ChannelVC: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let channel = MessageService.instance.channels[row]
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "channelCell"), owner: nil) as? ChannelCell {
            cell.configureCell(channel: channel)
            return cell
        }
        return NSTableCellView()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30.0
    }
}
