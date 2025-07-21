//
//  RequestableExtensions.swift
//  CoreNetwork
//
//  Created by Greem on 6/22/25.
//

import Foundation
import SharedUtil

public struct URLComponentConfig {
    public let baseURL: String?
    public let prefix: String?
    
    /// 프로젝트 서버 URL을 사용하는 URLComponent 생성자
    public static let `default` = URLComponentConfig(
        baseURL: Bundle.main.baseServerURLString,
        prefix: "/v1"
    )
    
    public init(baseURL: String? = Bundle.main.baseServerURLString, prefix: String? = nil) {
        self.baseURL = baseURL
        self.prefix = prefix
    }
    
}
