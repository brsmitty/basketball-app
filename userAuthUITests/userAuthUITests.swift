//
//  userAuthUITests.swift
//  userAuthUITests
//
//  Created by Mike White on 10/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import Pods_basketballApp

class userAuthUITests: XCTestCase {
      let app = XCUIApplication()
   private var topLevelUIUtilities: TopLevelUIUtilities!
   
   func test_title_is_emailVerif(){
      let storyboard = UIStoryboard(name: "Mail", bundle: nil)
      let emailVerif = storyboard.instantiateInitialViewController() as! EmailVerificationViewController
      
   }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
      app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      app.terminate()
    }
   
   private func waitForElementToAppear(element: XCUIElement,
                                       file: String = #file, line: UInt = #line) {
      let existsPredicate = NSPredicate(format: "exists == true")
      expectation(for: existsPredicate,
                  evaluatedWith: element, handler: nil)
      
      waitForExpectations(timeout: 5) { (error) -> Void in
         if (error != nil) {
            let message = "Failed to find \(element) after 5 seconds."
            self.recordFailure(withDescription: message,
                                              inFile: file, atLine: Int(line), expected: true)
         }
      }
   }
   
   func test1UserRegistrationWithValidEmailPasswordAndTeamName(){
      

      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("123@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.typeText("123123")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.typeText("123123")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.typeText("numbers")
      app.buttons["Go"].tap()
      
      waitForElementToAppear(element: app.buttons["Resend Code"])
      
      topLevelUIUtilities = TopLevelUIUtilities<UIViewController>()
      topLevelUIUtilities.createUser()
      
      waitForElementToAppear(element: app.staticTexts["Verified!"])

      
   }
   
   func test2UserRegistrationWithInValidEmail(){
      
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("123.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.typeText("123123")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.typeText("123123")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.typeText("numbers")
      app.buttons["Go"].tap()
      
      waitForElementToAppear(element: app.alerts["Registration Failed"])
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func test3UserRegistrationWithEmptyEmail(){
      
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("")
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.tap()
      secureTextField.typeText("123123")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.typeText("123123")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.typeText("numbers")
      app.buttons["Go"].tap()
      
      
      XCTAssertTrue(app.alerts["Registration Failed"].exists)
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func test4UserRegistrationWithInValidPassword(){
      
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("123@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.typeText("1231")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.typeText("123123")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.typeText("numbers")
      app.buttons["Go"].tap()
      
      
      XCTAssertTrue(app.alerts["Registration Failed"].exists)
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func test5UserRegistrationWithInValidPasswordMatch(){
      
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("123@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.tap()
      secureTextField.typeText("123123")
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.tap()
      secureTextField2.typeText("12")
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.tap()
      textField.typeText("numbers")
      app.buttons["Go"].tap()
      
      
      XCTAssertTrue(app.alerts["Registration Failed"].exists)
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func test6UserRegistrationWithInValidTeamName(){
      
      app.buttons["REGISTER"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
      element.children(matching: .textField).element(boundBy: 0).tap()
      element.children(matching: .textField).element(boundBy: 0).typeText("123@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = element.children(matching: .secureTextField).element(boundBy: 0)
      secureTextField.tap()
      secureTextField.typeText("123123")
      
      let secureTextField2 = element.children(matching: .secureTextField).element(boundBy: 1)
      secureTextField2.tap()
      secureTextField2.typeText("123123")
      
      let textField = element.children(matching: .textField).element(boundBy: 1)
      textField.tap()
      textField.typeText("")
      app.buttons["Go"].tap()
      
      XCTAssertTrue(app.alerts["Registration Failed"].exists)
      app.alerts["Registration Failed"].buttons["OK"].tap()
      
   }
   
   func test7ForgotPasswordWithValidEmail(){
      
      app.buttons["Forgot your Password?"].tap()
      app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
      app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.typeText("123@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.alerts["Reset Link Sent!"].buttons["OK"].tap()
      
   }
   
   func test8ForgotPasswordWithInValidEmail(){
      
      app.buttons["Forgot your Password?"].tap()
      app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
      app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.typeText("12@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      XCTAssertTrue(app.alerts["Reset Failed"].exists)
      app.alerts["Reset Failed"].buttons["OK"].tap()
      
   }
   
   func test9LoginWithValidEmail(){
      
      
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("123@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element
      secureTextField.typeText("123123")
      app.buttons["Go"].tap()
      XCTAssertEqual(loginButton.value as! String, "")
      
   }
   
   func test10LoginWithInvalidEmail(){
      
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("12@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element

      secureTextField.typeText("123123")
      app.buttons["Go"].tap()
      XCTAssertEqual(loginButton.value as! String, "")

      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }
   
   func test11LoginWithInvalidPassword(){
      
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("123@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element

      secureTextField.typeText("EFHIWE")
      app.buttons["Go"].tap()
      XCTAssertEqual(loginButton.value as! String, "")

      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }
   
   func test12LoginWithEmptyPassword(){
      
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("123@gmail.com")
      app/*@START_MENU_TOKEN@*/.buttons["Continue"]/*[[".keyboards.buttons[\"Continue\"]",".buttons[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element

      secureTextField.typeText("")
      XCTAssertEqual(loginButton.value as! String, "")
      loginButton.tap()
      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }
   
   func test13LoginWithEmptyEmail(){
      
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("")
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element
      secureTextField.tap()
      secureTextField.typeText("123123")
      loginButton.tap()
      XCTAssertEqual(loginButton.value as! String, "")

      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }
   
   func test14LoginWithEmptyEmailAndPassword(){
      
      let loginButton = app.buttons["LOGIN"]
      
      let bgElementsQuery = app.otherElements.containing(.image, identifier:"BG")
      let loginText = bgElementsQuery.children(matching: .textField).element
      loginText.tap()
      loginText.typeText("")
      
      let secureTextField = bgElementsQuery.children(matching: .secureTextField).element
      secureTextField.tap()
      secureTextField.typeText("")
      loginButton.tap()
      XCTAssertEqual(loginButton.value as! String, "")
      XCTAssertTrue(app.alerts["Sign In Failed"].exists)
      app.alerts["Sign In Failed"].buttons["OK"].tap()
      XCTAssertTrue(loginButton.exists)
   }

   func testNavigationLinks(){
      
      app.buttons["Forgot your Password?"].tap()
      
      let backToLoginButton = app.buttons["< Back to Login"]
      backToLoginButton.tap()
      app.buttons["REGISTER"].tap()
      backToLoginButton.tap()
   }
}
