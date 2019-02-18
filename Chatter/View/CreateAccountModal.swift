//
//  CreateAccountModal.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-17.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class CreateAccountModal: NSView {

    // Outlets
    @IBOutlet weak var view : NSView!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var createAccountButton: NSButton!
    @IBOutlet weak var chooseImageButton: NSButton!
    @IBOutlet weak var profileImage: NSImageView!
    @IBOutlet weak var progressSpinner: NSProgressIndicator!
    @IBOutlet weak var stackView: NSStackView!
    
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed("CreateAccountModal", owner: self, topLevelObjects: nil)
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
        
        createAccountButton.layer?.backgroundColor = chatGreen.cgColor
        createAccountButton.layer?.cornerRadius = 7
        chooseImageButton.layer?.backgroundColor = chatGreen.cgColor
        chooseImageButton.layer?.cornerRadius = 7
        
        createAccountButton.styleButtonText(button: createAccountButton, buttonName: "Create Account", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
        chooseImageButton.styleButtonText(button: chooseImageButton, buttonName: "Choose Avatar", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
        
        nameTextField.focusRingType = .none
        emailTextField.focusRingType = .none
        passwordTextField.focusRingType = .none
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
    @IBAction func createAccountButtonClicked(_ sender: Any) {
        AuthService.instance.registerUser(email: emailTextField.stringValue, password: passwordTextField.stringValue) { (success) in
            if success {
                AuthService.instance.loginUser(email: self.emailTextField.stringValue, password: self.passwordTextField.stringValue, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: self.nameTextField.stringValue, email: self.emailTextField.stringValue, avatarColor: "", avatarName: "dark5", completion: { (success) in
                            NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func chooseImageButtonClicked(_ sender: Any) {
    }
    
}
