//
//  MemberStateStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation


public protocol MemberStateStorageProtocol {
    func get() -> MemberStateType?
    func save(memberState: MemberStateType) throws
    
}


public final class UserDefaultsMemberStateStorage {
    public init() { }
   
}
