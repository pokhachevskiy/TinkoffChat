//
//  CommunicatorProtocol.swift
//  TinkoffChat
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler : ((_ success : Bool, _  error: Error?) -> ())?)
    var delegate : CommunicatorDelegate? {get set}
    var online : Bool {get set}
}
