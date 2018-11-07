//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Daniil on 01/11/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
class CoreDataManager: DataManagerProtocol {

    private let coreDataStack = CoreDataStack()

    func saveData(profile: Profile, completion: @escaping (_ success: Bool) -> Void) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let appUser = AppUser.findOrInsertAppUser(in: saveContext)
            appUser?.userName = profile.name
            appUser?.userInfo = profile.info
            if let picture = profile.image {
                appUser?.userImage = picture.jpegData(compressionQuality: 100)
            }
            self.coreDataStack.performSave(with: saveContext) {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }

    func loadData(completion: @escaping (_ profile: Profile?) -> Void) {
        let profile: Profile = Profile()
        let mainContext = self.coreDataStack.mainContext
        mainContext.perform {
            guard let appUser = AppUser.findOrInsertAppUser(in: mainContext) else {
                completion(nil)
                return
            }

            profile.name = appUser.userName
            profile.info = appUser.userInfo
            if let picture = appUser.userImage {
                profile.image = UIImage(data: picture, scale: 100)
            }
            completion(profile)
        }
    }
}
