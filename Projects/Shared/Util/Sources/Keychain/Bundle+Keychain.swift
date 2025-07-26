//
//  Bundle+Keychain.swift
//  SharedUtil
//
//  Created by Derrick kim on 7/5/25.
//

import Foundation

public extension Bundle {
    var accessTokenKey: String? {
        return self.object(forInfoDictionaryKey: "ACCESS_TOKEN_KEY") as? String
    }
    
    var refreshTokenKey: String? {
        return self.object(forInfoDictionaryKey: "REFRESH_TOKEN_KEY") as? String
    }
    
}
