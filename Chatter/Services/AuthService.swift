//
//  AuthService.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-18.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowercasedEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowercasedEmail,
            "password": password
        ]
        
        Alamofire.request(REGISTER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowercasedEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowercasedEmail,
            "password": password
        ]
        
        Alamofire.request(LOGIN_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    let userEmail = json["user"].stringValue
                    let authToken = json["token"].stringValue
                    self.userEmail = userEmail
                    self.authToken = authToken
                    self.isLoggedIn = true
                    completion(true)
                } catch let error as NSError {
                    print(error)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func createUser(name: String, email: String, avatarColor: String, avatarName: String, completion: @escaping CompletionHandler) {
        
        let lowercasedEmail = email.lowercased()
        
        let header = [
            "Authorization": "Bearer \(authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "name": name,
            "email": lowercasedEmail,
            "avatarColor": avatarColor,
            "avatarName": avatarName
        ]
        
        Alamofire.request(ADD_USER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    let userId = json["_id"].stringValue
                    let avatarColor = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let userEmail = json["email"].stringValue
                    let userName = json["name"].stringValue
                    
                    UserDataService.instance.name = userName
                    UserDataService.instance.id = userId
                    UserDataService.instance.avatarColor = avatarColor
                    UserDataService.instance.avatarName = avatarName
                    UserDataService.instance.email = userEmail
                    
                    completion(true)
                } catch let error as NSError {
                    print(error)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}
