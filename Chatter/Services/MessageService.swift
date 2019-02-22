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
}
