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
        case logout

        public var path: String {
            switch self {
            case .refresh:
                return "/auth/refresh"
            case .logIn:
                return "/auth/login"
            case .logout:
                return "/auth/logout"
            }
        }
        
        public var httpMethod: HTTPMethod {
            switch self {
            case .refresh, .logIn, .logout: .post
            }
        }
        
        public var queryParameters: Encodable? {
            switch self {
            case .refresh, .logIn, .logout: nil
            }
        }
        
        public var bodyParameters: Encodable? {
            switch self {
            case .refresh(let requestDTO): requestDTO
            case .logIn(let requestDTO): requestDTO
            case .logout: nil
            }
        }
        
        public var headers: [String : String]? {
            let defaultHeader = ["Content-Type": "application/json"]
            switch self {
            default: return defaultHeader
            }
        }
    }
}
