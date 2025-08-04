//
//  FetchUserNicknameUseCaseProtocol.swift
//  DomainUserInterface
//
//  Created by Derrick kim on 8/2/25.
//

import Foundation

public protocol FetchUserNicknameUseCaseProtocol {
    func execute() async throws -> String
}

