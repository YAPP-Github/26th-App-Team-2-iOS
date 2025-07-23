//
//  AppleOAuthError.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation

public enum AppleOAuthError: Error {
    case tokenMissing
    case unknown
    case canceled
    case invalidResponse
    case notHandled
    case failed
    case notInteractive
    case otherError(Error)
}
