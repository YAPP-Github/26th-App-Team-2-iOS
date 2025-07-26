//
//  BundleKeyExtensions.swift
//  SharedUtil
//
//  Created by Greem on 7/24/25.
//

import Foundation

public extension Bundle {
    var baseServerString: String? {
        self.object(forInfoDictionaryKey: "BASE_SERVER_URL") as? String
    }
}
