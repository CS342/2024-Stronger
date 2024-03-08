////
//// This source file is part of the Stronger based on the Stanford Spezi Template Application project
////
//// SPDX-FileCopyrightText: 2023 Stanford University
////
//// SPDX-License-Identifier: MIT
////
//
//import XCTest
//
//
//class MissedWorkoutTests: XCTestCase {
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        
//        continueAfterFailure = false
//        
//        let app = XCUIApplication()
//        app.launchArguments = ["--skipOnboarding"]
//        app.launch()
//    }
//    
//    
//    func testApplicationMissedWorkouts() throws {
//        let app = XCUIApplication()
//        XCTAssertEqual(app.state, .runningForeground)
//        
//        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Workout"].waitForExistence(timeout: 2))
//        app.tabBars["Tab Bar"].buttons["Workout"].tap()
//        
//        XCTAssertTrue(app.buttons["Enter Missed Workout"].waitForExistence(timeout: 2))
//        app.buttons["Enter Missed Workout"].tap()
//        
//        
//        XCTAssertTrue(app.buttons["Week 1"].waitForExistence(timeout: 2))
//        app.buttons["Week1 1"].tap()
//        XCTAssertTrue(app.buttons["Week 1"].waitForExistence(timeout: 2))
//    }
//}
