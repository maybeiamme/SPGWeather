//
//  DetailApiServiceTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class DetailApiServiceTests: XCTestCase {
    var sut: DetailApiService!
    var api: WeatherApiRequestMock!
    
    override func setUp() {
        api = WeatherApiRequestMock()
        sut = DetailApiService(weatherApi: api)
    }
    
    func testDetailApiServiceRequest() {
        // given
        let model = WeatherApiResponse(currentCondition: WeatherApiCurrentCondition(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"))
        
        // when
        var actual: DetailEntity!
        let expectation = XCTestExpectation(description: #function)
        sut.request(with: "keyword") { (result) in
            actual = result
            expectation.fulfill()
        }
        
        api.completion?(.success(model))
        
        // then
        let expected = DetailEntity(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
        XCTAssertEqual(expected, actual!)
    }
    
    func testDetailApiServiceRequestWithNilModel() {
        // given
        let model = WeatherApiResponse(currentCondition: nil)
        
        // when
        var actual: DetailEntity!
        let expectation = XCTestExpectation(description: #function)
        sut.request(with: "keyword") { (result) in
            actual = result
            expectation.fulfill()
        }
        
        api.completion?(.success(model))
        
        // then
        let expected = DetailEntity(temperature: nil, weatherDescription: nil, humidity: nil, weatherImageUrl: nil)
        XCTAssertEqual(expected, actual!)
    }
    
    func testDetailApiServiceRequestReturnsError() {
        // given
        let error = ApiError.unabletoaccess
        
        // when
        var actual: DetailEntity!
        let expectation = XCTestExpectation(description: #function)
        sut.request(with: "keyword") { (result) in
            actual = result
            expectation.fulfill()
        }
        
        api.completion?(.failure(error))
        
        // then
        let expected = DetailEntity(temperature: nil, weatherDescription: nil, humidity: nil, weatherImageUrl: nil)
        XCTAssertEqual(expected, actual!)
    }
}
