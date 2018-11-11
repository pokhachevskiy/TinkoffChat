//
//  MessageModel.swift
//  TinkoffChat
//
//  Created by Daniil on 28/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
extension Message: MessageCellConfiguration {
    class func generateMessageId() -> String {
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
            .data(using: .utf8)!
            .base64EncodedString()
    }
}
