//
//  TopMoviesUITests.swift
//  PANTopMoviesUITests
//
//  Created by Diego Ramos de Almeida on 24/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import XCTest

class TopMoviesUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomeAndDetail() {
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            firstChild.tap()
        }
        sleep(3)
    }
    
    func testHomeOfflineButton() {
        let app = XCUIApplication()
        let accordianButtonsQuery = app.buttons.matching(identifier: "Offline")
        if accordianButtonsQuery.count > 0 {
            let firstButton = accordianButtonsQuery.element(boundBy: 0)
            firstButton.tap()
        }
        
        sleep(1)
    }
    
}
