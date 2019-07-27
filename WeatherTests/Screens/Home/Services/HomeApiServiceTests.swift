//
//  HomeApiServiceTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class HomeApiServiceTests: XCTestCase {
    var sut: HomeApiService!
    var api: SearchApiRequestMock!
    
    override func setUp() {
        api = SearchApiRequestMock()
        sut = HomeApiService(searchApi: api)
    }
    
    func testHomeApiServiceRequest() {
        // given
        let model = SearchApiResponse(results: [SearchApiResponseResult(areaName: "Seoul", country: "South Korea")])
        
        // when
        var actual: HomeSearchedKeyword!
        let expectation = XCTestExpectation(description: #function)
        sut.search(with: "keyword") { (result) in
            actual = result
            expectation.fulfill()
        }
        
        api.completion?(.success(model))
        
        // then
        let expected = HomeSearchedKeyword(titles: ["Seoul"])
        XCTAssertEqual(expected, actual!)
    }
    
    func testHomeApiServiceRequestWithNilModel() {
        // given
        let model = SearchApiResponse(results: nil)
        
        // when
        var actual: HomeSearchedKeyword!
        let expectation = XCTestExpectation(description: #function)
        sut.search(with: "keyword") { (result) in
            actual = result
            expectation.fulfill()
        }
        
        api.completion?(.success(model))
        
        // then
        let expected = HomeSearchedKeyword(titles: [String]())
        XCTAssertEqual(expected, actual!)
    }
    
    func testHomeApiServiceRequestReturnsError() {
        // given
        let error = ApiError.unabletoaccess
        
        // when
        var actual: HomeSearchedKeyword!
        let expectation = XCTestExpectation(description: #function)
        sut.search(with: "keyword") { (result) in
            actual = result
            expectation.fulfill()
        }
        
        api.completion?(.failure(error))
        
        // then
        let expected = HomeSearchedKeyword(titles: [String]())
        XCTAssertEqual(expected, actual!)
    }
    
    func testHomeApiServiceCancelRequests() {
        // given
        api.nextTaskIdentifier = 1
        sut.search(with: "keyword") { _ in }
        api.nextTaskIdentifier = 2
        sut.search(with: "keyword") { _ in }
        api.nextTaskIdentifier = 3
        sut.search(with: "keyword") { _ in }
        
        // when
        sut.cancelAllPreviousSearch()
        
        // then
        let actual = api.cancelled.sorted()
        let expected = [1, 2, 3]
        XCTAssertEqual(expected, actual)
    }
}
