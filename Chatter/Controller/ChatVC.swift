//
//  ChatVC.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-12.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class ChatVC: NSViewController, NSTextFieldDelegate {
    
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
    var isTyping = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        print(MessageService.instance.channels.count)
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
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = self.channel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != self.user.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.usersTypingLabel.stringValue = "\(names) \(verb) typing a message..."
            } else {
                self.usersTypingLabel.stringValue = ""
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
    
    func controlTextDidChange(_ obj: Notification) {
        guard let channelId = channel?.id else { return }
        if messageTextField.stringValue == "" {
            isTyping = false
            SocketService.instance.socket.emit("stopType", user.name, channelId)
        } else {
            if isTyping == false {
                SocketService.instance.socket.emit("startType", user.name, channelId)
            }
            isTyping = true
        }
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
            if MessageService.instance.channels.count == 0 {
                channelTitle.stringValue = "Create channel and get chatting!"
            }
        } else {
            channelTitle.stringValue = "Please Log In"
            channelDescription.stringValue = ""
            self.usersTypingLabel.stringValue = ""
            self.tableView.reloadData()
        }
    }
    @IBAction func messageEnterSend(_ sender: Any) {
        sendButton.performClick(nil)
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = channel?.id else { return }
            SocketService.instance.addMessage(messageBody: messageTextField.stringValue, userId: user.id, channelId: channelId) { (success) in
                if success {
                    self.messageTextField.stringValue = ""
                    SocketService.instance.socket.emit("stopType", self.user.name, channelId)
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
