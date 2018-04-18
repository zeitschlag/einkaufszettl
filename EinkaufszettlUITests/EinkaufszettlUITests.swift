//
//  EinkaufszettlUITests.swift
//  EinkaufszettlUITests
//
//  Created by Nathan Mattes on 01.11.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import XCTest

class EinkaufszettlUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

        //Idea: Set everything
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // 3
    func testTakeDetailScreenshot() {
        
        let app = XCUIApplication()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"Orangen").buttons["Weitere Infos"].tap()
        
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Menge").children(matching: .textField).element
        textField.tap()
        app.keyboards.keys["Löschen"].tap()
        app.keyboards.keys["Löschen"].tap()
        textField.typeText("2")
        
        snapshot("3-details")
        
        app.navigationBars["Orangen"].buttons["Sichern"].tap()

    }
    
    
    // 1
    func testTakeShoppingListScreenshot() {
        snapshot("1-shopping-list")
    }
    
    // 2
    func testTakeShoppingListSwippedScreenshot() {
        
        let app = XCUIApplication()
        app.tables.cells.staticTexts["Champignons"].swipeLeft()
        snapshot("2-shopping-list-swipped")
        
    }
    
    // 4
    func testTakeProductListScreenshot() {
        let app = XCUIApplication()
        app.navigationBars["Einkaufszettl"].buttons["Hinzufügen"].tap()
        let element = app.tables.cells.containing(.staticText, identifier:"Orangen").element
        element.swipeDown()

        snapshot("4-product-list")
    }

    // 5
    func testTakeSearchScreenshot() {
        
        let app = XCUIApplication()
        app.navigationBars["Einkaufszettl"].buttons["Hinzufügen"].tap()
        app.navigationBars["EZLAddThingsTableView"].searchFields["Sache suchen/erstellen"].typeText("Ba")
        
        let element = app.tables.cells.containing(.staticText, identifier:"Bananen").element
        element.swipeDown()

        snapshot("5-search")
    }
}
