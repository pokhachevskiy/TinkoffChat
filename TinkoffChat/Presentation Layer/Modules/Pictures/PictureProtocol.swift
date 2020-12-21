//
//  PictureProtocol.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

protocol ICollectionPickerController: AnyObject {
    func close()
}

protocol IPicturesViewControllerDelegate: AnyObject {
    func collectionPictureController(_ picker: ICollectionPickerController, didFinishPickingImage image: UIImage)
}

protocol IPictureCellConfiguration {
    var previewUrl: String? { get set }
    var fullUrl: String? { get set }
}

protocol IPicturesModel: AnyObject {
    var data: [Picture] { get set }

    func fetchAllPictures(completionHandler: @escaping ([Picture]?, String?) -> Void)
    func fetchPicture(urlString: String, completionHandler: @escaping (UIImage?) -> Void)
}
