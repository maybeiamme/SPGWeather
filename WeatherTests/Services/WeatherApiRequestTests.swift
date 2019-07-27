//
//  WeatherApiRequestTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherApiRequestTests: XCTestCase {

    var sut: WeatherApiRequest!
    var networkManager: NetworkManagerMock!
    var decoder: JSONDecoderMock!
    
    override func setUp() {
        networkManager = NetworkManagerMock()
        decoder = JSONDecoderMock()
        sut = WeatherApiRequest(networkManager: networkManager, decoder: decoder)
    }
    
    func testSearchApiRequestHasProperUrl() {
        // given
        
        // when
        let _ = sut.request(with: "query") { result in
        }
        
        let expected = "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=query&key=0434896a6994489cb6905901192607&format=json"
        let actual = networkManager.request!.url!.absoluteString
        XCTAssertEqual(expected, actual)
    }
    
    func testSearchApiReceivesSuccess() {
        // given
        decoder.decoded = "detail_success".stub()
        let query = "Seoul"
        
        // when
        var actual: WeatherApiResponse!
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
        
        networkManager.completion!(Result<Data, NetworkError>.success("detail_success".stub()))
        
        // then
        wait(for: [expectation], timeout: 0.1)
        let expected = WeatherApiResponse(currentCondition: WeatherApiCurrentCondition(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"))
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
        
        networkManager.completion!(Result<Data, NetworkError>.success("detail_success".stub()))
        
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
}
