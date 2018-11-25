//
//  PictureCell.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell, IPictureCellConfiguration {
    var fullUrl: String?
    var previewUrl: String?

    @IBOutlet var imageView: UIImageView!

    func setup(image: UIImage, picture: Picture) {
        imageView.image = image
        previewUrl = picture.previewUrl
        fullUrl = picture.fullUrl
    }

}
