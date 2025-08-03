//
//  MemberEndPoint.swift
//  CoreNetwork
//
//  Created by Greem on 7/26/25.
//

import Foundation

public extension BrakeRouter {
    enum MemberEndPoint<Response: Decodable> : HTTPNetworkProtocol {
        
        public typealias Item = Response
        
        case setName(SetMemberNameRequest)
        case getInfo
        case delete
        public var path: String { "/members/me" }
        
        public var httpMethod: HTTPMethod {
            switch self {
            case .setName: .patch
            case .getInfo: .get
            case .delete: .delete
            }
        }
        
        public var queryParameters: Encodable? {
            nil
        }
        
        public var bodyParameters: Encodable? {
            switch self {
            case .setName(let value): return value
            default: return nil
            }
        }
        
        public var headers: [String : String]? {
            var defaultHeader = ["Content-Type": "application/json"]
            switch self {
            case .delete: return nil
            default: return defaultHeader
            }
        }
    }
}
