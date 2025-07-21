//
//  TokenInterceptor.swift
//  CoreNetworkInterface
//
//  Created by Greem on 7/20/25.
//

import CoreNetworkInterface
import Foundation

extension TokenInterceptor: @retroactive URLRequestInterceptor {
    
    public func adapt(_ urlRequest: URLRequest) async throws -> URLRequest {
        do {
            
            /// 우선 엑세스 토큰키를 로컬에서 가져온다.
            /// 토큰키를 기반으로 accessToken을 가져온다.
            /// accessToken이 없으면 에러를 방출한다.
            var request = urlRequest
            request.setValue("Bearer ", forHTTPHeaderField: "Authorization")
        } catch { /// 각각의 fetch 실패에 따른 에러 메시지를 interceptorError로 변환한다.
            throw NetworkError.interceptorError("무언가 잘 못 되었으니 retry를 하면 되겠지...")
        }
        
        return urlRequest
    }
    
    public func retry(
//        dueTo error: NetworkError
    ) async -> RetryResult {
        
        /// 네트워크 이후에 받은 값이 무엇인지 확인한다.
        /// 만약, API와 통신한 에러 케이스가 토큰 만료 에러라면 retryResult를 doNotRetry로 반환한다.
        
        
        
        /// 리프레시 토큰 키를 로컬에서 가져온다.
        /// 리프레시 토큰 키를 기반으로 refreshToken을 가져온다.
        /// 토큰을 받아오면 .retry 타입을 반환한다.
        return .retry
    }
}
