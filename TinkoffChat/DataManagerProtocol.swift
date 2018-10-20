//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    func saveImageToFile(imageData: Data, completion: @escaping (_ success: Bool) -> ())
    func loadImageFromFile(completion: @escaping (_ result: Data?) -> ())
}
