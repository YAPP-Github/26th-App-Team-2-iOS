//
//  MockNetworkSession.swift
//  CoreNetworkInterface
//
//  Created by Greem on 7/21/25.
//

import Foundation
import CoreNetworkInterface
import CoreLocalStorageInterface
import Shared

final public class MockTokenInterceptor: URLRequestInterceptor {
    
    public var request: URLRequest?
    public var adaptMethodCalled: Bool = false
    public var retryMethodCalled: Bool = false
    
    public let dummyAccessTokenKey: String = "DummyFeelinAccessTokenKey"
    public let dummyRefreshTokenKey: String = "DummyFeelinRefreshTokenKey"
    private let tokenStorage: TokenStorageProtocol
    
    public init(tokenStorage: TokenStorageProtocol) {
        self.tokenStorage = tokenStorage
    }
    
    public func adapt(_ urlRequest: URLRequest) async throws -> URLRequest  {
        self.adaptMethodCalled = true
        var request = urlRequest
        
        do {
            guard let accessToken: AccessToken = try await self.tokenStorage.read(key: dummyAccessTokenKey) else {
                return urlRequest
            }
            
            var request = urlRequest
            request.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
            
            return request
        } catch TokenKeyHolderError.refreshTokenKeyMissing {
            throw NetworkError.interceptorError("액세스 토큰 키가 없습니다.")
        } catch DecodingError.dataCorrupted(let context) { // JSONDecoder 에러
            throw NetworkError.interceptorError("Token Storage 디코딩을 실패했습니다. \(context.debugDescription)")
        } catch { /// 각각의 fetch 실패에 따른 에러 메시지를 interceptorError로 변환한다.
            throw NetworkError.interceptorError("알 수 없는 Token Interceptor 에러")
        }
    }
    
    public func retry(session: URLSession) async -> RetryResult {
        self.retryMethodCalled = true
        return .doNotRetry
    }
}
