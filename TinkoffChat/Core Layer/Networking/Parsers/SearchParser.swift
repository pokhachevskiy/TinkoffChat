//
//  SearchParse.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation

struct Response: Codable {
    let hits: [Picture]
}

class SearchImagesParser: IParser {
    typealias Model = [Picture]

    func parse(data: Data) -> Model? {
        do {
            return try JSONDecoder().decode(Response.self, from: data).hits
        } catch {
            print("Error trying to convert data to JSON SearchParser")
            return nil
        }
    }
}
