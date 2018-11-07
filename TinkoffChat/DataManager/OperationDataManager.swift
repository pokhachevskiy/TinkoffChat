//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Daniil on 20/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

class OperationDataManager: DataManagerProtocol {
    let profileHandler: ProfileHandler = ProfileHandler()
    let operationQueue = OperationQueue()
    init() {
        operationQueue.maxConcurrentOperationCount = 1
    }
    func saveData(profile: Profile, completion: @escaping (Bool) -> Void) {
        let saveOperation = SaveProfileOperation(profileHandler: self.profileHandler, profile: profile)
        saveOperation.qualityOfService = .userInitiated
        saveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(saveOperation.saveSucceeded)
            }
        }
        operationQueue.addOperation(saveOperation)
    }
    func loadData(completion: @escaping (Profile?) -> Void) {
        let loadOperation = LoadProfileOperation(profileHandler: self.profileHandler)
        loadOperation.qualityOfService = .userInitiated
        loadOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(loadOperation.profile)
            }
        }
        operationQueue.addOperation(loadOperation)
    }
}
