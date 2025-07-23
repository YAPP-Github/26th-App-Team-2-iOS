//
//  JWTDecoder.swift
//  CoreLocalStorage
//
//  Created by Greem on 7/21/25.
//

import SharedUtil
import Foundation

public struct JWTDecoder {
    public init() { }
    
    /// base64URL 형식의 데이터를 baseURL 형식으로 변경한 뒤, 이 값을 Swift의 Data 타입으로 변환합니다.
    private func base64UrlDecode(_ base64Url: String) -> Data? {
        var base64 = base64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let padLength = (4 - base64.count % 4) % 4
        base64.append(contentsOf: repeatElement("=", count: padLength))
        
        return Data(base64Encoded: base64)
    }
    
    public func decode<Token: TokenType>(
        _ jwtTokenString: String,
        as tokenType: Token.Type
    ) throws -> Token {
        let segments = jwtTokenString.split(separator: ".")
        guard segments.count == 3 else {
            throw JWTError.invalidFormat
        }
        
        /// jwtToken의 프로토콜(형식)에 따라 payload 세그먼트를 분리한다.
        /// payload 세그먼트는 base64URL 프로토콜(형식)을 따르기 때문에, 이를 Swift Data 타입으로 변환한다.
        let payloadSegment = String(segments[1])
        guard let payloadData = base64UrlDecode(payloadSegment) else {
            throw JWTError.decodePayloadSegmentError
        }
        
        /// Swift Data 타입으로 변환한 payload 값에서 expriation 값을 추출한 후, 프로젝트에서 정의한 Token 타입으로 변환한다.
        guard let json = try? JSONSerialization.jsonObject(with: payloadData, options: []),
              let payload = json as? [String: Any] else {
            throw JWTError.parsePayloadJSONError
        }
        
        let token = Token(
            token: jwtTokenString
        )
        
        return token
    }
}
