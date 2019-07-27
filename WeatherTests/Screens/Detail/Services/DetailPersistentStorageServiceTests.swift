//
//  DetailPersistentStorageServiceTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class DetailPersistentStorageServiceTests: XCTestCase {
    var sut: DetailPersistentStorageService!
    var persistentStorage: PersistentStorageManagerMock!
    
    override func setUp() {
        persistentStorage = PersistentStorageManagerMock()
        sut = DetailPersistentStorageService(storage: persistentStorage)
    }
    
    func testPersistentStorageReturnsExactData() {
        // given
        
        // when
        sut.saveViewCity(name: "London")
        
        // then
        let expected = ["London"]
        let actual = persistentStorage.inserted
        XCTAssertEqual(actual, expected)
    }
}
