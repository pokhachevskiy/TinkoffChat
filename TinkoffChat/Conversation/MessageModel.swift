//
//  MessageModel.swift
//  TinkoffChat
//
//  Created by Daniil on 28/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
class MessageModel: MessageCellConfiguration {
    var textMessage: String?
    var isIncoming: Bool

    init(textMessage: String, isIncoming: Bool) {
        self.textMessage = textMessage
        self.isIncoming = isIncoming
    }
}
