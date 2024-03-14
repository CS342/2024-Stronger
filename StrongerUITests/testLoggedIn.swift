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
    
    
    func testApplicationLoggedIn() throws {
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
    //
            let passwordSecureTextField = elementsQuery.secureTextFields["Password"]

            XCTAssertTrue(passwordSecureTextField.waitForExistence(timeout: 2))
            passwordSecureTextField.tap()
            UIPasteboard.general.string = "password"
            elementsQuery.secureTextFields["Password"].tap(withNumberOfTaps: 2, numberOfTouches: 1)
            passwordSecureTextField.typeText("password")
//            app.menuItems["Paste"].tap()
        //
            XCTAssertTrue(app.buttons["Login"].waitForExistence(timeout: 2))
        //        
            app.buttons["Login"].tap()
        } else {
            app.navigationBars.buttons["Close"].tap()
        }
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Workout"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Workout"].tap()
       
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Home"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Workout"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Workout"].tap()
       
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Home"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
        XCTAssertTrue(app.buttons["Weekly Stats"].waitForExistence(timeout: 2))
        app.buttons["Weekly Stats"].tap()
        XCTAssertTrue(app.staticTexts["Protein Intake Data"].waitForExistence(timeout: 2))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        XCTAssertTrue(app.buttons["Workout 1"].waitForExistence(timeout: 2))
        let firstWorkout = app.buttons["Workout 1"].firstMatch
        firstWorkout.tap()
        // app.buttons["Workout 1"].tap()
        // XCTAssert(app.staticTexts["Protein Intake Data"].waitForExistence(timeout: 2))
    }
}
