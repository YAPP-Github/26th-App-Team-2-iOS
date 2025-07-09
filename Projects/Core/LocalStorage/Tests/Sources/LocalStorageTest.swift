//  LocalStorage.swift
//  Brake
//
//  Created by Derrick kim on 2025/07/09.
//

import Foundation
import CoreLocalStorageInterface
import CoreLocalStorage
import Testing

struct LocalStorageTests {
    let tokenStorage = TokenStorage()

    @Test
    func accessTokenCRUD() async throws {
        // 1. 읽기(비어있음)
        let emptyAccessToken: AccessToken? = try tokenStorage.read(key: "testingAccessTokenKey")
        #expect(emptyAccessToken == nil)

        // 2. 삭제(비어있음)
        let deleteEmptyResult = try tokenStorage.delete(for: "testingAccessTokenKey")
        #expect(deleteEmptyResult == false)

        // 3. 저장
        let testAccessToken = AccessToken(
            token: "test-access-token",
            expiration: Date()
        )
        try tokenStorage.save(token: testAccessToken, for: "testingAccessTokenKey")

        // 4. 읽기(저장됨)
        let fetched: AccessToken? = try tokenStorage.read(key: "testingAccessTokenKey")
        #expect(fetched == testAccessToken)

        // 5. 삭제(성공)
        let deleteResult = try tokenStorage.delete(for: "testingAccessTokenKey")
        #expect(deleteResult == true)
    }

    @Test
    func refreshTokenCRUD() async throws {
        let emptyRefreshToken: RefreshToken? = try tokenStorage.read(key: "testingRefreshTokenKey")
        #expect(emptyRefreshToken == nil)

        let deleteEmptyResult = try tokenStorage.delete(for: "testingRefreshTokenKey")
        #expect(deleteEmptyResult == false)

        let testRefreshToken = RefreshToken(
            token: "test-refresh-token",
            expiration: Date()
        )
        try tokenStorage.save(token: testRefreshToken, for: "testingRefreshTokenKey")

        let fetched: RefreshToken? = try tokenStorage.read(key: "testingRefreshTokenKey")
        #expect(fetched == testRefreshToken)

        let deleteResult = try tokenStorage.delete(for: "testingRefreshTokenKey")
        #expect(deleteResult == true)
    }
}
