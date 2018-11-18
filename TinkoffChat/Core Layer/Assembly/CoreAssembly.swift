//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Даниил on 18.11.2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

protocol ICoreAssembly {
  var multipeerCommunicator: ICommunicator { get }
  var dataManager: IDataManager { get }
  var themesManager: IThemesManager { get }
  var coreDataStub: ICoreDataStack { get }
}

class CoreAssembly: ICoreAssembly {
  lazy var multipeerCommunicator: ICommunicator = MultipeerCommunicator()
  lazy var themesManager: IThemesManager = ThemesManager()
  lazy var dataManager: IDataManager = coreDataManager
  lazy var coreDataStub: ICoreDataStack = coreDataManager
  private let coreDataManager = CoreDataManager()
}
