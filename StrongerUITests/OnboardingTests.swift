//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions

class OnboardingTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding", "--useFirebaseEmulator"]
        app.launch()
    }

    
    func testApplicationOnboarding() throws {
        let app = XCUIApplication()
        XCTAssertEqual(app.state, .runningForeground)
        
        XCTAssertTrue(app.buttons["Learn More"].waitForExistence(timeout: 2))
        app.buttons["Learn More"].tap()
        for _ in 1...2 {
            XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 2))
            app.buttons["Next"].tap()
        }
        let loggedIn = app.buttons["Logout"].exists
        if loggedIn {
            app.buttons["Logout"].tap()
        }
//        try app.buttons["Log out"].tap()
        
        XCTAssertTrue(app.buttons["Signup"].waitForExistence(timeout: 2))
        app.buttons["Signup"].tap()
        
        let collectionViewsQuery = app.collectionViews
        
        collectionViewsQuery.textFields["E-Mail Address"].tap()
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["E-Mail Address"]/*[[".cells.textFields[\"E-Mail Address\"]",".textFields[\"E-Mail Address\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery.textFields["E-Mail Address"].typeText("email@g.com")
//        collectionViewsQuery.textFields["E-Mail Address"].typeText(text)
        let passwordSecureTextField = collectionViewsQuery.secureTextFields["Password"]
        //        let passwordSecureTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        collectionViewsQuery.staticTexts["PERSONAL DETAILS"].tap()
        app.swipeUp()
        
        let enterFirstNameTextField = collectionViewsQuery.textFields["enter first name"]
//        let enterFirstNameTextField = collectionViewsQuery
        enterFirstNameTextField.tap()
        enterFirstNameTextField.typeText("first name")
        
        let enterLastNameTextField = collectionViewsQuery.textFields["enter last name"]
        enterLastNameTextField.tap()

        enterLastNameTextField.typeText("last name")
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["PERSONAL DETAILS"]/*[[".cells.staticTexts[\"PERSONAL DETAILS\"]",".staticTexts[\"PERSONAL DETAILS\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        enterText(textField: collectionViewsQuery.textFields["Weight: lbs"], text: "140")
        enterText(textField: collectionViewsQuery.textFields["Height"], text: "65")

//        XCTAssertTrue(app.datePickers["Date of Birth"].waitForExistence(timeout: 2))
//        
//        let datePicker = app.datePickers["Date of Birth"]
//        enterDate(datePicker: datePicker, dateDifference: 20)
        //        
////        // Optionally, tap "Done" or outside the date picker to dismiss it
//        app.buttons["Done"].tap()

    }
    

//    func enterDate(datePicker: XCUIElement, dateDifference: Int) {
//        datePicker.tap()
//        
//        let calendar = Calendar.current
//        // Scroll to select the desired date components (year, month, day, etc.)
//        guard let selectedDate = calendar.date(byAdding: .year, value: -dateDifference, to: Date()) else {
//            XCTFail("Failed to calculate the desired date")
//            return
//        }
//        
//        let components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
//        
//        let yearComponent = components.year
//        let monthComponent = components.month
//        let dayComponent = components.day
//        
//        // Adjust the date picker wheels to select the desired date
//        datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "\(yearComponent)")
//        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "\(monthComponent)")
//        datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "\(dayComponent)")
//    }
    
    func enterText(textField: XCUIElement, text: String) {
        // Tap on the text field to focus on it
       textField.tap()

        
        // Type the text into the text field
        textField.typeText(text)
    }
}
