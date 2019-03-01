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
    
    func getChatMessage(_ completionHandler: @escaping (_ newMessage: Message) -> Void) {
        socket.on("messageCreated") { (dataArray, socketAck) in
            guard let messageBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let username = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timestamp = dataArray[7] as? String else { return }
            
            let newMessage = Message.init(message: messageBody, userName: username, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timestamp)
            
            completionHandler(newMessage)
        }
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, socketAck) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) in
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
    }
    
}
