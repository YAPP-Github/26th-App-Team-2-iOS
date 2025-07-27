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
        case logOut(accessToken: String)
        
        public var path: String {
            switch self {
            case .refresh:
                return "/auth/refresh"
            case .logIn:
                return "/auth/login"
            case .logOut:
                return "/auth/logout"
            }
        }
        
        public var httpMethod: HTTPMethod {
            switch self {
            case .refresh, .logIn, .logOut: .post
            }
        }
        
        public var queryParameters: Encodable? {
            switch self {
            case .refresh, .logIn, .logOut: nil
            }
        }
        
        public var bodyParameters: Encodable? {
            switch self {
            case .refresh(let requestDTO): requestDTO
            case .logIn(let requestDTO): requestDTO
            case .logOut(accessToken: let accessToken): ["accessToken": accessToken]
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
