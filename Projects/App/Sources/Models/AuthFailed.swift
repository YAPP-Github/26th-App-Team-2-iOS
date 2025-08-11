//
//  AuthFailed.swift
//  Brake
//
//  Created by Greem on 8/12/25.
//

import Foundation

enum AuthFailed: String, Identifiable {
    var id: String { self.rawValue }
    case screenTime
    case notification
    case both
}
