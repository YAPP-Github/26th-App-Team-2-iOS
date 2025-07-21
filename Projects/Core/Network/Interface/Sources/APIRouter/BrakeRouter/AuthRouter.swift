//
//  Auth.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import Foundation

public extension BrakeRouter {
    enum AuthEndPoint<Response: Decodable> : HTTPNetworkProtocol {
        
        public typealias Item = Response
        
        case refresh(AuthRefreshRequest)
        
        public var path: String {
            switch self {
            case .refresh:
                return "/auth/refresh"
            }
        }
        
        public var httpMethod: HTTPMethod {
            switch self {
            case .refresh: .post
            }
        }
        
        public var queryParameters: (any Encodable)? {
            switch self {
            case .refresh: nil
            }
        }
        
        public var bodyParameters: (any Encodable)? {
            switch self {
            case .refresh(let request): try? JSONEncoder().encode(request)
            }
        }
        
        public var headers: [String : String]? {
            var defaultHeader = ["Content-Type": "application/json"]
            switch self {
            default: return defaultHeader
            }
        }
        
    }
}
