//
//  NotificationAuthorizationResult.swift
//  DomainShared
//
//  Created by Greem on 7/28/25.
//

import Foundation

public enum NotificationAuthorizationResult: Equatable {
    case approved
    case denied
    case userRestricted
    case unknownError
}
