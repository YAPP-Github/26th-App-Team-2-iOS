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

public class NetworkProvider {
    
    public let urlComponentConfig: URLComponentConfig
    
    public init(urlCompoentConfig: URLComponentConfig = URLComponentConfig(
            baseURL: Bundle.main.infoDictionary?["BASE_URL"] as? String,
            prefix: Bundle.main.infoDictionary?["BASE_URL_PREFIX"] as? String
        )) {
        self.urlComponentConfig = urlCompoentConfig
    }
}
