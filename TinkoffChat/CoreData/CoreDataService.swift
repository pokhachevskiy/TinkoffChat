//
//  CoreDataService.swift
//  TinkoffChat
//
//  Created by Daniil on 09/11/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    private init() {}

    var coreDataStack = CoreDataStack()
    static let sharedService = CoreDataService()

    enum EntityType: String {
        case user = "User"
        case message = "Message"
        case conversation = "Conversation"
    }

    enum FetchRequestType: String {
        case userById = "UserById"
        case usersOnline = "UsersOnline"
        case conversationWithId = "ConverationWithId"
        case messagesByConversation = "MessagesByConversationId"
    }

    enum SortDescriptorType: String {
        case userId
        case messageId
        case conversationId
    }

    func add<T>(_ entity: EntityType) -> T where T: NSManagedObject {
        if let insertEntity = NSEntityDescription.insertNewObject(forEntityName: entity.rawValue,
                                                                  into: coreDataStack.saveContext) as? T {
            return insertEntity
        }
        return T()
    }

    func delete<T>(_ element: T) where T: NSManagedObject {
        coreDataStack.saveContext.delete(element)
    }

    func fetch<T>(_ request: NSFetchRequest<T>) -> [T]? where T: NSManagedObject {
        return try? coreDataStack.saveContext.fetch(request)
    }

    func getAll<T>(_ entity: EntityType) -> NSFetchRequest<T> where T: NSManagedObject {
        return NSFetchRequest<T>(entityName: entity.rawValue)
    }

    func save() {
        coreDataStack.performSave(with: coreDataStack.saveContext)
    }

    func setupFRC<T>(_ fetchRequest: NSFetchRequest<T>, frcManager: FRCManager,
                     sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<T> where T: NSManagedObject {
        let fetchedResultsController = NSFetchedResultsController<T>(fetchRequest: fetchRequest,
                                                                     managedObjectContext: coreDataStack.saveContext,
                                                                     sectionNameKeyPath: sectionNameKeyPath,
                                                                     cacheName: nil)
        fetchedResultsController.delegate = frcManager

        return fetchedResultsController
    }

    func fetchData<T>(_ fetchedResultController: NSFetchedResultsController<T>) where T: NSManagedObject {
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Error performing fetch")
        }
    }

    func fetchRequest<T>(_ fetchRequest: FetchRequestType,
                         dictionary: [String: Any]? = nil) -> NSFetchRequest<T>? where T: NSManagedObject {
        let request: NSFetchRequest<T>?

        if dictionary == nil {
            request = coreDataStack.managedObjectModel.fetchRequestTemplate(forName: fetchRequest.rawValue)
                as? NSFetchRequest<T>
        } else {
            request = coreDataStack
                .managedObjectModel
                .fetchRequestFromTemplate(withName: fetchRequest.rawValue,
                                          substitutionVariables: dictionary!) as? NSFetchRequest<T>
        }

        guard request != nil else {
            assert(false, "No template with name \(fetchRequest.rawValue)")
            return nil
        }

        return request
    }

}
