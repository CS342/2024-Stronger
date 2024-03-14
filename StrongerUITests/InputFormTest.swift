//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest

class InputFormTest: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    func testRepsInputField() {
        let app = XCUIApplication()
        XCTAssertEqual(app.state, .runningForeground)
        
        // Navigate to the "Workout" tab
        let workoutTabButton = app.tabBars["Tab Bar"].buttons["Workout"]
        XCTAssertTrue(workoutTabButton.waitForExistence(timeout: 2), "The Workout tab button does not exist.")
        workoutTabButton.tap()
        
        // Check for the existence of the "Enter Workout Information" button and tap if it exists
        let enterWorkoutInfoButton = app.buttons["Enter Workout Information\n for Week 1 Day 1."]
        if enterWorkoutInfoButton.waitForExistence(timeout: 2) {
            enterWorkoutInfoButton.tap()
        }
        
        // Proceed with the test to tap on a specific workout button and enter reps
        let squatsButton = app.buttons["squats"]
        XCTAssertTrue(squatsButton.waitForExistence(timeout: 2), "The 'squats' button does not exist.")
        squatsButton.tap()
        
        let repsTextField = app.textFields["Reps"]
        XCTAssertTrue(repsTextField.exists, "The reps text field does not exist.")
        repsTextField.tap()
        repsTextField.typeText("10")
        XCTAssertTrue(repsTextField.waitForExistence(timeout: 2), "The 'reps' button does not exist.")
        XCTAssertEqual(repsTextField.value as? String, "10", "The reps text field does not contain the expected text '10'.")
        
        let submitButton = app.buttons["Submit"]
        XCTAssertTrue(submitButton.isEnabled)
        submitButton.tap()
        
        let thumbnailImage = app.images["WorkoutThumbnail"]
        XCTAssertTrue(thumbnailImage.waitForExistence(timeout: 2), "The thumbnail does not exist.")
        
        // Simulate a tap on the thumbnail image
        thumbnailImage.tap()
        
        let tipsView = app.staticTexts["Play the video to see how to do Squats!"] // Use the actual identifier or part of the tips text
        XCTAssertTrue(tipsView.waitForExistence(timeout: 2), "The tips view does not exist.")
    }
}
