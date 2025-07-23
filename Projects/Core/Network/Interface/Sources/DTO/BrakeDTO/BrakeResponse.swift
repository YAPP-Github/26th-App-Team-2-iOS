//
//  BrakeResponseDTO.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import Foundation

public struct BrakeResponse<ResponseItem: Decodable>: Decodable {
    public let code: Int
    public let data: ResponseItem
    
    public init(code: Int, data: ResponseItem) {
        self.code = code
        self.data = data
    }
}

public struct BrakeServerErrorResponse: Decodable {
    public let code: Int
    public let message: String
}
