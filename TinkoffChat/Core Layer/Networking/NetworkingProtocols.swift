//
//  NetworkingProtocols.swift
//  TinkoffChat
//
//  Created by Даниил on 23/11/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
}
