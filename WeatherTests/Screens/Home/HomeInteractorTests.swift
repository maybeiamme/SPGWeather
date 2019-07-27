//
//  HomeInteractorTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class HomeInteractorTests: XCTestCase {
    var sut: HomeInteractor!
    var api: HomeApiServiceMock!
    var storage: HomePersistentStorageMock!
    var presenter: HomePresenterMock!
    
    override func setUp() {
        presenter = HomePresenterMock()
        api = HomeApiServiceMock()
        storage = HomePersistentStorageMock()
        sut = HomeInteractor(apiService: api, persistentService: storage)
        sut.set(presenter: presenter)
    }
    
    func testSearchKeyword() {
        // given
        let response = HomeSearchedKeyword(titles: ["London"])
        
        let expectation = XCTestExpectation(description: #function)
        
        api.apiCalled = {
            self.api.completion?(response)
        }
        presenter.resultLoaded = {
            // then
            let actual = self.presenter.loadedSearchedKeyword
            let expected = HomeSearchedKeyword(titles: ["London"])
            XCTAssertEqual(expected, actual)
            expectation.fulfill()
        }
        
        // when
        sut.search(with: "London")
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHomeInteractorCancelTasksCorrectly() {
        // given
        let response = HomeSearchedKeyword(titles: ["LA"])
        
        let expectation = XCTestExpectation(description: #function)
        
        api.apiCalled = {
            self.api.completion?(response)
        }
        presenter.resultLoaded = {
            // then
            let actual = self.presenter.loadedSearchedKeyword
            let expected = HomeSearchedKeyword(titles: ["LA"])
            XCTAssertEqual(expected, actual)
            expectation.fulfill()
        }
        
        // when
        let serialQueue = DispatchQueue(label: "com.queue.Serial")
        serialQueue.asyncAfter(deadline: .now() + 0.1) {
            self.sut.search(with: "Singapore")
        }
        serialQueue.asyncAfter(deadline: .now() + 0.2) {
            self.sut.search(with: "LA")
        }
        sut.search(with: "London")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHomeInteractorLoadSavedCities() {
        // given
        
        // when
        let actual = sut.viewedCities()
        
        // then
        let expected = HomeViewdCities(citiNames: ["Singapore", "London"])
        XCTAssertEqual(expected, actual)
    }
}

class HomeApiServiceMock: HomeApiServiceProtocol {
    var completion: ((HomeSearchedKeyword) -> Void)?
    var apiCalled: (() -> Void)?
    func search(with keyword: String, completion: @escaping (HomeSearchedKeyword) -> Void) {
        self.completion = completion
        apiCalled?()
    }
    
    func cancelAllPreviousSearch() {
        
    }
}

class HomePersistentStorageMock: HomePersistentStorageServiceProtocol {
    func getViewedCities() -> HomeViewdCities {
        return HomeViewdCities(citiNames: ["Singapore", "London"])
    }
}

class HomePresenterMock: HomeInteractorOutputProtocol {
    var loadedSearchedKeyword: HomeSearchedKeyword!
    var resultLoaded: (() -> Void)?
    func searchResultLoaded(results: HomeSearchedKeyword) {
        loadedSearchedKeyword = results
        resultLoaded?()
    }
}
