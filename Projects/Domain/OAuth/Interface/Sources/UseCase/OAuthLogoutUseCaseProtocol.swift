//
//  OAuthLogoutUseCaseProtocol.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 8/2/25.
//

import Foundation

public protocol OAuthLogoutUseCaseProtocol {
    func execute() async throws
}
