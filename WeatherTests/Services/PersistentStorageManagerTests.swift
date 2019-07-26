//
//  PersistentStorageManagerTests.swift
//  WeatherTests
//
//  Created by Shepherd on 26/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class PersistentStorageManagerTests: XCTestCase {
    var sut: PersistentStorageManager!
    var storage: UserDefaultsMock!
    
    override func setUp() {
        storage = UserDefaultsMock()
        sut = PersistentStorageManager(storage: storage)
    }

    func testInsertFirstData() {
        // given
        let keyword = "A"
        
        // when
        sut.insert(string: keyword)
        
        // then
        let actual = sut.fetch()
        let expected = ["A"]
        XCTAssertEqual(actual, expected)
    }
    
    func testInsertFiveDatas() {
        // given
        let keywords = Array(0..<5).map { String($0) }
        
        // when
        keywords.forEach { sut.insert(string: $0) }
        
        // then
        let actual = sut.fetch()
        let expected = ["4","3","2","1","0"]
        XCTAssertEqual(actual, expected)
    }
    
    func testInsertElevenDatas() {
        // given
        let keywords = Array(0..<11).map { String($0) }
        
        // when
        keywords.forEach { sut.insert(string: $0) }
        
        // then
        let actual = sut.fetch()
        let expected = ["10","9","8","7","6","5","4","3","2","1"]
        XCTAssertEqual(actual, expected)
    }
    
    func testInsertDataReplacesSameData() {
        // given
        storage.strings = ["10","9","8","7","6","5","4","3","2","1"]
        let keyword = "5"
        
        // when
        sut.insert(string: keyword)
        
        // then
        let actual = sut.fetch()
        let expected = ["5","10","9","8","7","6","4","3","2","1"]
        XCTAssertEqual(actual, expected)
    }
}
