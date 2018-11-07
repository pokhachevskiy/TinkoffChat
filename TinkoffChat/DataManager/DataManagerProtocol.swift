//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    func saveData(profile: Profile, completion: @escaping (_ success: Bool) -> Void)
    func loadData(completion: @escaping (_ profile: Profile?) -> Void)
}
