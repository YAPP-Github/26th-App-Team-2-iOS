//
//  NetworkSession.swift
//  CoreNetworkInterface
//
//  Created by Greem on 7/21/25.
//

import Foundation

///  Mock으로 테스트에서 네트워킹을 하기 위해 URLSession 프로퍼티를 갖습니다.
public struct NetworkSession {
    public let requestInterceptor: URLRequestInterceptor?
    public let urlSession: URLSession
    
    public init(
        requestInterceptor: URLRequestInterceptor? = nil,
        urlSession: URLSession = .shared
    ) {
        self.urlSession = urlSession
        self.requestInterceptor = requestInterceptor
    }
    
    public func dataTask(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let requestInterceptor = requestInterceptor else {
            return try await urlSession.data(for: request)
        }
        let interceptorURLRequest: URLRequest = try await requestInterceptor.adapt(request)
        return try await urlSession.data(for: request)
    }
    
    public func retryInterceptor() async throws -> RetryResult {
        guard let requestInterceptor else {
            throw NetworkError.interceptorError("reqeustInterceptor가 없습니다.")
        }
        return await requestInterceptor.retry(session: urlSession)
    }
}
