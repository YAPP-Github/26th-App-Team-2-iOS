//
//  NetworkTesting.swift
//  CoreNetwork
//
//  Created by Greem on 6/29/25.
//

import CoreNetworkInterface
import CoreNetwork

public struct TempTestResponse: Decodable {
    public let id: Int
    
    public init(id: Int) {
        self.id = id
    }
}
