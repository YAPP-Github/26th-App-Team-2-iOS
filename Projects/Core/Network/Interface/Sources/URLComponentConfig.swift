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
    
    /// 기본 URL 컴포넌트 생성자
    public static let `default` = URLComponentConfig(baseURL: Bundle.main.baseURLString, prefix: nil)
    
    public init(baseURL: String?, prefix: String?) {
        self.baseURL = baseURL
        self.prefix = prefix
    }
}
