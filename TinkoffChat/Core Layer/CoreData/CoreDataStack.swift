//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Даниил on 31/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  // MARK: - NSPersistentStore
  private var storeUrl : URL {
    get {
      let documentsDirURL : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let url = documentsDirURL.appendingPathComponent("TinkoffChat.sqlite")
      
      return url
    }
  }
  
  
  // MARK: - NSManagedObjectModel
  private let managedObjectModelName = "TinkoffChat"
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  
  // MARK: - Coordinator
  lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
      let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                     NSInferMappingModelAutomaticallyOption: true]
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                         configurationName: nil,
                                         at: storeUrl,
                                         options: options)
    }
    catch {
      print("Error adding persistent store to coordinator: \(error)")
    }
    
    return coordinator
  }()
  
  
  // MARK: - NSManagedObjectContext
  // (Master)
  lazy var masterContext: NSManagedObjectContext = {
    var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    masterContext.mergePolicy = NSOverwriteMergePolicy
    
    return masterContext
  }()
  
  // (Main)
  lazy var mainContext: NSManagedObjectContext = {
    var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    mainContext.parent = self.masterContext
    mainContext.mergePolicy = NSOverwriteMergePolicy
    
    return mainContext
  }()
  
  // (Save)
  lazy var saveContext: NSManagedObjectContext = {
    var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    saveContext.parent = self.mainContext
    saveContext.mergePolicy = NSOverwriteMergePolicy
    
    return saveContext
  }()
  
  
  func performSave(context: NSManagedObjectContext, completion: @escaping (Error?) -> ()) {
    if context.hasChanges {
      context.perform { [weak self] in
        do {
          try context.save()
        } catch {
          print("Context save error: \(error)")
          completion(error)
        }
        
        if let parent = context.parent {
          self?.performSave(context: parent, completion: completion)
        } else {
          completion(nil)
        }
      }
    } else {
      completion(nil)
    }
  }
  
}
