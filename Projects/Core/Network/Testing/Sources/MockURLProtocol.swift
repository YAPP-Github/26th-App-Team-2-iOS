//
//  MockURLProtocol.swift
//  CoreNetworkInterface
//
//  Created by Greem on 7/21/25.
//

import Foundation

public class MockURLProtocol: URLProtocol {
    
    public static var requestHandler: ((URLRequest) async throws -> (Data, URLResponse))?
    
    private var loadingTask: Task<Void, Never>?
    
    public override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    public override func startLoading() {
        guard let handler = Self.requestHandler else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "MockURLProtocol", code: -1, userInfo: [NSLocalizedDescriptionKey: "No request handler set"]))
            return
        }
        
        loadingTask = Task {
            do {
                let (data, response) = try await handler(request)
                
                // 올바른 순서: response -> data -> finish
                client?.urlProtocol(
                    self,
                    didReceive: response,
                    cacheStoragePolicy: .notAllowed
                )
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
                
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
    
    public override func stopLoading() {
        loadingTask?.cancel()
        loadingTask = nil
    }
}
