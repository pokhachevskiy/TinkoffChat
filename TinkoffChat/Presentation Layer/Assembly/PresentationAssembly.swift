//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Даниил on 18.11.2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
  func themesViewController(_ closure: @escaping ColorAlias) -> ThemesViewController
  
  func profileViewController() -> ProfileViewController
  
  func conversationsListViewController() -> ConversationsListViewController
  
  func conversationViewController(model: ConversationModel) -> ConversationViewController
}



class PresentationAssembly: IPresentationAssembly {
  
  private let serviceAssembly: IServicesAssembly
  
  init(serviceAssembly: IServicesAssembly) {
    self.serviceAssembly = serviceAssembly
  }
  
  
  func themesViewController(_ closure: @escaping ColorAlias) -> ThemesViewController {
    return ThemesViewController(model: themesModel(closure))
  }
  
  
  private func themesModel(_ closure: @escaping ColorAlias) -> IThemesModel {
    return ThemesModel(theme1: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), theme2: #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.294, alpha: 1), theme3: #colorLiteral(red: 0.773, green: 0.702, blue: 0.345, alpha: 1), closure: closure)
  }
  
  
  func profileViewController() -> ProfileViewController {
    return ProfileViewController(model: profileModel())
  }
  
  
  private func profileModel() -> IAppUserModel {
    return ProfileModel(dataService: CoreDataManager())
  }
  
  
  func conversationViewController(model: ConversationModel) -> ConversationViewController {
    return ConversationViewController(model: model)
  }
  
  
  func conversationsListViewController() -> ConversationsListViewController {
    return ConversationsListViewController(model: conversationsListModel(),
                                           presentationAssembly: self)
  }
  
  private func conversationsListModel() -> IConversationListModel {
    return ConversationsListModel(communicationService: serviceAssembly.communicationService,
                                  themesService: serviceAssembly.themesService,
                                  frcService: serviceAssembly.frcService)
  }
  
}
