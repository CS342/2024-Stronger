//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class LLMTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testLLMUI() throws {
        let app = XCUIApplication()
        XCTAssertEqual(app.state, .runningForeground)
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Food Tracking"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Food Tracking"].tap()
        
        
        XCTAssertTrue(app.buttons["Input with ChatBot"].waitForExistence(timeout: 2))
        app.buttons["Input with ChatBot"].tap()
        
        XCTAssertTrue(app.textFields["OpenAI API Key"].waitForExistence(timeout: 2))
        app.textFields["OpenAI API Key"].tap()
        
        app.textFields["OpenAI API Key"].typeText("FAKEAPIKEY")
        app.buttons["Next"].tap()
        
//        XCTAssertTrue(app.textFields["Message Input Textfield"].waitForExistence(timeout: 2))
//        app.textFields["Message"].tap()
//        app.textFields["Message"].typeText("Hello, I ate a lot of food")
//        
//        XCTAssertTrue(app.textFields["Send Message"].waitForExistence(timeout: 2))
//        
//        app.textFields["Send Message"].tap()
//        XCTAssertTrue(app.buttons["Select or Take Picture"].waitForExistence(timeout: 2))
//        app.buttons["Select or Take Picture"].tap()
    }
}
