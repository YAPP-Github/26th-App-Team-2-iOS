//
//  BrakeResponseDTO.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import Foundation

public struct BrakeResponse<ResponseItem: Decodable>: Decodable {
    public let status: Int
    public let data: ResponseItem
    
    public init(status: Int, data: ResponseItem) {
        self.status = status
        self.data = data
    }
}

public struct BrakeServerErrorResponse: Decodable {
    public let status: Int
    public let message: String
}
