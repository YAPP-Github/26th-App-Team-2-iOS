//
//  AuthEndPoint.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import Foundation

public extension BrakeRouter {
    enum AuthEndPoint<Response: Decodable> : HTTPNetworkProtocol {
        
        public typealias Item = Response
        
        case refresh(AuthRefreshRequest)
        case logIn(AuthLogInRequest)
        
        public var path: String {
            switch self {
            case .refresh:
                return "/auth/refresh"
            case .logIn:
                return "/auth/login"
            }
        }
        
        public var httpMethod: HTTPMethod {
            switch self {
            case .refresh, .logIn: .post
            }
        }
        
        public var queryParameters: Encodable? {
            switch self {
            case .refresh, .logIn: nil
            }
        }
        
        public var bodyParameters: Encodable? {
            switch self {
            case .refresh(let requestDTO): requestDTO
            case .logIn(let requestDTO): requestDTO
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
