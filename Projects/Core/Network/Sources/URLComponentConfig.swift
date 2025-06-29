//
//  RequestableExtensions.swift
//  CoreNetwork
//
//  Created by Greem on 6/22/25.
//

import Foundation
import CoreNetworkInterface
import SharedUtil


public struct URLComponentConfig {
    public let baseURL: String?
    public let prefix: String?
    
    public init(baseURL: String?, prefix: String?) {
        self.baseURL = baseURL
        self.prefix = prefix
    }
    
    func makeURLComponents(path: String) throws -> URLComponents? {
        guard let baseURL = self.baseURL, let prefix = self.prefix else {
            throw NetworkError.urlRequest(.makeURL)
        }
        return  URLComponents(string: baseURL + prefix + path)
    }
    
    func getQueryParameters(queryParameters: Encodable?) throws -> [URLQueryItem]? {
        guard let queryParameters else {
            return nil
        }
        
        guard let queryDictionary = try? queryParameters.toDictionary() else {
            throw NetworkError.urlRequest(.queryEncoding)
        }
        
        var queryItemList : [URLQueryItem] = []
        
        queryDictionary.forEach { (key, value) in
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItemList.append(queryItem)
        }
        
        if queryItemList.isEmpty {
            return nil
        }
        
        return queryItemList
    }
    
    func getBodyParameters(bodyParameters: Encodable?) throws -> Data? {
        guard let bodyParameters else {
            return nil
        }
        
        guard let bodyDictionary = try? bodyParameters.toDictionary() else {
            throw NetworkError.urlRequest(.bodyEncoding)
        }
        
        guard let encodedBody = try? JSONSerialization.data(withJSONObject: bodyDictionary) else {
            throw NetworkError.urlRequest(.bodyEncoding)
        }
        
        return encodedBody
    }
}
