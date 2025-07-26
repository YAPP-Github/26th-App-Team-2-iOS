//
//  RequestInterceptTests.swift
//  CoreNetworkTests
//
//  Created by Greem on 7/21/25.
//

import Foundation
import Testing
import CoreNetworkInterface
import CoreNetworkTesting
import CoreLocalStorageInterface

struct RequestInterceptTests {
    
    let fakeTokenStorage: FakeTokenStorage = FakeTokenStorage()
    let fakeURLComponentConfig = URLComponentConfiguration(baseURL: "https://www.naver.com", prefix: nil)
    let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    @Test
    func interceptorTest_토큰유효성_검증_retry_메서드_실행_후_실패하는_테스트() async throws {
        let storage: TokenStorageProtocol = fakeTokenStorage
        let tokenInterceptor = MockTokenInterceptor(tokenStorage: storage)
        try fakeTokenStorage.save(
            token: AccessToken(token: FakeTokenStorage.fakeAccessToken),
            for: tokenInterceptor.dummyAccessTokenKey
        )
        
        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil
            )!
            
            let mockData = """
            {
                "errorCode" : "00401",
                "errorMessage" : "액세스 토큰이 유효하지 않습니다."
            }
            """.data(using: .utf8)!
            
            return (mockData, mockResponse)
        }
        
        
        let networkSession = NetworkSession(requestInterceptor: tokenInterceptor, urlSession: urlSession)
        let sut = NetworkProvider(
            networkSession: networkSession,
            urlComponentConfig: fakeURLComponentConfig
        )
        
        let _ : AccessToken! = try fakeTokenStorage.read(key: tokenInterceptor.dummyAccessTokenKey)
        let authRouter = BrakeRouter.AuthEndPoint<AuthRefreshResponse>.refresh(.init(refreshToken: "hello world!!"))
        
        let endpoint = Endpoint<EmptyData>(path: "", httpMethod: .post)
        
        do {
            _ = try await sut.request(endpoint)
            #expect(Bool(false), "retryableError가 발생하지 않았습니다.")
            // 정상적으로 응답이 오면 테스트 실패 처리
        }
        catch NetworkError.interceptorError(let error) {
            #expect(tokenInterceptor.adaptMethodCalled, "엑세스 adapt 메서드가 호출되지 않았습니다.")
            #expect(tokenInterceptor.retryMethodCalled, "토큰 재발급 메서드가 호출되지 않았습니다.")
        }
        catch let error as NetworkError {
            #expect(Bool(false), " \(error) 인터셉터 에러가 아닙니다")
        } catch {
            #expect(Bool(false), "원하는 범주의 에러를 벗어남 \(error)")
        }
    }
    
}

