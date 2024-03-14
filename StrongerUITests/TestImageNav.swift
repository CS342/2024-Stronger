//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class SelectImageTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testSelectImage() throws {
        let app = XCUIApplication()
        XCTAssertEqual(app.state, .runningForeground)
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Food Tracking"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Food Tracking"].tap()
        
        XCTAssertTrue(app.buttons["Input with Camera"].waitForExistence(timeout: 2))
        
        
        app.buttons["Input with Camera"].tap()
        
        XCTAssertTrue(app.buttons["Select or Take Picture"].waitForExistence(timeout: 2))
        app.buttons["Select or Take Picture"].tap()
    }
}
