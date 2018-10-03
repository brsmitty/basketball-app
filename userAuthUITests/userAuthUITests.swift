//
//  userAuthUITests.swift
//  userAuthUITests
//
//  Created by Mike White on 10/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest

class userAuthUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
   
   func testUserRegistrationWithValidEmail(){
      
      
      let app = XCUIApplication()
      app.buttons["Register"].tap()
      app.textFields["email address"].tap()
      app.secureTextFields["password"].tap()
      app.buttons["Sign Up"].tap()
                  
   }
   
   func testUserRegistrationWithInvalidEmail(){
      
      
   }

}
