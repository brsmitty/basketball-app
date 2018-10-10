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
      let registerButton = app.buttons["REGISTER"]
      registerButton.tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("mkwhite401@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let password = element.children(matching: .secureTextField).element(boundBy: 0)
      password.tap()
      password.typeText("michael")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let passwordCheck = element.children(matching: .secureTextField).element(boundBy: 1)
      passwordCheck.tap()
      passwordCheck.typeText("michael")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let teamName = element.children(matching: .textField).element(boundBy: 1)
      teamName.tap()
      teamName.typeText("Gators")
      app.buttons["Go"].tap()
      
      registerButton.tap()
      XCTAssertEqual(registerButton.exists, false)
      
         
      
   }
   
   func testUserRegistrationWithInvalidEmail(){

   }
   
   func testLoginWithValidEmail(){
      
      
      let app = XCUIApplication()
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("kewlmike3@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element
      secureTextField.tap()
      secureTextField.typeText("michael")
      app.buttons["Go"].tap()
      XCTAssertEqual(loginButton.value as! String, "")
      loginButton.tap()
      XCTAssertEqual(loginButton.exists, false)
      
   }
   
   func testLoginWithInvalidEmail(){
      
      let app = XCUIApplication()
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("kewlmike@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element
      secureTextField.tap()
      secureTextField.typeText("michael")
      app.buttons["Go"].tap()
      XCTAssertEqual(loginButton.value as! String, "")
//      XCTAssertThrowsError(try loginButton.tap())
      XCTAssertEqual(loginButton.exists, true)
   }

}
