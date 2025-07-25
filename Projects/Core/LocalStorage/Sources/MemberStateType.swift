//
//  MemberStateType.swift
//  CoreLocalStorage
//
//  Created by Greem on 7/25/25.
//

import Foundation
import CoreLocalStorageInterface

extension MemberStateType {
    
    private static let activeRawValue: String = "ACTIVE"
    private static let holdRawValue: String = "HOLD"
    
    public init?(rawValue: String) {
        switch rawValue {
        case Self.activeRawValue: self = .active
        case Self.holdRawValue: self = .hold
        default: return nil
        }
    }
    
    public var value: String {
        switch self {
        case .active: Self.activeRawValue
        case .hold: Self.holdRawValue
        }
    }
}
