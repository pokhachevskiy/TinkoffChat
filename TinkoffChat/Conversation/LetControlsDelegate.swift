//
//  LetControlsDelegate.swift
//  TinkoffChat
//
//  Created by Daniil on 11/11/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

protocol LetControlsDelegate: class {
    var conversation: Conversation! {get set}

    func turnControlsOn()
    func turnControlsOff()
}
