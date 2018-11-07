//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

class Conversation: ConversationCellConfiguration {
    var id: String
    var name: String?
    var message: String?
    var messages: [MessageModel]
    var date: Date?
    var online: Bool
    var hasUnreadMessage: Bool

    init(id: String,
         name: String?,
         message: String?,
         messages: [MessageModel],
         date: Date?,
         online: Bool,
         hasUnreadMessage: Bool) {
        self.id = id
        self.name = name
        self.message = message
        self.messages = messages
        self.date = date
        self.online = online
        self.hasUnreadMessage = hasUnreadMessage
    }

    class func sortByDate(conversationOne: Conversation, conversationTwo: Conversation) -> Bool {

        if let first = conversationOne.date, let second = conversationTwo.date {
            return first > second
        } else if conversationOne.date != conversationTwo.date &&
            (conversationOne.date == nil || conversationTwo.date == nil) {
            return conversationOne.date ?? Date.distantPast > conversationTwo.date ?? Date.distantPast
        } else if let firstName = conversationOne.name, let secondName = conversationTwo.name {
            // + name sort implementation
            if conversationOne.date == nil ||
                conversationTwo.date == nil {
                return firstName < secondName
            }
        }

        return true
    }

}
