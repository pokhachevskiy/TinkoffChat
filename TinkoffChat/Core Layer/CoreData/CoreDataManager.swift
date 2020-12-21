//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Даниил on 18.11.2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import CoreData
import Foundation
import UIKit

protocol IDataManager: AnyObject {
    func appendMessage(text: String, conversationId: String, isIncoming: Bool)
    func appendConversation(id: String, userName: String)
    func makeConversationOffline(id: String)
    func readConversation(id: String)
    func loadAppUser(completion: @escaping (IAppUser?) -> Void)
    func saveAppUser(_ profile: IAppUser, completion: @escaping (Bool) -> Void)
}

protocol ICoreDataStack: AnyObject {
    var saveContext: NSManagedObjectContext { get }
    func fetchRequest<T>(_ fetchRequestName: String,
                         substitutionDictionary: [String: Any]?,
                         sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<T>? where T: NSManagedObject
}

class CoreDataManager: IDataManager, ICoreDataStack {
    private let stack: CoreDataStack

    init() {
        stack = CoreDataStack()
    }

    var saveContext: NSManagedObjectContext {
        return stack.saveContext
    }

    // MARK: - IDataManager

    func loadAppUser(completion: @escaping (IAppUser?) -> Void) {
        guard let appUser: AppUser = findOrInsert(entityName: "AppUser") else {
            completion(nil)
            return
        }

        let profile = Profile()
        profile.name = appUser.name
        profile.about = appUser.about
        if let picture = appUser.picture {
            profile.picture = UIImage(data: picture)
        }

        completion(profile)
    }

    func saveAppUser(_ profile: IAppUser, completion: @escaping (Bool) -> Void) {
        let appUser: AppUser? = findOrInsert(entityName: "AppUser")
        appUser?.name = profile.name
        appUser?.about = profile.about

        if let picture = profile.picture {
            appUser?.picture = picture.jpegData(compressionQuality: 100)
        }

        stack.performSave(context: stack.saveContext) { error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func readConversation(id: String) {
        guard let conversation: Conversation = withId(id, requestName: "ConversationWithId")
        else { return }

        conversation.hasUnreadMessages = false
        performSave()
    }

    func appendConversation(id: String, userName: String) {
        let conversation: Conversation? = withId(id, requestName: "ConversationWithId")
        guard conversation == nil else {
            conversation?.isOnline = true
            performSave()
            return
        }

        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User",
                                                             into: stack.saveContext) as? User
        else {
            return
        }
        user.userId = id
        user.name = userName
        user.isOnline = true

        guard let chat = NSEntityDescription.insertNewObject(forEntityName: "Conversation",
                                                             into: stack.saveContext) as? Conversation
        else {
            return
        }
        chat.conversationId = id
        chat.isOnline = true
        chat.hasUnreadMessages = false
        chat.lastMessage = nil
        chat.interlocutor = user
        chat.profileEntity = nil
        user.addToConversations(chat)

        performSave()
    }

    func makeConversationOffline(id: String) {
        guard let user: User = withId(id, requestName: "UserWithId"),
              let conversation: Conversation = withId(id, requestName: "ConversationWithId")
        else { return }

        if conversation.lastMessage != nil {
            conversation.isOnline = false
        } else {
            stack.saveContext.delete(conversation)
            stack.saveContext.delete(user)
        }

        performSave()
    }

    func appendMessage(text: String, conversationId: String, isIncoming: Bool) {
        guard let conversation: Conversation = withId(conversationId, requestName: "ConversationWithId")
        else { return }

        guard let message: Message = NSEntityDescription.insertNewObject(forEntityName: "Message",
                                                                         into: stack.saveContext) as? Message
        else {
            return
        }
        message.messageId = Message.generateMessageId()
        message.date = Date()
        message.isIncoming = isIncoming
        message.messageText = text
        message.conversation = conversation
        message.lastMessageInConversation = conversation

        conversation.hasUnreadMessages = isIncoming

        performSave()
    }

    func fetchRequest<T>(_ fetchRequestName: String,
                         substitutionDictionary: [String: Any]? = nil,
                         sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<T>? where T: NSManagedObject
    {
        let request: NSFetchRequest<T>?

        request = substitutionDictionary == nil ?
            stack.managedObjectModel.fetchRequestTemplate(forName: fetchRequestName) as? NSFetchRequest<T> :
            stack.managedObjectModel
            .fetchRequestFromTemplate(withName: fetchRequestName,
                                      substitutionVariables: substitutionDictionary!) as? NSFetchRequest<T>
        request?.sortDescriptors = sortDescriptors

        guard request != nil else {
            assert(false, "No template with name \(fetchRequestName) exists")
            return nil
        }

        return request
    }

    private func performSave() {
        stack.performSave(context: stack.saveContext) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
            }
        }
    }

    private func findOrInsert<T>(entityName: String) -> T? where T: NSManagedObject {
        let request = NSFetchRequest<T>(entityName: entityName)
        guard var object = try? stack.saveContext.fetch(request).first else {
            return nil
        }

        if object == nil {
            object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: stack.mainContext) as? T
        }

        return object
    }

    private func withId<T>(_ id: String, requestName: String) -> T? where T: NSManagedObject {
        guard let request: NSFetchRequest<T> =
            fetchRequest(requestName, substitutionDictionary: ["id": id]),
            let object = try? stack.saveContext.fetch(request).first else { return nil }

        return object
    }
}
