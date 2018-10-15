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
      secureTextField.typeText("michael7")
      app.buttons["Go"].tap()
      XCTAssertEqual(loginButton.value as! String, "")
      loginButton.tap()
      
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
      loginButton.tap()
      let expectation = XCTestExpectation(description: "testExample")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
         XCTAssertTrue(UIApplication.shared.keyWindow?.rootViewController?.presentedViewController is UIAlertController)
         expectation.fulfill()
      })
      wait(for: [expectation], timeout: 1.5)
//      XCTAssertThrowsError(try loginButton.tap())
   }

}
