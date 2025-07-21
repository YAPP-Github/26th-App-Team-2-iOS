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
    case decoding
    case authorization
    case server
    case internetConnection
    case noResponse
    case urlRequest(URLRequestError)
    case interceptorError(String)
    
    public var description: String {
        switch self {
        case .invalidURL: "Invalid URL"
        case .badRequest: "Bad Request From Client"
        case .unknown: "Unknown Error"
        case .decoding: "Decoding Error"
        case .authorization: "Authorization Error"
        case .server: "Server Error"
        case .internetConnection: "Internet Connection is unstable"
        case .noResponse: "No Response"
        case .urlRequest(let urlRequestError): urlRequestError.description
        case .interceptorError(let errorString): errorString
        }
    }
    
    public enum URLRequestError: Error {
        case makeURL
        case queryEncoding
        case bodyEncoding
        case urlComponent
        public var description: String {
            switch self {
            case .makeURL: "makeURLError"
            case .queryEncoding: "queryEncodingError"
            case .bodyEncoding: "bodyEncodingError"
            case .urlComponent: "urlComponentError"
            }
        }
    }
}
