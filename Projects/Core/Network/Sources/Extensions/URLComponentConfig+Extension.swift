//
//  URLComponentConfig+Extension.swift
//  CoreNetwork
//
//  Created by Greem on 6/29/25.
//

import CoreNetworkInterface
import Foundation

extension URLComponentConfiguration {

    func makeURLComponents(path: String) throws -> URLComponents? {
        guard let baseURL = self.baseURL else {
            throw NetworkError.urlRequest(.makeURL)
        }
        guard let prefix = self.prefix else {
            return URLComponents(string: baseURL + path)
        }
        return URLComponents(string: baseURL + prefix + path)
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

