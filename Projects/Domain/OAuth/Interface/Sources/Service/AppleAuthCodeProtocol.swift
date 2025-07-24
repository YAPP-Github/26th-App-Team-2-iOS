//
//  AppleLogInService.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation
import Core


public protocol AppleAuthCodeProtocol {
    func fetchAuthCode() async throws -> String
}

public final class AppleAuthCodeService: NSObject {

    public var identityContinuation: AsyncStream<Result<String, AuthError>>.Continuation?
    
    public static func make() -> AppleAuthCodeService {
        AppleAuthCodeService()
    }

    override init() {
        super.init()
    }
}
