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
    
    case urlRequest(URLRequestError)
    
    public var description: String {
        switch self {
        case .invalidURL: "Invalid URL"
        case .badRequest: "Bad Request From Client"
        case .unknown: "Unknown Error"
        case .urlRequest(let urlRequestError):
            urlRequestError.description
        }
    }
    
    public enum URLRequestError: Error {
        case makeURL
        case queryEncoding
        case bodyEncoding
        case urlComponent
        var description: String {
            switch self {
            case .makeURL: "makeURLError"
            case .queryEncoding: "queryEncodingError"
            case .bodyEncoding: "bodyEncodingError"
            case .urlComponent: "urlComponentError"
            }
        }
    }
}
