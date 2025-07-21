//
//  NetworkProvider.swift
//  CoreNetwork
//
//  Created by Greem on 6/22/25.
//

import Foundation
import CoreNetworkInterface
import SharedUtil

extension NetworkProvider: @retroactive NetworkProviderProtocol {
    
    /// 이 메서드는 생성자의 인자로 받은 requestInterceptor를 통해 인증 갱신, 재시도 등 부가 처리를 자동으로 수행합니다.
    /// 별도의 인증/재시도 처리가 필요하지 않습니다.
    public func request<Request, Item>(
        _ endpoint: Request
    ) async throws -> Item where Request : CoreNetworkInterface.Networkable, Item : Decodable, Item == Request.Item {
        try await self.requestWithLimitCount(endpoint, limitCount: 0)
    }
    
    
    private func requestWithLimitCount<Request, Item>(
        _ endpoint: Request,
        limitCount: Int
    ) async throws -> Item where Request : CoreNetworkInterface.Networkable, Item : Decodable, Item == Request.Item {
        guard limitCount < 5 else {
            throw NetworkError.interceptorError("limitCount 5번 이상으로 재귀 호출되었습니다.")
        }
        do {
            let urlRequest: URLRequest = try endpoint.makeURLRequest(config: self.urlComponentConfig)
            guard let requestInterceptor else {
                return try await self.request<Item>(urlRequest: urlRequest)
            }
            let interceptRequest: URLRequest = try await requestInterceptor.adapt(urlRequest)
            return try await self.request<Item>(urlRequest: interceptRequest)
        } catch NetworkError.authorization { /// 인증 실패 에러 발생
            guard let retryResult: RetryResult = await requestInterceptor?.retry() else {
                throw NetworkError.interceptorError("reqeustInterceptor가 없습니다.")
            }
            switch retryResult {
            case .retry: return try await self.requestWithLimitCount(endpoint, limitCount: limitCount + 1)
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
}

