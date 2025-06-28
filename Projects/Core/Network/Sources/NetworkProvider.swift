//
//  NetworkProvider.swift
//  CoreNetwork
//
//  Created by Greem on 6/22/25.
//

import Foundation
import CoreNetworkInterface
import SharedUtil

public class NetworkProvider: NetworkProviderable {
    public func request<Request, Item>(
        _ endpoint: Request
    ) async throws -> Item where Request : CoreNetworkInterface.Networkable, Item : Decodable, Item == Request.Item {
        do {
            /// 여기 코드가 extension이 맞을까?
            let urlRequest: URLRequest = try endpoint.makeURLRequest()
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            /// 여기 로거 만들고 대체할 필요 있음
            print(urlRequest)
            
            if let requestBodyJsonString = String(data: urlRequest.httpBody ?? .SubSequence(), encoding: .utf8) {
                /// 여기 로거 만들고 대체할 필요 있음
                print(requestBodyJsonString)
            }
            
            if let responseJsonString = String(data: data, encoding: .utf8) {
                /// 여기 로거 만들고 대체할 필요 있음
                print(responseJsonString)
            }
            
            if let emptyResponse = try JSONDecoder().decode(EmptyData.self, from: data) as? Item, data.isEmpty {
                return emptyResponse
            }
            print(response.statusCode)
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(Item.self, from: data) else {
                    throw NetworkError.decoding
                }
                return decodedResponse
            case 401 :
                throw NetworkError.authorization
            case 400...499:
                throw NetworkError.badRequest
            case 500...599 :
                throw NetworkError.server
            default:
                throw NetworkError.unknown
            }
            
        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.internetConnection
        }
    }
}
