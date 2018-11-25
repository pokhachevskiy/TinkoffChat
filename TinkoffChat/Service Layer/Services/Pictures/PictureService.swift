//
//  PictureService.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

class PictureService: IPicturesService {

    private let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }

    func getPictures(completionHandler: @escaping ([Picture]?, String?) -> Void) {
        let requestConfig = RequestsFactory.PixabayRequests.searchImages()

        requestSender.send(config: requestConfig) { (result: Result<[Picture]>) in

            switch result {
            case .success(let pictures):
                completionHandler(pictures, nil)
            case .error(let error):
                completionHandler(nil, error)
            }

        }
    }

    func downloadPicture(urlString: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        let requestConfig = RequestsFactory.PixabayRequests.downloadImage(urlString: urlString)

        requestSender.send(config: requestConfig) { (result: Result<UIImage>) in

            switch result {
            case .success(let picture):
                completionHandler(picture, nil)
            case .error(let error):
                completionHandler(nil, error)
            }

        }
    }

}
