//
//  File.swift
//  CoreNetworkInterface
//
//  Created by 김태윤 on 6/29/25.
//

import Foundation

public protocol URLCompoentConfigurable {
    func makeURLComponents(path: String) throws -> URLComponents?
    func getQueryParameters(queryParameters: Encodable?) throws -> [URLQueryItem]?
    func getBodyParameters(bodyParameters: Encodable?) throws -> Data?
}
