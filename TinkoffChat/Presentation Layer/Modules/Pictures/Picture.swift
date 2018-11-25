//
//  Picture.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation

struct Picture: Codable {
    let previewUrl: String
    let fullUrl: String

    enum CodingKeys: String, CodingKey {
        case previewUrl = "previewURL"
        case fullUrl = "largeImageURL"
    }
}
