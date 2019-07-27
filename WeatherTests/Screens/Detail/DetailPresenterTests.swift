//
//  DetailPresenterTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class DetailPresenterTests: XCTestCase {
    var sut: DetailPresenter!
    var interactor: DetailInteractorInputMock!
    var view: DetailViewInputMock!
    
    override func setUp() {
        interactor = DetailInteractorInputMock()
        view = DetailViewInputMock()
        sut = DetailPresenter(interactor: interactor)
        sut.set(view: view)
    }
    
    func testInitialStatus() {
        // given
        
        // when
        sut.viewDidLoad()
        
        // then
        let actual = interactor.weatherDataRequested!
        let expected = true
        XCTAssertEqual(actual, expected)
    }
    
    func testWhenWeatherIsLoaded() {
        // given
        let entity = DetailEntity(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
        
        // when
        sut.weatherDataLoaded(entity: entity)
        
        // then
        let actual = view.viewModel!
        let expected = DetailViewModel(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImage: nil)
        XCTAssertEqual(actual, expected)
    }
    
    func testWhenImageIsLoaded() {
        // given
        let entity = DetailEntity(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
        
        // when
        sut.weatherImageLoaded(image: nil, entity: entity)
        
        // then
        let actual = view.viewModel!
        let expected = DetailViewModel(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImage: nil)
        XCTAssertEqual(actual, expected)
    }
    
    func testRunNetworkIndicator() {
        // given
        
        // when
        sut.viewDidLoad()
        
        // then
        let expected = true
        let actual = view.networkIndicatorRunning!
        XCTAssertEqual(actual, expected)
    }
    
    func testRunNetworkIndicatorStopped() {
        // given
         let entity = DetailEntity(temperature: "23", weatherDescription: "Overcast", humidity: "73", weatherImageUrl: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
        
        // when
        sut.weatherDataLoaded(entity: entity)
        
        // then
        let expected = false
        let actual = view.networkIndicatorRunning!
        XCTAssertEqual(actual, expected)
    }
}

class DetailInteractorInputMock: DetailInteractorInputProtocol {
    var weatherDataRequested: Bool?
    func requestWeather() {
        weatherDataRequested = true
    }
}


class DetailViewInputMock: DetailViewInputProtocol {
    var networkIndicatorRunning: Bool?
    func runNetworkIndicator() {
        networkIndicatorRunning = true
    }
    
    func stopNetworkIndicator() {
        networkIndicatorRunning = false
    }
    
    var viewModel: DetailViewModel?
    func set(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
}
