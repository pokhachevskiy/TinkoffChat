//
//  LoadParser.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

class DownloadImageParser: IParser {
    typealias Model = UIImage

    func parse(data: Data) -> Model? {
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
}
