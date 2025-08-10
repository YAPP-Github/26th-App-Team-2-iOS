//
//  AppGroupStorageError.swift
//  CoreLocalStorageTests
//
//  Created by Greem on 7/28/25.
//

import Foundation

public enum AppGroupStorageError: LocalizedError {
    case initFailed
    case entityNotFound
    case saveFailed
    case updateFailed
    case upsertFailed
    case entityFetchingError
    case deleteFailed
    
    public var errorDescription: String? {
        switch self {
        case .initFailed: return "AppGroupStorage 생성을 실패했습니다"
        case .entityNotFound:
            return "엔티티를 찾을 수 없습니다."
        case .saveFailed:
            return "엔티티 저장에 실패했습니다."
        case .updateFailed:
            return "엔티티 업데이트에 실패했습니다."
        case .upsertFailed:
            return "엔티티 upsert(삽입 또는 갱신)에 실패했습니다."
        case .entityFetchingError:
            return "엔티티를 가져오는 중 오류가 발생했습니다."
        case .deleteFailed:
            return "엔티티 삭제에 실패했습니다."
        }
    }
    
    public var errorMessage: String {
        return errorDescription ?? "unknown error"
    }
}
