//
//  DetailInteractorTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class DetailInteractorTests: XCTestCase {
    var sut: DetailInteractor!
    var api: DetailApiServiceMock!
    var storage: DetailPersistentStorageMock!
    var presenter: DetailInteractorOutputMock!
    var thumanailDownloader: ThumbnailDownloaderMock!
    
    override func setUp() {
        presenter = DetailInteractorOutputMock()
        api = DetailApiServiceMock()
        storage = DetailPersistentStorageMock()
        thumanailDownloader = ThumbnailDownloaderMock()
        sut = DetailInteractor(apiService: api, persistentService: storage, thumbnailDownloader: thumanailDownloader, cityName: "Seoul")
        sut.set(presenter: presenter)
    }
    
    func testRequest() {
        // given
        let response = DetailEntity(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
        
        let expectation = XCTestExpectation(description: #function)
        
        api.apiCalled = {
            self.api.completion?(response)
        }
        presenter.resultLoaded = {
            // then
            let actual = self.presenter.weather
            let expected = DetailEntity(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
            XCTAssertEqual(expected, actual)
            expectation.fulfill()
        }
        
        // when
        sut.requestWeather()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDetailInteractorSaveCities() {
        // given
        let response = DetailEntity(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
        
        let expectation = XCTestExpectation(description: #function)
        
        api.apiCalled = {
            self.api.completion?(response)
        }
        presenter.resultLoaded = {
            // then
            let actual = self.storage.lastSavedCity!
            let expected = "Seoul"
            XCTAssertEqual(expected, actual)
            expectation.fulfill()
        }
        
        // when
        sut.requestWeather()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDownloadImageAfterRequest() {
        // given
        let response = DetailEntity(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
        thumanailDownloader.image = UIImage()
        let expectation = XCTestExpectation(description: #function)
        
        api.apiCalled = {
            self.api.completion?(response)
        }

        presenter.imageLoaded = {
            // then
            let actual = self.presenter.weather
            let expected = DetailEntity(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
            XCTAssertEqual(expected, actual)
            XCTAssertNotNil(self.presenter.image)
            expectation.fulfill()
        }
        
        // when
        sut.requestWeather()
        wait(for: [expectation], timeout: 1.0)
    }
}

class DetailApiServiceMock: DetailApiServiceProtocol {
    var completion: ((DetailEntity) -> Void)?
    var apiCalled: (() -> Void)?
    
    func request(with keyword: String, completion: @escaping (DetailEntity) -> Void) {
        self.completion = completion
        apiCalled?()
    }
}

class DetailPersistentStorageMock: DetailPersistentStorageServiceProtocol {
    var lastSavedCity: String?
    func saveViewCity(name: String) {
        lastSavedCity = name
    }
}

class DetailInteractorOutputMock: DetailInteractorOutputProtocol {
    var imageLoadedEntity: DetailEntity!
    var imageLoaded: (() -> Void)?
    var image: UIImage?
    func weatherImageLoaded(image: UIImage?, entity: DetailEntity) {
        imageLoadedEntity = entity
        self.image = image
        imageLoaded?()
    }
    
    var weather: DetailEntity!
    var resultLoaded: (() -> Void)?
    func weatherDataLoaded(entity: DetailEntity) {
        weather = entity
        resultLoaded?()
    }
}
