//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation

struct RequestsFactory {

    struct PixabayRequests {
        private static let apiKey = "10785734-6c5746ab423422440f7e56e00"

        static func searchImages() -> RequestConfig<SearchImagesParser> {
            let request = SearchImagesRequest(key: apiKey)
            let parser = SearchImagesParser()
            return RequestConfig<SearchImagesParser>(request: request, parser: parser)
        }

        static func downloadImage(urlString: String) -> RequestConfig<DownloadImageParser> {
            let request = DownloadImageRequest(urlString: urlString)
            let parser = DownloadImageParser()
            return RequestConfig<DownloadImageParser>(request: request, parser: parser)
        }

    }

}
