//
//  TokenKeyHolderError.swift
//  CoreLocalStorage
//
//  Created by Greem on 7/21/25.
//

import Foundation


public enum TokenKeyHolderError: LocalizedError {
    case refreshTokenKeyMissing
    case accessTokenKeyMissing
    
    public var errorDescription: String? {
        switch self {
        case .refreshTokenKeyMissing: "리프레시 토큰 키가 없습니다."
        case .accessTokenKeyMissing: "엑세스 토큰 키가 없습니다."
        }
    }
    
    public var errorMessage: String {
        return errorDescription ?? "unknown error"
    }
}
