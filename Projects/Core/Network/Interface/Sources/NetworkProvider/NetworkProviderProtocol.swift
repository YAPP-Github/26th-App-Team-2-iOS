//
//  NetworkProviderAble.swift
//  CoreNetworkInterface
//
//  Created by Greem on 6/22/25.
//

import Foundation

public protocol NetworkProviderProtocol {
    func request<Request: Networkable, Item: Decodable>(_ request: Request) async throws -> Item where Request.Item == Item
}

public class NetworkProvider {
    
    public let networkSession: NetworkSession
    public let urlComponentConfig: URLComponentConfiguration
    
    public init(
        networkSession: NetworkSession,
        urlComponentConfig: URLComponentConfiguration = URLComponentConfiguration(
            baseURL: Bundle.main.infoDictionary?["BASE_URL"] as? String,
            prefix: Bundle.main.infoDictionary?["BASE_URL_PREFIX"] as? String
        )
    ) {
        self.networkSession = networkSession
        self.urlComponentConfig = urlComponentConfig
    }
}
