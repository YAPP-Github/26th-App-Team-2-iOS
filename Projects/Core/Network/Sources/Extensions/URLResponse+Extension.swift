//
//  URLResponseExtensions.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import Foundation
import CoreNetworkInterface

extension URLResponse {
    func validateResponse() throws {
        guard let response = self as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }

        switch response.statusCode {
        case 200...299: return
        case 401: throw NetworkError.authorization
        case 400...499: throw NetworkError.badRequest
        case 500...599 : throw NetworkError.server
        default: throw NetworkError.unknown
        }
    }
}
