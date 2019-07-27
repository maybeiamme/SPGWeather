//
//  DetailViewTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class DetailViewTests: XCTestCase {
    var sut: DetailViewController!
    var presenter: DetailViewOutputMock!
    
    override func setUp() {
        presenter = DetailViewOutputMock()
        sut = DetailViewController(nibName: String(describing: DetailViewController.self), bundle: Bundle.main) as DetailViewController
        sut.set(presenter: presenter)
    }

    func testDetailViewInitialized() {
        // given
        
        // when
        sut.viewDidLoad()
        
        // then
        let actual = presenter.viewDidLoadCalled!
        let expected = true
        XCTAssertEqual(actual, expected)
    }
}

class DetailViewOutputMock: DetailViewOutputProtocol {
    var viewDidLoadCalled: Bool?
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
