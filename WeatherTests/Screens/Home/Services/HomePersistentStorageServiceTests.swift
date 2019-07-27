//
//  HomePersistentStorageServiceTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class HomePersistentStorageServiceTests: XCTestCase {
    var sut: HomePersistentStorageService!
    var persistentStorage: PersistentStorageManagerMock!
    
    override func setUp() {
        persistentStorage = PersistentStorageManagerMock()
        sut = HomePersistentStorageService(storage: persistentStorage)
    }

    func testPersistentStorageReturnsExactData() {
        // given
        persistentStorage.inserted = ["Singapore", "London"]
        
        // when
        let actual = sut.getViewedCities()
        
        // then
        let expected = HomeViewdCities(citiNames: ["Singapore", "London"])
        XCTAssertEqual(actual, expected)
    }
}
