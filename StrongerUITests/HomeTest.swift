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
        
        
        let scrollViewsQuery = XCUIApplication().scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.textFields["E-Mail Address"].tap()
        elementsQuery.textFields["E-Mail Address"].typeText("tak@g.com")
        
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        XCTAssertTrue(app.buttons["Login"].waitForExistence(timeout: 2))
        app.buttons["Login"].tap()
        
        let account = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Your Account"]
        XCTAssertTrue(account.waitForExistence(timeout: 2))
                
        account.tap()
//        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Your Account"].tap()
        app.collectionViews.buttons["Name, E-Mail Address"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
//        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Name, E-Mail Address"]/*[[".cells.buttons[\"Name, E-Mail Address\"]",".buttons[\"Name, E-Mail Address\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
//        app.navigationBars["Name, E-Mail Address"].buttons["Account Overview"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Sign-In & Security"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        collectionViewsQuery.staticTexts["Date of Birth"].tap()
//        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        collectionViewsQuery.staticTexts["License Information"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons["Close"].tap()
        
        XCTAssertTrue(app.buttons["Weekly Stats"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Workout 1"].waitForExistence(timeout: 2))
        
        app.buttons["Weekly Stats"].tap()
        XCTAssert(app.staticTexts["Protein Intake Data"].waitForExistence(timeout: 2))
    }
}
