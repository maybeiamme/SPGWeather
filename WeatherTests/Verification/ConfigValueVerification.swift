//
//  ConfigValueVerification.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class ConfigValueVerification: XCTestCase {

    func testApikeyMatches() {
        // given
        
        // when
        let expected = Bundle.main.configValue(for: "apikey")
        let actual = "0434896a6994489cb6905901192607"
        
        // then
        XCTAssertEqual(expected, actual)
    }
    
    func testEndpointMatches() {
        // given
        
        // when
        let expected = Bundle.main.configValue(for: "endpoint.search")
        let actual = "/search.ashx"
        
        // then
        XCTAssertEqual(expected, actual)
    }
    
    func testEndpointMatchesForWeather() {
        // given
        
        // when
        let expected = Bundle.main.configValue(for: "endpoint.weather")
        let actual = "/weather.ashx"
        
        // then
        XCTAssertEqual(expected, actual)
    }
    
    func testBaseUrlMatches() {
        // given
        
        // when
        let expected = Bundle.main.configValue(for: "baseurl")
        let actual = "https://api.worldweatheronline.com/premium"
        
        // then
        XCTAssertEqual(expected, actual)
    }
}
