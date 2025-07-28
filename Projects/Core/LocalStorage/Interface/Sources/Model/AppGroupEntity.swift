//
//  AppGroupEntity.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls
import SwiftData

@Model
public final class AppGroupEntity {
    @Attribute(.unique) public var groupID: Int
    public var name: String
    public var selectionData: Data
    
    public init(groupID: Int, name: String, selectionData: Data) {
        self.groupID = groupID
        self.name = name
        self.selectionData = selectionData
    }
}
