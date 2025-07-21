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
    
    public func req<Request, Item>(
        _ endpoint: Request
    ) async throws -> Item where Request : CoreNetworkInterface.Networkable, Item : Decodable, Item == Request.Item {
        do {
            let urlRequest: URLRequest = try makeURLRequest(endpoint, config: self.urlComponentConfig)
            if let interceptRequest: URLRequest = try await requestInterceptor?.adapt(urlRequest) {
                return try await self.request<Item>(urlRequest: interceptRequest)
            } else {
                return try await self.request<Item>(urlRequest: urlRequest)
            }
        } catch NetworkError.authorization { /// 인증 실패 에러 발생
            guard let retryResult: RetryResult = await requestInterceptor?.retry() else {
                throw NetworkError.interceptorError("reqeustInterceptor가 없습니다.")
            }
            switch retryResult {
            case .retry: return try await req(endpoint)
            case .doNotRetry: throw NetworkError.interceptorError("기간이 만료되었습니다!!")
            case .doNotRetryWithEror(let error): throw error
            }
        }
        catch URLError.Code.notConnectedToInternet {
            throw NetworkError.internetConnection
        } catch {
            throw error
        }
    }
    
    
    private func request<Item: Decodable>(urlRequest: URLRequest) async throws -> Item {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            try response.validateResponse()
            
            if let emptyResponse = try JSONDecoder().decode(EmptyData.self, from: data) as? Item, data.isEmpty {
                return emptyResponse
            }
            guard let decodedResponse = try? JSONDecoder().decode(Item.self, from: data) else {
                throw NetworkError.decoding
            }
            return decodedResponse
        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.internetConnection
        }
    }
    
    public func request<Request, Item>(
        _ endpoint: Request
    ) async throws -> Item where Request : CoreNetworkInterface.Networkable, Item : Decodable, Item == Request.Item {
        do {
            let urlRequest: URLRequest = try makeURLRequest(endpoint, config: self.urlComponentConfig)
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            try response.validateResponse()
            
            if let emptyResponse = try JSONDecoder().decode(EmptyData.self, from: data) as? Item, data.isEmpty {
                return emptyResponse
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(Item.self, from: data) else {
                throw NetworkError.decoding
            }
            
            return decodedResponse
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
