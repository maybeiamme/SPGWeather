//
//  HomePresenterTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!
    var interactor: HomeInteractorInputMock!
    var router: HomeRouterMock!
    var view: HomeViewInputMock!
    
    override func setUp() {
        interactor = HomeInteractorInputMock()
        router = HomeRouterMock()
        view = HomeViewInputMock()
        sut = HomePresenter(interactor: interactor, router: router)
        sut.set(view: view)
    }
    
    func testInitialStatus() {
        // given
        interactor.vc = HomeViewdCities(citiNames: [String]())
        
        // when
        sut.viewDidLoad()
        
        // then
        let actual = view.status!
        let expected = HomeStatusViewModel(isViewedCitiesViewHidden: true, isSearchedListViewHidden: true, isVacantStatusViewHidden: false)
        XCTAssertEqual(actual, expected)
    }
    
    func testInitialStatusWhenViewedListExist() {
        // given
        interactor.vc = HomeViewdCities(citiNames: ["London"])
        
        // when
        sut.viewDidLoad()
        
        // then
        let actual = view.status!
        let expected = HomeStatusViewModel(isViewedCitiesViewHidden: false, isSearchedListViewHidden: true, isVacantStatusViewHidden: true)
        XCTAssertEqual(actual, expected)
    }
    
    func testDataSourceForViewedCitiesTableView() {
        // given
        interactor.vc = HomeViewdCities(citiNames: ["London"])
        sut.viewDidLoad()
        
        // when
        let actual = sut.dataSourceForCurrentStatus()
        
        // then
        let expected = ["London"]
        XCTAssertEqual(actual, expected)
    }
    
    func testDataSourceForSearchedCitiesTableViewForInitialStatus() {
        // given
        sut.searchBarHasBecomeFirstResponder()
        
        // when
        let actual = sut.dataSourceForCurrentStatus()
        
        // then
        let expected = [String]()
        XCTAssertEqual(actual, expected)
    }
    
    func testDataSourceForSearchedCitiesTableViewForWhenSomethingIsLoaded() {
        // given
        sut.searchBarHasBecomeFirstResponder()
        sut.searchResultLoaded(results: HomeSearchedKeyword(titles: ["London", "Singapore"]))
        
        // when
        let actual = sut.dataSourceForCurrentStatus()
        
        // then
        let expected = ["London", "Singapore"]
        XCTAssertEqual(actual, expected)
    }
    
    func testDataSourceForSearchedCitiesTableViewForWhenSomethingIsLoadedTableViewShouldHaveBeenReloaded() {
        // given
        sut.searchResultLoaded(results: HomeSearchedKeyword(titles: ["London", "Singapore"]))
        
        // when
        sut.searchBarHasBecomeFirstResponder()
        
        // then
        let actual = view.searchTableViewReloaded!
        let expected = true
        XCTAssertEqual(actual, expected)
    }
    
    func testStatusWhenSearchBarHasResignedWithoutViewedCities() {
        // given
        interactor.vc = HomeViewdCities(citiNames: [String]())
        
        // when
        sut.searchBarHasResigned()
        
        // then
        let actual = view.status!
        let expected = HomeStatusViewModel(isViewedCitiesViewHidden: true, isSearchedListViewHidden: true, isVacantStatusViewHidden: false)
        XCTAssertEqual(actual, expected)
    }
    
    func testStatusWhenSearchBarHasResignedWithoutViewedCitiesTableViewShouldHaveBeenReloaded() {
        // given
        interactor.vc = HomeViewdCities(citiNames: ["London", "Singapore"])
        
        // when
        sut.searchBarHasResigned()
        
        // then
        let actual = true
        let expected = view.citiesTableViewReloaded!
        XCTAssertEqual(actual, expected)
    }
    
    func testStatusWhenSearchBarHasResignedWithViewedCities() {
        // given
        interactor.vc = HomeViewdCities(citiNames: ["London", "Singapore"])
        // when
        sut.searchBarHasResigned()
        
        // then
        let actual = view.status!
        let expected = HomeStatusViewModel(isViewedCitiesViewHidden: false, isSearchedListViewHidden: true, isVacantStatusViewHidden: true)
        XCTAssertEqual(actual, expected)
    }
    
    func testStatusWhenSearchBarHasBecomeFirstResponder() {
        // given
        
        // when
        sut.searchBarHasBecomeFirstResponder()
        
        // then
        let actual = view.status!
        let expected = HomeStatusViewModel(isViewedCitiesViewHidden: true, isSearchedListViewHidden: false, isVacantStatusViewHidden: true)
        XCTAssertEqual(actual, expected)
    }
    
    func testSomethingHasBeenTypedInSearchBar() {
        // given
        let typed = "London"
        
        // when
        sut.typedInSearchBar(with: typed)
        
        // then
        let actual = interactor.typed!
        let expected = "London"
        XCTAssertEqual(actual, expected)
    }
    
    func testSectionTitleForViewedCitiesStatus() {
        // given
        interactor.vc = HomeViewdCities(citiNames: ["London"])
        sut.viewDidLoad()
        
        // when
        let actual = sut.sectionTitleForCurrentStatus()
        
        // then
        let expected = "Viewed Cities"
        XCTAssertEqual(actual, expected)
    }
    
    func testSectionTitleForSearchedCitiesStatus() {
        // given
        sut.searchBarHasBecomeFirstResponder()
        sut.searchResultLoaded(results: HomeSearchedKeyword(titles: ["London", "Singapore"]))
        
        // when
        let actual = sut.sectionTitleForCurrentStatus()
        
        // then
        let expected = "Search results"
        XCTAssertEqual(actual, expected)
    }
}

class HomeInteractorInputMock: HomeInteractorInputProtocol {
    var typed: String?
    func search(with keyword: String?) {
        typed = keyword
    }
    
    var vc: HomeViewdCities?
    func viewedCities() -> HomeViewdCities {
        return vc!
    }
}

class HomeRouterMock: HomeRouterProtocol {
    func navigateToWeatherView(from: UIViewController?) {
        
    }
}

class HomeViewInputMock: (HomeViewInputProtocol & UIViewController) {
    var status: HomeStatusViewModel?
    func set(status: HomeStatusViewModel) {
        self.status = status
    }
    
    var searchTableViewReloaded: Bool?
    func reloadSearchedTableView() {
        searchTableViewReloaded = true
    }
    
    var citiesTableViewReloaded: Bool?
    func reloadViewdCitiesTableView() {
        citiesTableViewReloaded = true
    }
}
