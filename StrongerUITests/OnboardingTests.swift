//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class OnboardingTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding"]
        app.launch()
    }

    
    func testApplicationOnboarding() throws {
        let app = XCUIApplication()
        XCTAssertEqual(app.state, .runningForeground)
        
        XCTAssertTrue(app.buttons["Learn More"].waitForExistence(timeout: 2))
        app.buttons["Learn More"].tap()
        for num in 1...2 {
            XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 2))
            app.buttons["Next"].tap()
        }
        
//        XCTAssertTrue(app.buttons["Signup"].waitForExistence(timeout: 2))
//        app.buttons["Signup"].tap()
//        
//        XCTAssertTrue(app.textFields["E-Mail Address"].waitForExistence(timeout: 2))
//        app.textFields["E-Mail Address"].firstMatch.tap()
//        XCTAssertTrue(app.secureTextFields["Password"].waitForExistence(timeout: 2))
//        XCTAssertTrue(app.textFields["enter first name"].waitForExistence(timeout: 2))
//        XCTAssertTrue(app.textFields["enter last name"].waitForExistence(timeout: 2))
//        XCTAssertTrue(app.buttons["Female"].waitForExistence(timeout: 2))
//        XCTAssertTrue(app.textFields["Weight: lbs"].waitForExistence(timeout: 2))
        // XCTAssertTrue(app.textFields["Height"].waitForExistence(timeout: 2))
//        
//        do {
//            try app.textFields["E-Mail Address"].tap()
//        } catch {
//            XCTFail("Failed to tap on the text field: \(error)")
//        }
////        app.textFields["E-Mail Address"].typeText("test@gmail.com")
//        
//        
//        enterText(textField: app.textFields["E-Mail Address"], text: "test@gmail.com")
//        enterText(textField: app.secureTextFields["Password"], text: "password")
//        enterText(textField: app.textFields["enter first name"], text: "testName")
//        enterText(textField: app.textFields["enter last name"], text: "testLastName")
//        enterText(textField: app.textFields["Weight: lbs"], text: "140")
//        enterText(textField: app.textFields["Height"], text: "65")
//        
//        XCTAssertTrue(app.datePickers["Date of Birth"].waitForExistence(timeout: 2))
//        
//        let datePicker = app.datePickers["Date of Birth"]
//        enterDate(datePicker: datePicker, dateDifference: 20)
//        
//        // Optionally, tap "Done" or outside the date picker to dismiss it
//        app.buttons["Done"].tap()

    }
    
    func enterDate(datePicker: XCUIElement, dateDifference: Int) {
        datePicker.tap()
        
        let calendar = Calendar.current
        // Scroll to select the desired date components (year, month, day, etc.)
        guard let selectedDate = calendar.date(byAdding: .year, value: -dateDifference, to: Date()) else {
            XCTFail("Failed to calculate the desired date")
            return
        }
        
        let components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        
        let yearComponent = components.year!
        let monthComponent = components.month!
        let dayComponent = components.day!
        
        // Adjust the date picker wheels to select the desired date
        datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "\(yearComponent)")
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "\(monthComponent)")
        datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "\(dayComponent)")
    }
    
    func enterText(textField: XCUIElement, text: String) {
        // Tap on the text field to focus on it
//        textField.tap()
        
        // Type the text into the text field
        textField.typeText(text)
    }
}
