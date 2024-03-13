//
//  testLoggedIn.swift
//  StrongerUITests
//
//  Created by Theodore Kanell on 3/12/24.
//

import Foundation
//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class LoggedInTests: XCTestCase {
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
        
//        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Your Account"].tap()
        
//        let scrollViewsQuery = XCUIApplication().scrollViews
//        let elementsQuery = scrollViewsQuery.otherElements
//        XCTAssertTrue(elementsQuery.textFields["E-Mail Address"].waitForExistence(timeout: 2))
//        elementsQuery.textFields["E-Mail Address"].tap()
//        elementsQuery.textFields["E-Mail Address"].typeText("tak@g.com")
//
//        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
//
//        XCTAssertTrue(passwordSecureTextField.waitForExistence(timeout: 2))
//        passwordSecureTextField.tap()
//        passwordSecureTextField.typeText("password")
//
//        XCTAssertTrue(app.buttons["Login"].waitForExistence(timeout: 2))
//        
//        app.buttons["Login"].tap()
//        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Your Account"]/*[[".otherElements[\"Your Account\"].buttons[\"Your Account\"]",".buttons[\"Your Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.collectionViews.buttons["Name, E-Mail Address"].tap()
////        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Name, E-Mail Address"]/*[[".cells.buttons[\"Name, E-Mail Address\"]",".buttons[\"Name, E-Mail Address\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        
//        app.navigationBars["Name, E-Mail Address"].buttons["Account Overview"].tap()
//        
//        let collectionViewsQuery = app.collectionViews
//        collectionViewsQuery.staticTexts["Sign-In & Security"].tap()
////        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Sign-In & Security"]/*[[".cells",".buttons[\"Sign-In & Security\"].staticTexts[\"Sign-In & Security\"]",".staticTexts[\"Sign-In & Security\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
//        // app.navigationBars["Sign-In & Security"].buttons["Account Overview"].tap()
//        app.navigationBars["Sign-In & Security"].buttons["Account Overview"].tap()
//        collectionViewsQuery.staticTexts["Date of Birth"].tap()
////        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Date of Birth"]/*[[".cells",".staticTexts[\"Date of Birth, Mar 3, 1994\"].staticTexts[\"Date of Birth\"]",".staticTexts[\"Date of Birth\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.navigationBars["Account Overview"].buttons["Close"].tap()
//        app.navigationBars["Account Overview"]/*@START_MENU_TOKEN@*/.buttons["Close"]/*[[".otherElements[\"Close\"].buttons[\"Close\"]",".buttons[\"Close\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.buttons["Weekly Stats"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Workout 1"].waitForExistence(timeout: 2))
        
        app.buttons["Weekly Stats"].tap()
        XCTAssert(app.staticTexts["Protein Intake Data"].waitForExistence(timeout: 2))
    }
}
