//
//  PictureModel.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

class PictureModel: IPicturesModel {
    private let picturesService: IPicturesService
    var data: [Picture] = []

    init(picturesService: IPicturesService) {
        self.picturesService = picturesService
    }

    func fetchAllPictures(completionHandler: @escaping ([Picture]?, String?) -> Void) {
        picturesService.getPictures { pictures, errorText in

            guard let pictures = pictures else {
                completionHandler(nil, errorText)
                return
            }

            completionHandler(pictures, nil)
        }
    }

    func fetchPicture(urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        picturesService.downloadPicture(urlString: urlString) { image, _ in

            guard let image = image else {
                return completionHandler(nil)
            }

            completionHandler(image)
        }
    }

}
