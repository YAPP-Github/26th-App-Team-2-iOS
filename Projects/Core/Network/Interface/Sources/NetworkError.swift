//
//  NetworkError.swift
//  CoreNetworkInterface
//
//  Created by Greem on 6/22/25.
//

import Foundation

public enum NetworkError: Error {
    
    case invalidURL
    case badRequest
    case unknown
    
    var description: String {
        switch self {
        case .invalidURL: "Invalid URL"
        case .badRequest: "Bad Request From Client"
        case .unknown: "Unknown Error"
        }
    }
}
