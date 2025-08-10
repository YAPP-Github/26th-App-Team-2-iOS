//
//  Responsable.swift
//  CoreNetworkInterface
//
//  Created by Greem on 6/22/25.
//

import Foundation

public struct EmptyData: Decodable, Equatable {
    public init() { }
}

public protocol HTTPResponseProtocol {
    associatedtype Item: Decodable
}
