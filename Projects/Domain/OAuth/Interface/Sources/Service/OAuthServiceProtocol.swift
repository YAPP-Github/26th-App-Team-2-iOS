//
//  OAuthServiceProtocol.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/22/25.
//

import Foundation

public protocol OAuthServiceProtocol {
    func login() async throws -> OAuthType
}
