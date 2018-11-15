//
//  User.swift
//  TinkoffChat
//
//  Created by Daniil on 11/11/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
import CoreData

extension User {
    @nonobjc class func withId(userId: String) -> User? {
        guard let fetchRequest: NSFetchRequest<User>
            = CoreDataService
                .sharedService
                .fetchRequest(.userById, dictionary: ["userId": userId]) else {
            return nil
        }

        return CoreDataService.sharedService.fetch(fetchRequest)?.first
    }
}
