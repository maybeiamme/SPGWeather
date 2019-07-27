//
//  CaseTests.swift
//  WeatherUITests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import XCTest

class CaseTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }
    
    func testCase1() {
        let app = XCUIApplication()

        app.launchEnvironment["Environment"] = "UITEST"
        app.launch()
        // given
        
        // when
        app.searchFields.element.tap()
        app.searchFields.element.typeText("Singapore")
        
        // then
        let exist = app.tables.cells.staticTexts["Singapore"].exists
        XCTAssert(exist)
    }
    
    func testCase2() {
        let app = XCUIApplication()
        
        app.launchEnvironment["Environment"] = "UITEST"
        app.launch()
        // given
        
        // when
        app.searchFields.element.tap()
        app.searchFields.element.typeText("Singapore")
        app.tables.cells.staticTexts["Singapore"].tap()
        
        // then
        XCTAssert(app.staticTexts["79"].exists)
        XCTAssert(app.staticTexts["Partly cloudy"].exists)
        XCTAssert(app.staticTexts["29"].exists)
    }
    
    func testCase3() {
        let app = XCUIApplication()
        XCUIApplication().terminate()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        let icon = springboard.icons["Weather"]
        if icon.exists {
            let iconFrame = icon.frame
            let springboardFrame = springboard.frame
            icon.press(forDuration: 1.3)
            
            let vector = CGVector(dx: (iconFrame.minX + 3) / springboardFrame.maxX, dy: (iconFrame.minY + 3) / springboardFrame.maxY)
            springboard.coordinate(withNormalizedOffset: vector).tap()
            
            let _ = springboard.alerts.buttons["Delete"].waitForExistence(timeout: 3)
            springboard.alerts.buttons["Delete"].tap()
        }
        
        app.launchEnvironment["Environment"] = "UITEST"
        app.launch()
        // given
        
        // when
        
        // then
        XCTAssert(app.staticTexts["Nothing has been seen!"].exists)
    }
    
    func testCase4() {
        let app = XCUIApplication()
        XCUIApplication().terminate()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        let icon = springboard.icons["Weather"]
        if icon.exists {
            let iconFrame = icon.frame
            let springboardFrame = springboard.frame
            icon.press(forDuration: 1.3)
            
            let vector = CGVector(dx: (iconFrame.minX + 3) / springboardFrame.maxX, dy: (iconFrame.minY + 3) / springboardFrame.maxY)
            springboard.coordinate(withNormalizedOffset: vector).tap()
            
            let _ = springboard.alerts.buttons["Delete"].waitForExistence(timeout: 3)
            springboard.alerts.buttons["Delete"].tap()
        }
        
        app.launchEnvironment["Environment"] = "UITEST"
        app.launch()
        // given
        app.searchFields.element.tap()
        app.searchFields.element.typeText("ABC")
        for i in 0 ..< 10 {
            app.tables.cells.element(boundBy: i).tap()
            let _ = app.staticTexts["Temperature"].waitForExistence(timeout: 2.0)
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
        // when
        app.buttons["Cancel"].tap()
        
        // then
        XCTAssert(app.tables.cells.element(boundBy: 0).staticTexts["Casa Grande"].exists)
    }
    
    func testCase5() {
        let app = XCUIApplication()
        XCUIApplication().terminate()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        let icon = springboard.icons["Weather"]
        if icon.exists {
            let iconFrame = icon.frame
            let springboardFrame = springboard.frame
            icon.press(forDuration: 1.3)
            
            let vector = CGVector(dx: (iconFrame.minX + 3) / springboardFrame.maxX, dy: (iconFrame.minY + 3) / springboardFrame.maxY)
            springboard.coordinate(withNormalizedOffset: vector).tap()
            
            let _ = springboard.alerts.buttons["Delete"].waitForExistence(timeout: 3)
            springboard.alerts.buttons["Delete"].tap()
        }
        
        app.launchEnvironment["Environment"] = "UITEST"
        app.launch()
        // given
        app.searchFields.element.tap()
        app.searchFields.element.typeText("ABC")
        for i in 0 ..< 10 {
            app.tables.cells.element(boundBy: i).tap()
            let _ = app.staticTexts["Temperature"].waitForExistence(timeout: 2.0)
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
        // then
        app.terminate()
        app.launch()
        
        // then
        XCTAssert(app.tables.cells.staticTexts["Casa Grande"].exists)
        XCTAssert(app.tables.cells.staticTexts["Caserio Pozo De La Pena"].exists)
        XCTAssert(app.tables.cells.staticTexts["Pozo De La Pena"].exists)
        XCTAssert(app.tables.cells.staticTexts["Salobral"].exists)
        XCTAssert(app.tables.cells.staticTexts["Caserio La Losilla"].exists)
        XCTAssert(app.tables.cells.staticTexts["La Losilla"].exists)
        XCTAssert(app.tables.cells.staticTexts["La Torrecica"].exists)
        XCTAssert(app.tables.cells.staticTexts["Albacete"].exists)
        XCTAssert(app.tables.cells.staticTexts["Los Llanos"].exists)
        XCTAssert(app.tables.cells.staticTexts["La Pulgosa"].exists)
    }
}
