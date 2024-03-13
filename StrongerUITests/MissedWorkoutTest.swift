//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

 import XCTest


 class MissedWorkoutTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testApplicationMissedWorkouts() throws {
        let app = XCUIApplication()
        XCTAssertEqual(app.state, .runningForeground)
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Workout"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Workout"].tap()
        
        XCTAssertTrue(app.buttons["Enter Missed Workout"].waitForExistence(timeout: 2))
        app.buttons["Enter Missed Workout"].tap()
        
        for num in 1...12 {
            XCTAssertTrue(app.buttons["Week \(num)"].waitForExistence(timeout: 2))
            app.buttons["Week \(num)"].tap()
        }
        
        for num in 1...3 {
            XCTAssertTrue(app.buttons["Day \(num)"].waitForExistence(timeout: 2))
            app.buttons["Day \(num)"].tap()
        }
        
        XCTAssertTrue(app.buttons["Week 1"].waitForExistence(timeout: 2))
        app.buttons["Week 1"].tap()
        
        XCTAssertTrue(app.buttons["Day 1"].waitForExistence(timeout: 2))
        app.buttons["Day 1"].tap()

        XCTAssertTrue(app.buttons["Enter Workout Information\n for Week 1 Day 1."].waitForExistence(timeout: 2))
        app.buttons["Enter Workout Information\n for Week 1 Day 1."].tap()
        
        XCTAssertTrue(app.buttons["squats"].waitForExistence(timeout: 2))
        app.buttons["squats"].tap()
    }
 }
