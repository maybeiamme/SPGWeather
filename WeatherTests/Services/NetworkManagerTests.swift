//
//  NetworkManagerTests.swift
//  WeatherTests
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    var session: URLSessionMock!
    
    override func setUp() {
        session = URLSessionMock()
        sut = NetworkManager(session: session)
    }
    
    func testNetworkManagerReturnsSuccess() {
        // given
        let request = URLRequest(url: URL(string: "http://anyurl")!)
        let response = HTTPURLResponse(url: URL(string: "http://anyurl")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let expectation = XCTestExpectation(description: #function)
        let stub = "search_success".stub()
        
        var actual: String!
        let expected = String(data: stub, encoding: .utf8)
        
        // when
        let _ = sut.request(with: request) { result in
            switch result {
            case .success(let data):
                actual = String(data: data, encoding: .utf8)
                expectation.fulfill()
            case .failure(_):
                break
            }
        }
        
        session.completionHandler?(stub, response, nil)
        wait(for: [expectation], timeout: 0.1)
        
        // then
        XCTAssertEqual(actual, expected)
    }

    func testNetworkManagerReturnsNil() {
        // given
        let request = URLRequest(url: URL(string: "http://anyurl")!)
        let expectation = XCTestExpectation(description: #function)
        
        var actual: NetworkError!
        let expected = NetworkError.networkerror
        
        // when
        let _ = sut.request(with: request) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                expectation.fulfill()
                actual = error
            }
        }
        
        session.completionHandler?(nil, nil, nil)
        wait(for: [expectation], timeout: 0.1)
        
        // then
        XCTAssertEqual(actual, expected)
    }

    func testNetworkManagerWithHttpStatusCodeIsNot200AndError() {
        // given
        let request = URLRequest(url: URL(string: "http://anyurl")!)
        let response = HTTPURLResponse(url: URL(string: "http://anyurl")!, statusCode: 403, httpVersion: nil, headerFields: nil)
        let expectation = XCTestExpectation(description: #function)
        let stub = "search_success".stub()
        
        var actual: NetworkError!
        let expected = NetworkError.networkerror
        
        // when
        let _ = sut.request(with: request) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                expectation.fulfill()
                actual = error
            }
        }
        
        session.completionHandler?(stub, response, nil)
        wait(for: [expectation], timeout: 0.1)
        
        // then
        XCTAssertEqual(actual, expected)
    }
    
    func testNetworkManagerTaskCancel() {
        // given
        session.desiredTaskIdentifier = 100
        let request = URLRequest(url: URL(string: "http://anyurl")!)
        let taskIdentifier = sut.request(with: request) { result in
            
        }
        
        // when
        sut.cancel(identifier: taskIdentifier)
        
        // then
        let actual = session.sessions[taskIdentifier]!._isCanceled!
        let expected = true
        XCTAssertEqual(actual, expected)
    }
}
