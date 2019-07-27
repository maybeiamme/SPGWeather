//
//  SearchApiRequestTest.swift
//  WeatherTests
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class SearchApiRequestTest: XCTestCase {
    
    var sut: SearchApiRequest!
    var networkManager: NetworkManagerMock!
    var decoder: JSONDecoderMock!

    override func setUp() {
        networkManager = NetworkManagerMock()
        decoder = JSONDecoderMock()
        sut = SearchApiRequest(networkManager: networkManager, decoder: decoder)
    }

    func testSearchApiRequestHasProperUrl() {
        // given
        
        // when
        let _ = sut.request(with: "query") { result in
        }
        
        let expected = "https://api.worldweatheronline.com/premium/v1/search.ashx?q=query&key=0434896a6994489cb6905901192607&format=json"
        let actual = networkManager.request!.url!.absoluteString
        XCTAssertEqual(expected, actual)
    }
    
    func testSearchApiReceivesSuccess() {
        // given
        decoder.decoded = "search_success_seoul".stub()
        let query = "Seoul"
        
        // when
        var actual: SearchApiResponse!
        let expectation = XCTestExpectation(description: #function)
        let _ = sut.request(with: query) { result in
            switch result {
            case .success(let response):
                actual = response
                expectation.fulfill()
            default:
                break
            }
        }
        
        networkManager.completion!(Result<Data, NetworkError>.success("search_success_seoul".stub()))
        
        // then
        wait(for: [expectation], timeout: 0.1)
        let expected = SearchApiResponse(results: [SearchApiResponseResult(areaName: "Seoul", country: "South Korea")])
        XCTAssertEqual(actual, expected)
    }
    
    func testSearchApiReceivesEmptyArrayResponse() {
        // given
        decoder.decoded = "search_success_emptyresult".stub()
        let query = "Seoul"
        
        // when
        var actual: SearchApiResponse!
        let expectation = XCTestExpectation(description: #function)
        let _ = sut.request(with: query) { result in
            switch result {
            case .success(let response):
                actual = response
                expectation.fulfill()
            default:
                break
            }
        }
        
        networkManager.completion!(Result<Data, NetworkError>.success("search_success_emptyresult".stub()))
        
        // then
        wait(for: [expectation], timeout: 0.1)
        let expected = SearchApiResponse(results: [SearchApiResponseResult]())
        XCTAssertEqual(actual, expected)
    }
    
    func testSearchApiReceivesParseError() {
        // given
        decoder.decoded = nil
        let query = "Seoul"
        
        // when
        var actual: ApiError!
        let expectation = XCTestExpectation(description: #function)
        let _ = sut.request(with: query) { result in
            switch result {
            case .failure(let error):
                actual = error
                expectation.fulfill()
            default:
                break
            }
        }
        
        networkManager.completion!(Result<Data, NetworkError>.success("search_success_emptyresult".stub()))
        
        // then
        wait(for: [expectation], timeout: 0.1)
        let expected = ApiError.parseerror
        XCTAssertEqual(actual, expected)
    }
    
    func testSearchApiReceivesUnableToAccessError() {
        // given
        decoder.decoded = nil
        let query = "Seoul"
        
        // when
        var actual: ApiError!
        let expectation = XCTestExpectation(description: #function)
        let _ = sut.request(with: query) { result in
            switch result {
            case .failure(let error):
                actual = error
                expectation.fulfill()
            default:
                break
            }
        }
        
        networkManager.completion!(Result<Data, NetworkError>.failure(NetworkError.networkerror))
        
        // then
        wait(for: [expectation], timeout: 0.1)
        let expected = ApiError.unabletoaccess
        XCTAssertEqual(actual, expected)
    }
    
    func testSearchApiReceivesSystemError() {
        // given
        decoder.decoded = nil
        let query = "Seoul"
        
        // when
        var actual: ApiError!
        let expectation = XCTestExpectation(description: #function)
        let _ = sut.request(with: query) { result in
            switch result {
            case .failure(let error):
                actual = error
                expectation.fulfill()
            default:
                break
            }
        }
        sut = nil
        networkManager.completion!(Result<Data, NetworkError>.failure(NetworkError.networkerror))
        
        // then
        wait(for: [expectation], timeout: 0.1)
        let expected = ApiError.systemerror
        XCTAssertEqual(actual, expected)
    }
    
    func testSearchApiCancelRequest() {
        // given
        networkManager.currentTaskIdenfier = 10
        let _ = sut.request(with: "Query") { result in }
        
        // when
        sut.cancel(identifier: 10)
        
        // then
        let expected = 10
        let actual = networkManager.removedTaskIdentifier!
        XCTAssertEqual(actual, expected)
    }
}
