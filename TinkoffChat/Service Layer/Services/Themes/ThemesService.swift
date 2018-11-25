//
//  ThemesService.swift
//  TinkoffChat
//
//  Created by Даниил on 18.11.2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

protocol IThemesService: class {
  func save(_ theme: UIColor)
  func load()
}

class ThemesService: IThemesService {
  private let themesManager: IThemesManager

  init(themesManager: IThemesManager) {
    self.themesManager = themesManager
  }

  func save(_ theme: UIColor) {
    themesManager.apply(theme, save: true)
  }

  func load() {
    themesManager.loadAndApply()
  }

}
