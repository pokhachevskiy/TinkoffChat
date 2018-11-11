//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Даниил on 03/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
    @nonobjc class func withId (conversationId: String) -> Conversation? {
        guard let fetchRequest: NSFetchRequest<Conversation> = CoreDataService.sharedService.fetchRequest(
            .conversationWithId,
            dictionary: ["conversationId": conversationId]) else {
            return nil
        }

        let onlineSortDescriptor = NSSortDescriptor(key: "isOnline", ascending: false)
        let dateSortDescriptor = NSSortDescriptor(key: "lastMessage.date", ascending: false)
        let nameSortDescriptor = NSSortDescriptor(key: "receiver.name", ascending: true)
        fetchRequest.sortDescriptors = [onlineSortDescriptor, dateSortDescriptor, nameSortDescriptor]

        return CoreDataService.sharedService.fetch(fetchRequest)?.first
    }
}
