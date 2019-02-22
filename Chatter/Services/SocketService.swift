//
//  SocketService.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-20.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()

    let manager: SocketManager
    let socket: SocketIOClient

    override init() {
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = manager.defaultSocket
        super.init()
    }

    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }

    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    
    
}
