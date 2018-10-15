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
   
   func testUserRegistrationWithValidEmailPasswordAndTeamName(){
      
      let app = XCUIApplication()
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("mkwhite401@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.tap()
      secureTextField.typeText("michael7")
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.tap()
      secureTextField2.typeText("michael7")
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.tap()
      textField.typeText("Gators")
      app.buttons["Go"].tap()
      
      app.buttons["REGISTER"].tap()
      
   }
   
   func testUserRegistrationWithInValidEmail(){
      
      let app = XCUIApplication()
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("mkwhite401.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.tap()
      secureTextField.typeText("michael7")
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.tap()
      secureTextField2.typeText("michael7")
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.tap()
      textField.typeText("Gators")
      app.buttons["Go"].tap()
      
      app.buttons["REGISTER"].tap()
      
      XCTAssertTrue(app.alerts["Registration Failed"].exists)
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func testUserRegistrationWithEmptyEmail(){
      
      let app = XCUIApplication()
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.tap()
      secureTextField.typeText("michael7")
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.tap()
      secureTextField2.typeText("michael7")
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.tap()
      textField.typeText("Gators")
      app.buttons["Go"].tap()
      
      app.buttons["REGISTER"].tap()
      
      XCTAssertTrue(app.alerts["Registration Failed"].exists)
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func testUserRegistrationWithInValidPassword(){
      
      let app = XCUIApplication()
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("mkwhite401@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.tap()
      secureTextField.typeText("michael")
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.tap()
      secureTextField2.typeText("michael7")
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.tap()
      textField.typeText("Gators")
      app.buttons["Go"].tap()
      
      app.buttons["REGISTER"].tap()
      
      XCTAssertTrue(app.alerts["Registration Failed"].exists)
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func testUserRegistrationWithInValidPasswordMatch(){
      
      let app = XCUIApplication()
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("mkwhite401@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.tap()
      secureTextField.typeText("michael7")
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.tap()
      secureTextField2.typeText("michael")
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.tap()
      textField.typeText("Gators")
      app.buttons["Go"].tap()
      
      app.buttons["REGISTER"].tap()
      
      XCTAssertTrue(app.alerts["Registration Failed"].exists)
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func testUserRegistrationWithInValidTeamName(){
      
      let app = XCUIApplication()
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("mkwhite401@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.tap()
      secureTextField.typeText("michael7")
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.tap()
      secureTextField2.typeText("michael7")
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.tap()
      textField.typeText("")
      app.buttons["Go"].tap()
      
      app.buttons["REGISTER"].tap()
      
      XCTAssertTrue(app.alerts["Registration Failed"].exists)
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func testForgotPasswordWithValidEmail(){
      
      let app = XCUIApplication()
      app.buttons["Forgot your Password?"].tap()
      app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
      app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.typeText("kewlmike3@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.buttons["SEND LINK"].tap()
      app.alerts["Reset Link Sent!"].buttons["OK"].tap()
      
   }
   
   func testForgotPasswordWithInValidEmail(){
      
      let app = XCUIApplication()
      app.buttons["Forgot your Password?"].tap()
      app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
      app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.typeText("mkwhite401@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.buttons["SEND LINK"].tap()
      XCTAssertTrue(app.alerts["Reset Failed"].exists)
      app.alerts["Reset Failed"].buttons["OK"].tap()
      
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
      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }
   
   func testLoginWithInvalidPassword(){
      
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
      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }
   
   func testLoginWithEmptyPassword(){
      
      let app = XCUIApplication()
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("kewlmike3@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element
      secureTextField.tap()
      secureTextField.typeText("")
      app.buttons["Go"].tap()
      XCTAssertEqual(loginButton.value as! String, "")
      loginButton.tap()
      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }
   
   func testLoginWithEmptyEmail(){
      
      let app = XCUIApplication()
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element
      secureTextField.tap()
      secureTextField.typeText("michael7")
      app.buttons["Go"].tap()
      XCTAssertEqual(loginButton.value as! String, "")
      loginButton.tap()
      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }
   
   func testLoginWithEmptyEmailAndPassword(){
      
      let app = XCUIApplication()
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element
      secureTextField.tap()
      secureTextField.typeText("")
      app.buttons["Go"].tap()
      XCTAssertEqual(loginButton.value as! String, "")
      loginButton.tap()
      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }

   func testNavigationLinks(){
      
      let app = XCUIApplication()
      app.buttons["Forgot your Password?"].tap()
      
      let backToLoginButton = app.buttons["< Back to Login"]
      backToLoginButton.tap()
      app.buttons["REGISTER"].tap()
      backToLoginButton.tap()
   }
}
