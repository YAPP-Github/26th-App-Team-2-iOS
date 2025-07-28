//
//  AppGroup.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls

public struct AppGroup: Codable {
    public let name: String
    public let groupID: Int
    public let selections: FamilyActivitySelection
}
