//
//  JSONCodable.swift
//  SharedUtil
//
//  Created by Derrick kim on 7/23/25.
//

import Foundation

public protocol JSONCodable: JSONDecodable, JSONEncodable {}

public protocol JSONDecodable: Decodable {}

public extension JSONDecodable {

    init?(from data: Data) {
        guard let value = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = value
    }

}

public protocol JSONEncodable: Encodable {}

public extension JSONEncodable {
    
    func jsonData() -> Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }
}
