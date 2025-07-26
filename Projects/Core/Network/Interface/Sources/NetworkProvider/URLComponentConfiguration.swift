//
//  RequestableExtensions.swift
//  CoreNetwork
//
//  Created by Greem on 6/22/25.
//

import Foundation
import SharedUtil

public struct URLComponentConfiguration {
    public let baseURL: String?
    public let prefix: String?
    
    /// Brake 서버 URL을 사용하는 URLComponent 생성자
    public static let `default` = URLComponentConfiguration(
        baseURL: Bundle.main.baseServerString,
        prefix: "/v1"
    )
    
    public init(
        baseURL: String? = Bundle.main.baseServerString,
        prefix: String? = nil
    ) {
        self.baseURL = baseURL
        self.prefix = prefix
    }
    
}
