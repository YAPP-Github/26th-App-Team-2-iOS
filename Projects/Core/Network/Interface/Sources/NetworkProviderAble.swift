//
//  NetworkProviderAble.swift
//  CoreNetworkInterface
//
//  Created by Greem on 6/22/25.
//

import Foundation

public protocol NetworkProviderable {
    func request<Request: Networkable, Item: Decodable>(_ request: Request) async throws -> Item where Request.Item == Item
}

