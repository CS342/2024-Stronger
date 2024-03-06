//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class TabTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testApplicationTabSwitching() throws {
        let app = XCUIApplication()
        XCTAssertEqual(app.state, .runningForeground)
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Home"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
//        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["ProBot"].waitForExistence(timeout: 2))
//        app.tabBars["Tab Bar"].buttons["ProBot"].tap()
//        
//        XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 2))
//        app.buttons["Next"].tap()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Workout"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Workout"].tap()
        

//        XCTAssertTrue(app.staticTexts["Contact: Leland Stanford"].waitForExistence(timeout: 2))
//
//        XCTAssertTrue(app.buttons["Call"].waitForExistence(timeout: 2))
//        XCTAssertTrue(app.buttons["Text"].waitForExistence(timeout: 2))
//        XCTAssertTrue(app.buttons["Email"].waitForExistence(timeout: 2))
//        XCTAssertTrue(app.buttons["Website"].waitForExistence(timeout: 2))
        
    }
}
