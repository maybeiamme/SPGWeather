//
//  UrlVerification.swift
//  WeatherTests
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class UrlVerification: XCTestCase {
    func testSearchUrlGenerateCorrecly() {
        // given
        
        // when
        let expected = ApiUrls.search.url(for: .v1)!
        let actual = "https://api.worldweatheronline.com/premium/v1/search.ashx"
        
        // then
        XCTAssertEqual(expected, actual)
    }
}
