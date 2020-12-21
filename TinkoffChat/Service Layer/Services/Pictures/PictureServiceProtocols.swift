//
//  PictureServiceProtocols.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

protocol IPicturesService {
    func getPictures(completionHandler: @escaping ([Picture]?, String?) -> Void)

    func downloadPicture(urlString: String, completionHandler: @escaping (UIImage?, String?) -> Void)
}
