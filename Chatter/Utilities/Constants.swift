//
//  Constants.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-12.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

typealias CompletionHandler = (_ Success: Bool) -> ()

// URLS
let BASE_URL = "https://polar-peak-62345.herokuapp.com/v1/"
let REGISTER_URL = "\(BASE_URL)account/register"
let LOGIN_URL = "\(BASE_URL)account/login"
let ADD_USER_URL = "\(BASE_URL)user/add"
let GET_USER_BY_EMAIL_URL = "\(BASE_URL)user/byEmail/"

// Colors
let chatPurple = NSColor(calibratedRed: 0.30, green: 0.22, blue: 0.29, alpha: 1.00)
let chatGreen = NSColor(calibratedRed: 0.22, green: 0.66, blue: 0.68, alpha: 1.00)

// Fonts
let AVENIR_REGULAR = "AvenirNext-Regular"
let AVENIR_BOLD = "AvenirNext-Bold"

// Notifications
let USER_INFO_MODAL = "userInfoModal"
let USER_INFO_CLOSE_IMMEDIATELY = "closeImmediately"
let NOTIF_PRESENT_MODAL = Notification.Name("presentModal")
let NOTIF_CLOSE_MODAL = Notification.Name("closeModal")

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]
