//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}

class RequestSender: IRequestSender {
    let session = URLSession(configuration: URLSessionConfiguration.default)

    func send<Parser>(config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: IParser {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.error("url string can't be parsed to URL"))
            return
        }

        let task = session.dataTask(with: urlRequest) { (data: Data?, _: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(.error(error.localizedDescription))
                return
            }

            guard let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(.error("received data can't be parsed"))
                    return
            }

            completionHandler(.success(parsedModel))
        }

        task.resume()
    }

}
