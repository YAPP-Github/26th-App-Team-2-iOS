//
//  Requestable+Extension.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import CoreNetworkInterface
import Foundation

extension Requestable {
    func makeURLRequest(
        config: URLComponentConfig
    ) throws -> URLRequest {
        guard var urlComponent = try config.makeURLComponents(path: self.path) else {
            throw NetworkError.urlRequest(.urlComponent)
        }
        if let queryItems = try config.getQueryParameters(queryParameters: self.queryParameters) {
            urlComponent.queryItems = queryItems
        }
        
        guard let url = urlComponent.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        
        if let httpBody = try config.getBodyParameters(bodyParameters: self.bodyParameters) {
            urlRequest.httpBody = httpBody
        }
        
        if let headers = self.headers {
            headers.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = self.httpMethod.rawValue
        
        return urlRequest
    }
}
