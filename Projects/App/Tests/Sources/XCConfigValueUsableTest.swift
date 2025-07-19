//
//  XCConfigValueUsableTest.swift
//  Brake-Debug-Tests
//
//  Created by Greem on 7/16/25.
//

import Foundation
import Testing

struct XCConfigValueUsableTest {
    let testBundle = Bundle(identifier: "yapp.breake.Debug.tests")
    
    @Test func teamIDUsable() {
        let developTeamID = testBundle?.infoDictionary?["DEVELOPMENT_TEAM_ID"] as? String
        #expect(developTeamID != nil, .init(stringLiteral: "TEAM_ID가 없습니다!!"))
    }
    
    @Test func kakakoNativeAppKeyReleaseUsable() {
        let kakakoNativeAppKeyNative = testBundle?.infoDictionary?["KAKAO_NATIVE_APP_KEY_RELEASE"] as? String
        #expect(kakakoNativeAppKeyNative != nil, .init(rawValue: "kakakoNativeAppKey - Releasee가 없습니다!!"))
    }
    @Test func serverURLReleaseUsable() {
        let serverReleaseURL = testBundle?.infoDictionary?["BASE_SERVER_URL_RELEASE"] as? String
        #expect(serverReleaseURL != nil, .init(rawValue: "serverURL - Release가 없습니다!!"))
    }
    
    @Test func kakaoNativeAppKeyDebugUsable() {
        let kakaoNativeAppKeyDebug = testBundle?.infoDictionary?["KAKAO_NATIVE_APP_KEY_DEBUG"] as? String
        #expect(kakaoNativeAppKeyDebug != nil, .init(rawValue: "kakakoNativeAppKey - Debug가 없습니다!!"))
    }
    
    @Test func serverURLDebugUsable() {
        let serverDebugURL = testBundle?.infoDictionary?["BASE_SERVER_URL_DEBUG"] as? String
        #expect(serverDebugURL != nil, .init(rawValue: "serverURL - Debug가 없습니다!!"))
    }
    
}
