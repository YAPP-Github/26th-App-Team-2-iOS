//
//  URLRequestInterceptor.swift
//  CoreNetworkInterface
//
//  Created by Greem on 7/20/25.
//

import Foundation

public enum RetryResult {
    case retry
    case doNotRetry
    case doNotRetryWithEror(Error)
}

public protocol URLRequestInterceptor {
    func adapt(_ urlRequest: URLRequest) async throws -> URLRequest
    func retry() async -> RetryResult
}
