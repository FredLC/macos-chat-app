//
//  UserDataService.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-18.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    fileprivate var _id = ""
    fileprivate var _avatarColor = ""
    fileprivate var _avatarName = ""
    fileprivate var _email = ""
    fileprivate var _name = ""
    
    var id: String {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var avatarColor: String {
        get {
            return _avatarColor
        }
        set {
            _avatarColor = newValue
        }
    }
    
    var avatarName: String {
        get {
            return _avatarName
        }
        set {
            _avatarName = newValue
        }
    }
    
    var email: String {
        get {
            return _email
        }
        set {
            _email = newValue
        }
    }
    
    var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    
    func returnCGColor(components: String) -> CGColor {
        // [0.9623754620552063, 0.5031990081896194, 0.11460058069573613, 1.0]
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = CGColor(red: 0.69, green: 0.85, blue: 0.99, alpha: 1.0)
        
        guard let rUnwrapped = r else { return defaultColor }
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let aUnwrapped = a else { return defaultColor }
        
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        let newCGColor = CGColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        return newCGColor
    }
    
    func logoutUser() {
        _id = ""
        _name = ""
        _email = ""
        _avatarName = ""
        _avatarColor = ""
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
        AuthService.instance.isLoggedIn = false
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
}
