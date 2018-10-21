//
//  Operations.swift
//  TinkoffChat
//
//  Created by Daniil on 21/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

class LoadProfileOperation: Operation {
    
    private let profileHandler: ProfileHandler
    var profile: Profile?
    
    
    init(profileHandler: ProfileHandler) {
        self.profileHandler = profileHandler
        super.init()
    }
    
    
    override func main() {
        if self.isCancelled { return }
        self.profile = self.profileHandler.loadData()
    }
}

class SaveProfileOperation: Operation {
    
    var saveSucceeded: Bool = true
    private let profileHandler: ProfileHandler
    private let profile: Profile
    
    
    init(profileHandler: ProfileHandler, profile: Profile) {
        self.profileHandler = profileHandler
        self.profile = profile
        super.init()
    }
    
    
    override func main() {
        if self.isCancelled { return }
        self.saveSucceeded = self.profileHandler.saveData(profile: self.profile)
    }
    
}


