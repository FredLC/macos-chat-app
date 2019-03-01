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
    
    // Variables
    let user = UserDataService.instance
    var channel: Channel?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear() {
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        SocketService.instance.getChatMessage { (newMessage) in
            if self.channel?.id == newMessage.channelId && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                self.tableView.scrollRowToVisible(MessageService.instance.messages.count - 1)
            }
        }
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
    
    func updateWithChannel(channel: Channel) {
        usersTypingLabel.stringValue = ""
        self.channel = channel
        let channelName = channel.channelTitle ?? ""
        let channelDesc = channel.channelDescription ?? ""
        channelTitle.stringValue = channelName
        channelDescription.stringValue = channelDesc
        getChats()
    }
    
    func getChats() {
        guard let channelId = channel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            self.tableView.reloadData()
            self.tableView.scrollRowToVisible(MessageService.instance.messages.count - 1)
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            channelTitle.stringValue = ""
            channelDescription.stringValue = ""
            self.usersTypingLabel.stringValue = ""
        } else {
            channelTitle.stringValue = "Please Log In"
            channelDescription.stringValue = ""
            self.usersTypingLabel.stringValue = ""
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = channel?.id else { return }
            SocketService.instance.addMessage(messageBody: messageTextField.stringValue, userId: user.id, channelId: channelId) { (success) in
                if success {
                    self.messageTextField.stringValue = ""
                }
            }
        } else {
            let loginDict: [String : ModalType] = [USER_INFO_MODAL : ModalType.login]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: loginDict)
        }
    }
}

extension ChatVC: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "chatCell"), owner: nil) as? ChatCell {
            let chat = MessageService.instance.messages[row]
            cell.configureCell(chat: chat)
            return cell
        }
        return NSTableCellView()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100.0
    }
}
