//
//  FRCService.swift
//  TinkoffChat
//
//  Created by Даниил on 18.11.2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import CoreData

protocol IFRCService: class {
  func allConversations() -> NSFetchRequest<Conversation>?
  func messagesInConversation(with id: String) -> NSFetchRequest<Message>?
  
  var saveContext: NSManagedObjectContext { get }
}

class FRCService: IFRCService {
  private let stack: ICoreDataStack
  
  
  init(stack: ICoreDataStack) {
    self.stack = stack
  }
  
  
  var saveContext: NSManagedObjectContext {
    return stack.saveContext
  }
  
  
  func allConversations() -> NSFetchRequest<Conversation>? {
    let name = NSSortDescriptor(key: "interlocutor.name", ascending: true)
    let date = NSSortDescriptor(key: "lastMessage.date", ascending: false)
    let online = NSSortDescriptor(key: "isOnline", ascending: false)
    let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
    fetchRequest.sortDescriptors = [online, date, name]
    
    return fetchRequest
  }
  
  
  func messagesInConversation(with id: String) -> NSFetchRequest<Message>? {
    return stack.fetchRequest("MessagesInConversation", substitutionDictionary: ["id": id], sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
  }
  
}
