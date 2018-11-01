//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit
import Foundation

class GCDDataManager : DataManagerProtocol{
    
    let profileHandler: ProfileHandler = ProfileHandler()
    let queue = DispatchQueue(label:"com.pokhachevskiy.TinkoffChat" ,qos: .userInteractive)
    
    func saveData(profile: Profile, completion: @escaping (_ success: Bool) -> ()) {
        queue.async {
            let saveSucceeded = self.profileHandler.saveData(profile: profile)
        
            DispatchQueue.main.async {
                completion(saveSucceeded)
            }
        }
    }
    
    func loadData(completion: @escaping (_ profile: Profile?) -> ()) {
        queue.async {
            let retrievedProfile = self.profileHandler.loadData()
            
            DispatchQueue.main.async {
                completion(retrievedProfile)
            }
        }
    }
}
