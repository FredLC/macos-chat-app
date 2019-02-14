//
//  ToolbarVC.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-12.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

enum ModalType {
    case login
}

class ToolbarVC: NSViewController {
    
    // Outlets
    @IBOutlet weak var loginImage: NSImageView!
    @IBOutlet weak var loginLabel: NSTextField!
    @IBOutlet weak var loginStackView: NSStackView!
    
    // Variables
    var modalBackgroundView: ClickBlockingView!
    var modalView: NSView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        setupView()
    }
    
    func setupView() {
        NotificationCenter.default.addObserver(self, selector: #selector(ToolbarVC.presentModal(_:)), name: NOTIF_PRESENT_MODAL, object: nil)
        view.wantsLayer = true
        view.layer?.backgroundColor = chatGreen.cgColor
        loginStackView.gestureRecognizers.removeAll()
        let loginPage = NSClickGestureRecognizer(target: self, action: #selector(ToolbarVC.openProfilePage(_:)))
        loginStackView.addGestureRecognizer(loginPage)
    }
    
    @objc func openProfilePage(_ recognizer: NSClickGestureRecognizer) {
        let loginDict: [String : ModalType] = [USER_INFO_MODAL : ModalType.login]
        NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: loginDict)
    }
    
    @objc func presentModal(_ notif: Notification) {
        var modalWidth = CGFloat(0.0)
        var modalHeight = CGFloat(0.0)
        
        if modalBackgroundView == nil {
            modalBackgroundView = ClickBlockingView()
            modalBackgroundView.wantsLayer = true
            modalBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(modalBackgroundView, positioned: .above, relativeTo: loginStackView)
            let topConstraint = NSLayoutConstraint(item: modalBackgroundView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50)
            let rightConstraint = NSLayoutConstraint(item: modalBackgroundView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: modalBackgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            let leftConstraint = NSLayoutConstraint(item: modalBackgroundView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
            view.addConstraints([topConstraint, rightConstraint, bottomConstraint, leftConstraint])
            modalBackgroundView.layer?.backgroundColor = CGColor.black
            modalBackgroundView.alphaValue = 0.0
            
            let closeBackgroundClick = NSClickGestureRecognizer(target: self, action: #selector(ToolbarVC.closeModalClick(_:)))
            modalBackgroundView.addGestureRecognizer(closeBackgroundClick)
            
            // Instantiate Xibs
            guard let modalType = notif.userInfo?[USER_INFO_MODAL] as? ModalType else { return }
            
            switch modalType {
            case ModalType.login:
                modalView = LoginModal()
                modalWidth = 475
                modalHeight = 300
            }
            
            modalView.wantsLayer = true
            modalView.translatesAutoresizingMaskIntoConstraints = false
            modalView.alphaValue = 0.0
            modalBackgroundView.addSubview(modalView)
            
            let horizontalConstraint = modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            let verticalConstraint = modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            let widthConstraint = modalView.widthAnchor.constraint(equalToConstant: modalWidth)
            let heightConstraint = modalView.heightAnchor.constraint(equalToConstant: modalHeight)
            
            NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        }
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.5
            self.modalBackgroundView.animator().alphaValue = 0.6
            self.modalView.animator().alphaValue = 1.0
            self.view.layoutSubtreeIfNeeded()
        }, completionHandler: nil)
    }
    
    @objc func closeModalClick(_ recognizer: NSClickGestureRecognizer) {
        closeModal()
    }
    
    func closeModal() {
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.5
            self.modalBackgroundView.animator().alphaValue = 0.0
            self.view.layoutSubtreeIfNeeded()
        }, completionHandler: {
            if self.modalBackgroundView != nil {
                self.modalBackgroundView.removeFromSuperview()
                self.modalBackgroundView = nil
            }
            self.modalView.removeFromSuperview()
            self.modalView.alphaValue = 0.0
        })
    }
    
}
