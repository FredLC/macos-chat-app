//
//  ProfileModal.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-20.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class ProfileModal: NSView {

    // Outlets
    @IBOutlet weak var view : NSView!
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var profileImage: NSImageView!
    @IBOutlet weak var logoutButton: NSButton!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed("ProfileModal", owner: self, topLevelObjects: nil)
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
        
        profileImage.layer?.cornerRadius = 10
        profileImage.layer?.borderColor = NSColor.gray.cgColor
        profileImage.layer?.borderWidth = 3
        profileImage.image = NSImage(named: UserDataService.instance.avatarName)
        profileImage.layer?.backgroundColor = UserDataService.instance.returnCGColor(components: UserDataService.instance.avatarColor)
        
        usernameTextField.stringValue = UserDataService.instance.name
        emailTextField.stringValue = UserDataService.instance.email
        
        logoutButton.layer?.backgroundColor = chatGreen.cgColor
        logoutButton.layer?.cornerRadius = 7
        logoutButton.styleButtonText(button: logoutButton, buttonName: "Logout", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
}
