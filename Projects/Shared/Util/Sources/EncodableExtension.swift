//
//  EncodableExtension.swift
//  SharedUtil
//
//  Created by Greem on 6/22/25.
//

import Foundation
import SharedUtilInterface

public extension Encodable {
    func toDictionary() throws -> [String : Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        return jsonObject as? [String : Any]
    }
}
