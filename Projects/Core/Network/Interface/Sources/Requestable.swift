//
//  Requestable.swift
//  CoreNetworkInterface
//
//  Created by Greem on 6/22/25.
//

import Foundation

public protocol Requestable {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String : String]? { get }
}
