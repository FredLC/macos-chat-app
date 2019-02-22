//
//  AppDelegate.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-12.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        SocketService.instance.establishConnection()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        SocketService.instance.closeConnection()
    }


}

