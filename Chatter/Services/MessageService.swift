//
//  MessageService.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-22.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        
        Alamofire.request(GET_CHANNELS_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let channelTitle = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let channelId = item["_id"].stringValue
                            let channel = Channel(channelTitle: channelTitle, channelDescription: channelDescription, id: channelId)
                            self.channels.append(channel)
                        }
                        completion(true)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(GET_MESSAGES_URL)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let id = item["_id"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                            self.messages.append(message)
                        }
                        completion(true)
                    }
                } catch let error as NSError {
                    print(error)
                }
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
}
