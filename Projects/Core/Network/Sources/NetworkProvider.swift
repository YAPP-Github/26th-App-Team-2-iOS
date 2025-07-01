//
//  NetworkProvider.swift
//  CoreNetwork
//
//  Created by Greem on 6/22/25.
//

import Foundation
import CoreNetworkInterface
import SharedUtil

/// URLComponentConig의 값이 달라지면 NetworkProvider 객체는 새로 생성해야함
/// URLComponentConfig가 달라지는 것에 대한 대응은 되지만, 객체의 불변 객체의 정책을 따름
extension NetworkProvider: @retroactive NetworkProviderable {
    
    public func request<Request, Item>(
        _ endpoint: Request
    ) async throws -> Item where Request : CoreNetworkInterface.Networkable, Item : Decodable, Item == Request.Item {
        do {
            let urlRequest: URLRequest = try makeURLRequest(endpoint, config: self.urlComponentConfig)

            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            if let emptyResponse = try JSONDecoder().decode(EmptyData.self, from: data) as? Item, data.isEmpty {
                return emptyResponse
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(Item.self, from: data) else {
                    throw NetworkError.decoding
                }
                return decodedResponse
            case 401:
                throw NetworkError.authorization
            case 400...499:
                throw NetworkError.badRequest
            case 500...599 :
                throw NetworkError.server
            default:
                throw NetworkError.unknown
            }
            
        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.internetConnection
        }
    }
    
    private func makeURLRequest<Request>(
        _ endpoint: Request,
        config: URLComponentConfig
    ) throws -> URLRequest where Request : CoreNetworkInterface.Networkable {
        guard var urlComponent = try config.makeURLComponents(path: endpoint.path) else {
            throw NetworkError.urlRequest(.urlComponent)
        }
        if let queryItems = try config.getQueryParameters(queryParameters: endpoint.queryParameters) {
            urlComponent.queryItems = queryItems
        }
        
        guard let url = urlComponent.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        
        if let httpBody = try config.getBodyParameters(bodyParameters: endpoint.bodyParameters) {
            urlRequest.httpBody = httpBody
        }
        
        if let headers = endpoint.headers {
            headers.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        return urlRequest
    }
}
