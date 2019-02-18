//
//  LoginModal.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-13.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class LoginModal: NSView {
    
    // Outlets
    @IBOutlet weak var view : NSView!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var signInButton: NSButton!
    @IBOutlet weak var createAccountButton: NSButton!
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed("LoginModal", owner: self, topLevelObjects: nil)
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
        
        signInButton.layer?.backgroundColor = chatGreen.cgColor
        signInButton.layer?.cornerRadius = 7
        signInButton.styleButtonText(button: signInButton, buttonName: "Sign In", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 14.0)
        createAccountButton.styleButtonText(button: createAccountButton, buttonName: "Create Account", fontColor: chatGreen, alignment: .center, font: AVENIR_REGULAR, size: 12.0)
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        AuthService.instance.loginUser(email: emailTextField.stringValue, password: passwordTextField.stringValue) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
                        Swift.print(UserDataService.instance.name)
                        Swift.print(UserDataService.instance.avatarName)
                    }
                })
            }
        }
    }
    
    @IBAction func createAccountButtonClicked(_ sender: Any) {
        let closeImmediatelyDict: [String: Bool] = [USER_INFO_CLOSE_IMMEDIATELY: true]
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil, userInfo: closeImmediatelyDict)
        let createAccountDict: [String: ModalType] = [USER_INFO_MODAL: ModalType.createAccount]
        NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: createAccountDict)
    }
}
