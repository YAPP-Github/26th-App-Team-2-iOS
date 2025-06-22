//
//  NetworkProviderAble.swift
//  CoreNetworkInterface
//
//  Created by Greem on 6/22/25.
//

import Foundation
import SharedUtilInterface

public protocol NetworkProviderAble {
    func request<Request: Networkable, Item: Decodable>(_ request: Request, isByPass: Bool) async throws -> Item where Request.Item == Item
}
