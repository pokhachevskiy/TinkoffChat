//
//  FRCManager.swift
//  TinkoffChat
//
//  Created by Daniil on 11/11/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
import CoreData

class FRCManager: NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate: ConversationDelegate?

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .delete:
                if let indexPath = indexPath {
                    self.delegate?.deleteRows(at: [indexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    self.delegate?.reloadRows(at: [indexPath], with: .automatic)
                }
            case .move:
                if let indexPath = indexPath {
                    self.delegate?.deleteRows(at: [indexPath], with: .automatic)
                }

                if let newIndexPath = newIndexPath {
                    self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.beginUpdates()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.endUpdates()
        }
    }
}
