//
//  XCConfigValueUsableTest.swift
//  Brake-Debug-Tests
//
//  Created by Greem on 7/16/25.
//

import Foundation
import Testing

struct XCConfigValueUsableTest {
    let testBundle = Bundle(identifier: "yapp.breake.debug.tests")
    
    @Test func teamIDUsable() {
        let developTeamID = testBundle?.infoDictionary?["DEVELOPMENT_TEAM_ID"] as? String
        #expect(developTeamID != nil, .init(stringLiteral: "TEAM_ID가 없습니다!!"))
    }
    
    @Test func serverURLReleaseUsable() {
        let serverReleaseURL = testBundle?.infoDictionary?["BASE_SERVER_URL_RELEASE"] as? String
        #expect(serverReleaseURL != nil, .init(rawValue: "serverURL - Release가 없습니다!!"))
    }
    
    
    @Test func serverURLDebugUsable() {
        let serverDebugURL = testBundle?.infoDictionary?["BASE_SERVER_URL_DEBUG"] as? String
        #expect(serverDebugURL != nil, .init(rawValue: "serverURL - Debug가 없습니다!!"))
    }
    

    @Test func kakaoJSKeyDebugUsable() {
        let kakaoJSKeyDebug = testBundle?.infoDictionary?["KAKAO_JS_KEY_DEBUG"] as? String
        #expect(kakaoJSKeyDebug != nil, .init(rawValue: "kakaoJSKey - Debug가 없습니다!!"))
    }

    @Test func kakaoRESTAPIKeyDebugUsable() {
        let kakaoRESTAPIKeyDebug = testBundle?.infoDictionary?["KAKAO_REST_API_KEY_DEBUG"] as? String
        #expect(kakaoRESTAPIKeyDebug != nil, .init(rawValue: "kakaoRESTAPIKey - Debug가 없습니다!!"))
    }

    @Test func kakaoJSKeyReleaseUsable() {
        let kakaoJSKeyRelease = testBundle?.infoDictionary?["KAKAO_JS_KEY_RELEASE"] as? String
        #expect(kakaoJSKeyRelease != nil, .init(rawValue: "kakaoJSKey - Release가 없습니다!!"))
    }

    @Test func kakaoRESTAPIKeyReleaseUsable() {
        let kakaoRESTAPIKeyRelease = testBundle?.infoDictionary?["KAKAO_REST_API_KEY_RELEASE"] as? String
        #expect(kakaoRESTAPIKeyRelease != nil, .init(rawValue: "kakaoRESTAPIKey - Release가 없습니다!!"))
    }
}
