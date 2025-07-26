//
//  TokenInterceptor.swift
//  CoreNetworkInterface
//
//  Created by Greem on 7/20/25.
//

import CoreNetworkInterface
import CoreLocalStorageInterface
import Foundation

extension TokenInterceptor: @retroactive URLRequestInterceptor {
    public func adapt(_ urlRequest: URLRequest) async throws -> URLRequest {
        do {
            let fetchedAccessTokenKey: String = try self.tokenKeyHolder.fetchAccessTokenKey()
            guard let accessToken: AccessToken = try await self.tokenStorage.read(key: fetchedAccessTokenKey) else {
                return urlRequest
            }
            
            var request = urlRequest
            request.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
            return request
        } catch TokenKeyHolderError.accessTokenKeyMissing {
            throw NetworkError.interceptorError("액세스 토큰 키가 없습니다.")
        } catch DecodingError.dataCorrupted(let context) { // JSONDecoder 에러
            throw NetworkError.interceptorError("Token Storage 디코딩을 실패했습니다. \(context.debugDescription)")
        } catch { /// 각각의 fetch 실패에 따른 에러 메시지를 interceptorError로 변환한다.
            throw NetworkError.interceptorError("알 수 없는 Token Interceptor 에러")
        }
    }
    
    public func retry(session: URLSession) async -> RetryResult {
        do {
            let fetchedRefreshTokenKey: String = try self.tokenKeyHolder.fetchRefreshTokenKey()
            guard let refreshToken: RefreshToken = try await self.tokenStorage.read(key: fetchedRefreshTokenKey) else {
                return .doNotRetry
            }
            let refreshTokenDTO = AuthRefreshRequest(refreshToken: refreshToken.token)
            let reissueEndPoint = BrakeRouter.AuthEndPoint<AuthRefreshResponse>.refresh(refreshTokenDTO)
            
            let reissueURLRequest: URLRequest = try reissueEndPoint.makeURLRequest(config: .default)
            
            let retryResult = await reissueToken(
                session: session,
                request: reissueURLRequest
            )
            
            return retryResult
        } catch {
            return .doNotRetryWithError(error)
        }
    }
    
    /// 토큰 재발행
    private func reissueToken(
        session: URLSession,
        request: URLRequest
    ) async -> RetryResult  {
        do {
            let (data, response) = try await session.data(for: request)
            
            try response.validateResponse()
            let serverResponseDTO: BrakeResponse<AuthRefreshResponse> = try JSONDecoder().decode(BrakeResponse<AuthRefreshResponse>.self, from: data)
            
            let accessToken: AccessToken = try jwtDecoder.decode(serverResponseDTO.data.accessToken, as: AccessToken.self)
            let refreshToken: RefreshToken = try jwtDecoder.decode(serverResponseDTO.data.refreshToken, as: RefreshToken.self)
            
            
            let accessTokenKey = try tokenKeyHolder.fetchAccessTokenKey()
            let refreshTokenKey = try tokenKeyHolder.fetchRefreshTokenKey()
            
            try await self.tokenStorage.save(token: accessToken, for: accessTokenKey)
            try await self.tokenStorage.save(token: refreshToken, for: refreshTokenKey)
            
            return .retry
        } catch {
            return .doNotRetryWithError(error)
        }
    }
}
