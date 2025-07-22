//
//  JWTDecoderTest.swift
//  CoreLocalStorageTests
//
//  Created by Greem on 7/21/25.
//

import Foundation
import CoreLocalStorageInterface
import Testing

struct JWTDecoderTest {
    @Test
    func testDecodeValidJWT() async throws {
        // given
        let expectedExpTimestamp: Double = 1234567890
        let expectedExpDate: Date = Date(timeIntervalSince1970: TimeInterval(expectedExpTimestamp))
        let header: String = "{\"alg\":\"HS256\",\"typ\":\"JWT\"}"
        let payload: String = "{\"exp\":\(expectedExpTimestamp)}"
        
        func base64url(_ str: String) -> String {
            Data(str.utf8)
                .base64EncodedString()
                .replacingOccurrences(of: "+", with: "-")
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "=", with: "")
        }
        
        let jwt = [
            base64url(header),
            base64url(payload),
            "signature"
        ].joined(separator: ".")
        
        let decoder = JWTDecoder()
        
        // when
        let accessToken = try decoder.decode(jwt, as: AccessToken.self)
        
        // then
        #expect(accessToken.expiration.timeIntervalSince1970 == expectedExpDate.timeIntervalSince1970)
    }
    
    @Test
    func testDecodeInvalidJWT() {
        // given
        let invalidJWT = "invalid.jwt.token"
        let decoder = JWTDecoder()
        
        // when
        let token = try? decoder.decode(invalidJWT, as: AccessToken.self)
        
        // then
        #expect(token == nil)
    }
}

