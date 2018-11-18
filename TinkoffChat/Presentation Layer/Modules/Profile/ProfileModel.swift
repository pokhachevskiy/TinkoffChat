//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Даниил on 18.11.2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

protocol IAppUser {
  var name: String? { get set }
  var about: String? { get set }
  var picture: UIImage? { get set }
}



protocol IAppUserModel: IAppUser {
  func set(on profile: IAppUser)
  func save(_ completion: @escaping (Bool) -> ())
  func load(_ completion: @escaping (IAppUser?) -> ())
}



class Profile: IAppUser {
  
  var name: String?
  var about: String?
  var picture: UIImage?
  
  init(name: String? = nil, about: String? = nil, picture: UIImage? = nil) {
    self.name = name
    self.about = about
    self.picture = picture
  }
  
}

class ProfileModel: IAppUserModel {
  private let dataService: IDataManager
  
  var name: String?
  var about: String?
  var picture: UIImage?
  
  
  init(dataService: IDataManager, name: String? = nil, about: String? = nil, picture: UIImage? = nil) {
    self.dataService = dataService
    
    self.name = name
    self.about = about
    self.picture = picture
  }
  
  
  func set(on profile: IAppUser) {
    self.name = profile.name
    self.about = profile.about
    self.picture = profile.picture
  }
  
  
  func save(_ completion: @escaping (Bool) -> ()) {
    dataService.saveAppUser(self, completion: completion)
  }
  
  
  func load(_ completion: @escaping (IAppUser?) -> ()) {
    dataService.loadAppUser(completion: completion)
  }
  
}
