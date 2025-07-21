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
    /// 1. 토큰 Response DTO 제작 작업
    /// 2. EndPoint path 설정 및 httpMethod 설정 작업
    /// 3. TokenKey를 어떻게 설정하면 되는가? -> 이거 테스트하려면 나중에 Xcode Cloud에도 키 값을 추가해야할 듯...
    
    public func adapt(_ urlRequest: URLRequest) async throws -> URLRequest {
        do {
            let fetchedAccessTokenKey: String = try self.tokenKeyHolder.fetchAccessTokenKey()
            guard let accessToken: AccessToken = try self.tokenStorage.read(key: fetchedAccessTokenKey) else {
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
    
    public func retry() async -> RetryResult {
        do {
            let fetchedRefreshTokenKey: String = try self.tokenKeyHolder.fetchRefreshTokenKey()
            guard let refreshToken: RefreshToken = try self.tokenStorage.read(key: fetchedRefreshTokenKey) else {
                return .doNotRetry
            }
            let refreshTokenDTO = AuthRefreshTokenDTO(refreshToken: refreshToken.token)
            let reissueEndPoint = Endpoint<ServerResponseDTO<AuthRefreshDTO>>(
                path: "/refresh",
                httpMethod: .post,
                bodyParameters: refreshTokenDTO
            )
            
            let reissueURLRequest: URLRequest = try reissueEndPoint.makeURLRequest(config: .default)
            
            let retryResult = await reissueToken(request: reissueURLRequest)
            return retryResult
        } catch {
            return .doNotRetryWithEror(error)
        }
    }
    
    /// 토큰 재발행
    private func reissueToken(request: URLRequest) async -> RetryResult  {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            try response.validateResponse()
            let serverResponseDTO: ServerResponseDTO<AuthRefreshDTO> = try JSONDecoder().decode(ServerResponseDTO<AuthRefreshDTO>.self, from: data)
            
            let accessToken: AccessToken = try jwtDecoder.decode(serverResponseDTO.data.accessToken, as: AccessToken.self)
            let refreshToken: RefreshToken = try jwtDecoder.decode(serverResponseDTO.data.refreshToken, as: RefreshToken.self)
            
            
            let accessTokenKey = try tokenKeyHolder.fetchAccessTokenKey()
            let refreshTokenKey = try tokenKeyHolder.fetchRefreshTokenKey()
            
            try self.tokenStorage.save(token: accessToken, for: accessTokenKey)
            try self.tokenStorage.save(token: refreshToken, for: refreshTokenKey)
            
            return .retry
        } catch {
            return .doNotRetryWithEror(error)
        }
    }
}
