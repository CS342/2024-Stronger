//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class HomeTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testApplicationHome() throws {
        let app = XCUIApplication()
        XCTAssertEqual(app.state, .runningForeground)
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Home"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Your Account"].tap()
        
        let notLoggedIn = app.staticTexts["Please sign-in to continue your Stronger journey"].exists
        if notLoggedIn {
            let scrollViewsQuery = XCUIApplication().scrollViews
            let elementsQuery = scrollViewsQuery.otherElements
            XCTAssertTrue(elementsQuery.textFields["E-Mail Address"].waitForExistence(timeout: 2))
            elementsQuery.textFields["E-Mail Address"].tap()
            elementsQuery.textFields["E-Mail Address"].typeText("tak@g.com")
            let passwordSecureTextField = elementsQuery.secureTextFields["Password"]

            XCTAssertTrue(passwordSecureTextField.waitForExistence(timeout: 2))
            passwordSecureTextField.tap()
            UIPasteboard.general.string = "password"
            elementsQuery.secureTextFields["Password"].tap(withNumberOfTaps: 2, numberOfTouches: 1)
            passwordSecureTextField.typeText("password")
            XCTAssertTrue(app.buttons["Login"].waitForExistence(timeout: 2))
            app.buttons["Login"].tap()
            let canClose = app.navigationBars.buttons["Close"].exists
            if canClose {
                app.navigationBars.buttons["Close"].tap()
            }
        } else {
            let canClose = app.navigationBars.buttons["Close"].exists
            if canClose {
                app.navigationBars.buttons["Close"].tap()
            }
        }

        
        let account = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Your Account"]
        XCTAssertTrue(account.waitForExistence(timeout: 2))
                
        account.tap()

        XCTAssertTrue(app.collectionViews.staticTexts["Name, E-Mail Address"].waitForExistence(timeout: 2))
        app.collectionViews.staticTexts["Name, E-Mail Address"].tap()

        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.collectionViews.staticTexts["License Information"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        app.collectionViews.staticTexts["License Information"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        let canClose = app.navigationBars.buttons["Close"].exists
        if canClose {
            app.navigationBars.buttons["Close"].tap()
        }
        
//         XCTAssertTrue(app.buttons["Weekly Stats"].waitForExistence(timeout: 2))
//         XCTAssertTrue(app.buttons["Workout 1"].waitForExistence(timeout: 2))
    }
}
