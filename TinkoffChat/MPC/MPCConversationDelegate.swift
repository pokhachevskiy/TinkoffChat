//
//  MPCConversationDelegate.swift
//  TinkoffChat
//
//  Created by Даниил on 03/11/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

protocol MPCConversationDelegate {
    func reloadData()
    func lockTheSendButton()
}