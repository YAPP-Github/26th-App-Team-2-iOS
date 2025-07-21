//
//  BrakeResponseDTO.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import Foundation

public struct BrakeResponseDTO<ResponseItem: Decodable>: Decodable {
    public let code: Int
    public let data: ResponseItem
    
    public init(code: Int, data: ResponseItem) {
        self.code = code
        self.data = data
    }
}
