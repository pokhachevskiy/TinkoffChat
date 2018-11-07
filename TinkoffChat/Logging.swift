//
//  Logging.swift
//  TinkoffChat
//
//  Created by Даниил on 22.09.2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

func println(string: String) {
    #if DEBUG
    print(string)
    #endif
}

func parseUIApplicationState (applicationState: UIApplication.State) -> String {
    switch applicationState {
    case .active:
        return "active state"
    case .background:
        return "background state"
    case .inactive:
        return "inactive state"
    }
}
