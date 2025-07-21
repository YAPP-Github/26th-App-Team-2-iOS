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
    
    public init(baseURL: String?, prefix: String?) {
        self.baseURL = baseURL
        self.prefix = prefix
    }
}
