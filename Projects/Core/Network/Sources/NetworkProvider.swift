//
//  NetworkProvider.swift
//  CoreNetwork
//
//  Created by Greem on 6/22/25.
//

import Foundation
import CoreNetworkInterface
import SharedUtil

extension NetworkProvider: @retroactive NetworkProviderProtocol {
    
    /// 이 메서드는 생성자의 인자로 받은 requestInterceptor를 통해 인증 갱신, 재시도 등 부가 처리를 자동으로 수행합니다.
    /// 별도의 인증/재시도 처리가 필요하지 않습니다.
    public func request<Request, Item>(
        _ endpoint: Request
    ) async throws -> Item where Request : HTTPNetworkProtocol, Item : Decodable, Item == Request.Item {
        try await self.requestWithLimitCount(endpoint, limitCount: 0)
    }
    
    private func requestWithLimitCount<Request, Item>(
        _ endpoint: Request,
        limitCount: Int
    ) async throws -> Item where Request : HTTPNetworkProtocol, Item : Decodable, Item == Request.Item {
        
        guard limitCount < 5 else {
            throw NetworkError.interceptorError("limitCount 5번 이상으로 재귀 호출되었습니다.")
        }
        
        do {
            let urlRequest: URLRequest = try endpoint.makeURLRequest(config: self.urlComponentConfig)
            let (data, response) = try await self.networkSession.dataTask(for: urlRequest)
            
            try response.validateResponse()
            
            // EmptyData 타입인 경우 특별 처리
            if Item.self == EmptyData.self {
                // 빈 데이터이거나 유효하지 않은 JSON인 경우 EmptyData로 처리
                if data.isEmpty { return EmptyData() as! Item }
                
                // JSON 파싱을 시도해보고 실패하면 EmptyData 반환
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data)
                    // 빈 객체나 배열인 경우
                    if let dict = jsonObject as? [String: Any], dict.isEmpty {
                        return EmptyData() as! Item
                    }
                    if let array = jsonObject as? [Any], array.isEmpty {
                        return EmptyData() as! Item
                    }
                } catch {
                    return EmptyData() as! Item
                }
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(Item.self, from: data) else {
                throw NetworkError.decoding
            }
            
            return decodedResponse
        }
        catch NetworkError.authorization { /// 인증 실패 에러 발생
            let retryResult = try await networkSession.retryInterceptor()
            switch retryResult {
            case .retry:
                return try await self.requestWithLimitCount(endpoint, limitCount: limitCount + 1)
            case .doNotRetry: throw NetworkError.interceptorError("기간이 만료되었습니다!!")
            case .doNotRetryWithError(let error):
                throw error
            }
        }
        catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.internetConnection
            case .timedOut:
                throw NetworkError.timeOut
            default: throw NetworkError.unknown
            }
        } catch {
            throw error
        }
    }
}

