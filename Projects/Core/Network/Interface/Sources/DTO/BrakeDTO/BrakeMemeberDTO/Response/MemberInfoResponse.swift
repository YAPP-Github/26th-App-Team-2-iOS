//
//  BrakeMemeberResponse.swift
//  CoreNetwork
//
//  Created by Greem on 7/26/25.
//

import Foundation

public struct MemberInfoResponse: Decodable {
    public let nickname: String
    public let state: String
    
    public init(nickname: String, state: String) {
        self.nickname = nickname
        self.state = state
    }
}
