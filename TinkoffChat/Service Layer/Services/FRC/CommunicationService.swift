//
//  CommunicationService.swift
//  TinkoffChat
//
//  Created by Даниил on 18.11.2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

protocol ICommunicatorDelegate: class {
    var communicator: ICommunicator { get }
    var connectionTracker: IUserConnectionTracker? { get set }

    // discovery
    func didFindUser(id: String, name: String)
    func didLoseUser(id: String)

    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)

    // message
    func didReceiveMessage(text: String, from user: String)
    func didSendMessage(text: String, to user: String)

    // conversation
    func didConversationRead(id: String)
}

protocol IUserConnectionTracker {
    func changeControlsState(enabled: Bool)
}

class CommunicationService: ICommunicatorDelegate {
    var communicator: ICommunicator
    private let dataManager: IDataManager
    var connectionTracker: IUserConnectionTracker?

    init(dataManager: IDataManager, communicator: ICommunicator) {
        self.dataManager = dataManager
        self.communicator = communicator

        communicator.delegate = self
    }

    func didFindUser(id: String, name: String) {
        connectionTracker?.changeControlsState(enabled: true)
        dataManager.appendConversation(id: id, userName: name)
    }

    func didLoseUser(id: String) {
        connectionTracker?.changeControlsState(enabled: false)
        dataManager.makeConversationOffline(id: id)
    }

    func didSendMessage(text: String, to user: String) {
        dataManager.appendMessage(text: text, conversationId: user, isIncoming: false)
    }

    func didReceiveMessage(text: String, from user: String) {
        dataManager.appendMessage(text: text, conversationId: user, isIncoming: true)
    }

    func didConversationRead(id: String) {
        dataManager.readConversation(id: id)
    }

    func failedToStartBrowsingForUsers(error: Error) {
        print("Failed To Start Browsing For Users:", error.localizedDescription)
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
        alertController.present(alertController, animated: true, completion: nil)
    }

    func failedToStartAdvertising(error: Error) {
        print("Failed To Start Advertising:", error.localizedDescription)
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
        alertController.present(alertController, animated: true, completion: nil)
    }
}
