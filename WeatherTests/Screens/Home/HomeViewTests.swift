//
//  HomeViewTests.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest
@testable import Weather

class HomeViewTests: XCTestCase {
    var sut: HomeViewController!
    var presenter: HomeViewOutputMock!

    override func setUp() {
        sut = HomeViewController()
        presenter = HomeViewOutputMock()
        sut.set(presenter: presenter)
    }
    
    func testTableViewLoad() {
        // given
        let title = "Title"
        presenter.title = title
        
        // when
        let actual = sut.tableView(UITableView(), titleForHeaderInSection: 0)
        
        // then
        let expected = "Title"
        XCTAssertEqual(actual, expected)
    }
    
    func testTableViewDataSourceCount() {
        // given
        let datasource = ["1", "2", "3"]
        presenter.dataSource = datasource
        
        // when
        let actual = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        
        // then
        let expected = 3
        XCTAssertEqual(actual, expected)
    }
    
    func testTableViewDataSource() {
        // given
        let datasource = ["1", "2", "3"]
        presenter.dataSource = datasource
        
        // when
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        let actual = sut.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)).textLabel?.text!
        
        // then
        let expected = "2"
        XCTAssertEqual(actual, expected)
    }
    
    func testTableViewSelect() {
        // given
        let datasource = ["1", "2", "3"]
        presenter.dataSource = datasource
        
        // when
        sut.tableView(UITableView(), didSelectRowAt: IndexPath(row: 1, section: 0))
        
        // then
        let actual = presenter.selectedIndex
        let expected = 1
        XCTAssertEqual(actual, expected)
    }
}

class HomeViewOutputMock: HomeViewOutputProtocol {
    func viewDidLoad() {
        
    }
    
    func searchBarHasResigned() {
        
    }
    
    
    var searchBarIsActive: Bool?
    func searchBarHasBecomeFirstResponder() {
        searchBarIsActive = true
    }
    
    func typedInSearchBar(with text: String?) {
        
    }
    var dataSource: [String]?
    func dataSourceForCurrentStatus() -> [String] {
        return dataSource!
    }
    
    var title: String?
    func sectionTitleForCurrentStatus() -> String {
        return title!
    }
    var selectedIndex: Int?
    func didSelectSearchedKeyword(at index: Int) {
        selectedIndex = index
    }
}
