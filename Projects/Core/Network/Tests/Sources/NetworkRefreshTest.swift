//
//  NetworkRefreshTest.swift
//  CoreNetworkTests
//
//  Created by Greem on 7/21/25.
//

import Foundation
import Testing
import CoreNetworkInterface
import CoreNetworkTesting

/// 통신 테스트 -> 외부 객체를 잘 가져오는지 테스트...
struct NetworkRefreshTest {
    func fetchTokenKeytest() async throws {
        let fakeTokenStorage = FakeTokenStorage()
        let tokenInterceptor = TokenInterceptor(tokenStorage: fakeTokenStorage)
        let accessTokenKey = try tokenInterceptor.tokenKeyHolder.fetchAccessTokenKey()
        let refreshTokenKey = try tokenInterceptor.tokenKeyHolder.fetchRefreshTokenKey()
        
        let tokenStorage = tokenInterceptor.tokenStorage
        
    }
}

extension NetworkRefreshTest {
    
}
