//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

class CommunicationManager: CommunicatorDelegate {

    func didFoundUser(userID: String, userName: String?) {
        let conversation = Conversation.withId(conversationId: userID)
        guard conversation == nil else {
            conversation?.isOnline = true
            CoreDataService.sharedService.save()
            return
        }

        let user: User = CoreDataService.sharedService.add(.user)
        user.userId = userID
        user.name = userName
        user.isOnline = true

        let chat: Conversation = CoreDataService.sharedService.add(.conversation)

        chat.conversationId = userID
        chat.receiver = user
        chat.hasUnreadMessage = false
        chat.appUser = nil
        chat.lastMessage = nil
        chat.isOnline = true

        user.addToConversations(chat)

        CoreDataService.sharedService.save()
    }

    func didLostUser(userID: String) {
        guard let user = User.withId(userId: userID),
            let conversation = Conversation.withId(conversationId: userID) else {
            return
        }
        if conversation.lastMessage != nil {
            conversation.isOnline = false
        } else {
            CoreDataService.sharedService.delete(conversation)
            CoreDataService.sharedService.delete(user)
        }
    }

    func failedToStartBrowsingForUsers(error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
        alertController.present(alertController, animated: true, completion: nil)
    }

    func failedtoStartAdvertising(error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
        alertController.present(alertController, animated: true, completion: nil)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        guard let conversation = Conversation.withId(conversationId: fromUser) else {
            return
        }
        print(fromUser)

        let message: Message = CoreDataService.sharedService.add(.message)
        message.messageId = Message.generateMessageId()
        message.isIncoming = true
        message.textMessage = text
        message.date = Date()
        message.conversation = conversation
        message.lastMessage = conversation

        conversation.hasUnreadMessage = true

        CoreDataService.sharedService.save()
    }

}
