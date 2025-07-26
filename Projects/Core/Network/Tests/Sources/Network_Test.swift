//
//  Network_Test.swift
//  CoreNetworkTests
//
//  Created by Greem on 6/22/25.
//

import XCTest
import CoreNetworkInterface
import CoreNetworkTesting
import CoreNetwork


final class Network_Test: XCTestCase {
    
    var sut: NetworkProvider.Type!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = NetworkProvider.self
    }
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func test_request_네트워크_실제_통신() async {
        #function)
        
        let networkProvider: NetworkProviderProtocol = NetworkProvider(
            networkSession: NetworkSession(),
            urlComponentConfig: .init(
                baseURL: "https://jsonplaceholder.typicode.com", /// 여기서 직접 주입 가능해짐!!
                prefix: nil
            )
        )
        
        let endpoint = Endpoint<TempTestResponse>(
            path: "/posts/1",
            httpMethod: .get,
            queryParameters: nil,
            bodyParameters: nil,
            headers: [:]
        )
            do {
                /// base path가
                /// guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? 로 강제되는것 같은데...
                let val: TempTestResponse = try await networkProvider.request(endpoint)
                "테스트 결과 response: ", val)
            } catch let error as NetworkError {
                "테스트 결과 network 에러: ", error.description)
            } catch {
                "테스트 결과 unknwon 에러: ", error.localizedDescription)
            }
    }
    
    // MARK: - Endpoint Tests
    
    func test_Endpoint_초기화가_정상적으로_되는지_확인() {
        // Given
        let path = "/test"
        let httpMethod = HTTPMethod.get
        let queryParameters = TestQueryParameters(name: "test", age: 25)
        let bodyParameters = TestBodyParameters(title: "Test Title", content: "Test Content")
        let headers = ["Authorization": "Bearer token"]
        
        // When
        let endpoint = Endpoint<TestResponse>(
            path: path,
            httpMethod: httpMethod,
            queryParameters: queryParameters,
            bodyParameters: bodyParameters,
            headers: headers
        )
        
        // Then
        XCTAssertEqual(endpoint.path, path)
        XCTAssertEqual(endpoint.httpMethod, httpMethod)
        XCTAssertNotNil(endpoint.queryParameters)
        XCTAssertNotNil(endpoint.bodyParameters)
        XCTAssertNotNil(endpoint.headers)
        XCTAssertEqual(endpoint.headers?["Authorization"], "Bearer token")
    }
    
    func test_Endpoint_기본값으로_초기화가_정상적으로_되는지_확인() {
        // Given & When
        let endpoint = Endpoint<TestResponse>(
            path: "/test",
            httpMethod: .post
        )
        
        // Then
        XCTAssertEqual(endpoint.path, "/test")
        XCTAssertEqual(endpoint.httpMethod, .post)
        XCTAssertNil(endpoint.queryParameters)
        XCTAssertNil(endpoint.bodyParameters)
        XCTAssertNil(endpoint.headers)
    }
    
    // MARK: - HTTPMethod Tests
    
    func test_HTTPMethod_모든_케이스가_올바른_값을_가지고_있는지_확인() {
        // Then
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
        XCTAssertEqual(HTTPMethod.post.rawValue, "POST")
        XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
        XCTAssertEqual(HTTPMethod.delete.rawValue, "DELETE")
    }
    
    // MARK: - NetworkError Tests
    
    func test_NetworkError_모든_케이스의_설명이_올바른지_확인() {
        // Then
        XCTAssertEqual(NetworkError.invalidURL.description, "Invalid URL")
        XCTAssertEqual(NetworkError.badRequest.description, "Bad Request From Client")
        XCTAssertEqual(NetworkError.unknown.description, "Unknown Error")
        XCTAssertEqual(NetworkError.decoding.description, "Decoding Error")
        XCTAssertEqual(NetworkError.authorization.description, "Authorization Error")
        XCTAssertEqual(NetworkError.server.description, "Server Error")
        XCTAssertEqual(NetworkError.internetConnection.description, "Internet Connection is unstable")
        XCTAssertEqual(NetworkError.noResponse.description, "No Response")
    }
    
    func test_NetworkError_URLRequestError_모든_케이스의_설명이_올바른지_확인() {
        // Then
        XCTAssertEqual(NetworkError.URLRequestError.makeURL.description, "makeURLError")
        XCTAssertEqual(NetworkError.URLRequestError.queryEncoding.description, "queryEncodingError")
        XCTAssertEqual(NetworkError.URLRequestError.bodyEncoding.description, "bodyEncodingError")
        XCTAssertEqual(NetworkError.URLRequestError.urlComponent.description, "urlComponentError")
    }
    
    // MARK: - Requestable Protocol Tests
    
    func test_Endpoint이_Requestable_프로토콜을_준수하는지_확인() {
        // Given
        let endpoint = Endpoint<TestResponse>(
            path: "/test",
            httpMethod: .get,
            queryParameters: TestQueryParameters(name: "test", age: 25),
            bodyParameters: TestBodyParameters(title: "Test", content: "Content"),
            headers: ["Test": "Header"]
        )
        
        // Then
        XCTAssertEqual(endpoint.path, "/test")
        XCTAssertEqual(endpoint.httpMethod, .get)
        XCTAssertNotNil(endpoint.queryParameters)
        XCTAssertNotNil(endpoint.bodyParameters)
        XCTAssertNotNil(endpoint.headers)
    }
    
}

// MARK: - Test Models

private struct TestQueryParameters: Encodable {
    let name: String
    let age: Int
}

private struct TestBodyParameters: Encodable {
    let title: String
    let content: String
}

private struct TestResponse: Decodable {
    let id: Int
    let name: String
    let message: String
}
