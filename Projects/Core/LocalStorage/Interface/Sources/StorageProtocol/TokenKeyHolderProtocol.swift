//
//  TokenKeyHolder.swift
//  CoreLocalStorage
//
//  Created by Greem on 7/21/25.
//

import Foundation
import SharedUtil

public protocol TokenKeyHolderProtocol {
    func fetchAccessTokenKey() throws -> String
    func fetchRefreshTokenKey() throws -> String
}

public struct KeychainTokenKeyHolder { }
