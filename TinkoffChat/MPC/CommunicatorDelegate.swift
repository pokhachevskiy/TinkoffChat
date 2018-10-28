//
//  CommunicatorDelegate.swift
//  TinkoffChat
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

protocol CommunicatorDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    func failedToStartBrowsingForUsers(error : Error)
    func failedtoStartAdvertising(error: Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}
