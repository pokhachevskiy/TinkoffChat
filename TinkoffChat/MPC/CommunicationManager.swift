//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

class CommunicationManager: CommunicatorDelegate {
    
    var conversations: [String: [Conversation]] = [:]
    var conversationsListDelegate: MPCConversationsListDelegate?
    var conversationDelegate: MPCConversationDelegate?
    
    init() {
        conversations["online"] = [Conversation]()
    }
    
    func didFoundUser(userID: String, userName: String?) {
        guard conversations["online"]?.index(where: {(item) -> Bool in item.id == userID}) == nil else {
            return
        }
        
        conversations["online"]?.append(Conversation(id: userID, name: userName, message: nil, messages: [MessageModel](), date: nil, online: true, hasUnreadMessage: false))
        conversations["online"]?.sort(by: Conversation.sortByDate)
        
        conversationsListDelegate?.reloadData()
    }
    
    func didLostUser(userID: String) {
        if let indexOf = conversations["online"]?.index(where: {(item) -> Bool in item.id == userID}) {
            conversations["online"]?.remove(at: indexOf)
            
            conversationsListDelegate?.reloadData()
            conversationDelegate?.lockTheSendButton()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
        alertController.present(alertController, animated: true, completion: nil)
    }
    
    func failedtoStartAdvertising(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
        alertController.present(alertController, animated: true, completion: nil)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        guard var conversationsOnline = conversations["online"] else {
            return
        }
        if let indexOf = conversationsOnline.index(where: {(item) -> Bool in item.id == fromUser}) {
            conversationsOnline[indexOf].messages.insert(MessageModel(textMessage: text, isIncoming: true), at: 0)
            conversationsOnline[indexOf].hasUnreadMessage = true
            conversationsOnline[indexOf].message = conversationsOnline[indexOf].messages.first?.textMessage
            
            conversationsOnline.sort(by: Conversation.sortByDate)
            conversationsListDelegate?.reloadData()
            conversationDelegate?.reloadData()
        }
    }
    

    
}
