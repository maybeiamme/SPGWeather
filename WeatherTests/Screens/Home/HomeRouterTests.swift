//
//  HomeRouterTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class HomeRouterTests: XCTestCase {
    var sut: HomeRouter!
    var navigationViewController: NavigationViewControllerMock!
    var viewController: UIViewControllerMock!
    
    override func setUp() {
        viewController = UIViewControllerMock()
        navigationViewController = NavigationViewControllerMock(rootViewController: viewController)
        sut = HomeRouter()
    }
    
    func testHomeRouterNavigateToDetailViewController() {
        // given
        
        // when
        sut.navigateToWeatherView(from: viewController, with: "CityName")
        
        // then
        let actual = String(describing: type(of: navigationViewController.pushedViewControllers[1]))
        let expected = String(describing: type(of: DetailRouter.instantiate(cityName: "CityName")))
        XCTAssertEqual(actual, expected)
    }
}
