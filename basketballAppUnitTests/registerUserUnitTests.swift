//
//  registerUserUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Mike White on 11/29/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class registerUserUnitTests: XCTestCase {

   var viewController: UserAuthViewController!
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "RegisterPage") as! UserAuthViewController)
      let _ = viewController.view
   }
   
   override func tearDown() {
      super.tearDown()
      viewController = nil
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

   func testElementsExistWithFormatting(){
      
      // Text Fields
      XCTAssert(viewController.registerEmail.isEnabled)
      XCTAssert(viewController.registerPass.isEnabled)
      XCTAssert(viewController.registerPassCheck.isEnabled)
      XCTAssert(viewController.teamName.isEnabled)
      
      // Buttons
      XCTAssert(viewController.signUpButton.isEnabled)
      XCTAssert(viewController.backToLogin.isEnabled)
      
      // Labels
      XCTAssert(viewController.validityLabel.isEnabled)
      XCTAssert(viewController.validityLabel.text == "")
      XCTAssert(viewController.passwordMatchLabel.isEnabled)
      XCTAssert(viewController.passwordMatchLabel.text == "")
      XCTAssert(viewController.createAccount.text == "Create an account")
      
   }
   
   func testPasswordCheckColors(){
      
      viewController.registerPass.text = "password"
      viewController.registerPassCheck.text = "password"
      
      viewController.passwordCheck()
      
      XCTAssertEqual(viewController.passwordMatchLabel.textColor, UIColor.green)
      XCTAssertTrue(viewController.passwordMatchLabel.text == "Passwords Match")
      
      viewController.registerPassCheck.text = "Password"
      
      viewController.passwordCheck()
      
      XCTAssertEqual(viewController.passwordMatchLabel.textColor, UIColor.red)
      XCTAssertTrue(viewController.passwordMatchLabel.text == "Passwords Don't Match")
   }
   
   func testEmailCheckColors(){
      
      viewController.registerEmail.text = "123@gmail.com"
      
      viewController.emailCheck()
      
      XCTAssertEqual(viewController.validityLabel.textColor, UIColor.green)
      XCTAssertTrue(viewController.validityLabel.text == "Valid")
      
      viewController.registerEmail.text = "123"
      
      viewController.emailCheck()
      
      XCTAssertEqual(viewController.validityLabel.textColor, UIColor.red)
      XCTAssertTrue(viewController.validityLabel.text == "Invalid")
   }
   
   func testEmailStringEmpty(){
      
      viewController.registerEmail.text = ""
      
      XCTAssertFalse(viewController.emailStringCheck())
   }
   
   func testEmailStringNonEmptyNoAtSign(){
      
      viewController.registerEmail.text = "123gmail.com"
      
      XCTAssertFalse(viewController.emailStringCheck())
   }
   
   func testEmailStringNonEmptyAtSignAndCom(){
      
      viewController.registerEmail.text = "123@.com"
      
      XCTAssertFalse(viewController.emailStringCheck())
   }
   
   func testEmailStringNonEmptyNoCom(){
      
      viewController.registerEmail.text = "123@gmailcom"
      
      XCTAssertFalse(viewController.emailStringCheck())
      
      viewController.registerEmail.text = "123@gmail."
      
      XCTAssertFalse(viewController.emailStringCheck())
   }
   
   func testEmailStringCorrect(){
      viewController.registerEmail.text = "123@gmail.com"
      
      XCTAssertTrue(viewController.emailStringCheck())
   }
   
   func testViewHasGesture(){
      
      // Assert the number of gestures the view has is 1
      XCTAssert((viewController.view.gestureRecognizers?.capacity)! == 1)
   }
   
   func testKeyboardShiftsViewUpAndBackDown(){
      let notification = UIResponder.keyboardWillChangeFrameNotification
      
      let framePos = viewController.view.frame.origin.y
      
      viewController.keyboardWillChange(notification: Notification(name: notification))
      
      XCTAssertNotEqual(framePos, viewController.view.frame.origin.y)
      
      let notificationBack = UIResponder.keyboardWillHideNotification
      
      let framePosNow = viewController.view.frame.origin.y
      
      viewController.keyboardWillChange(notification: Notification(name:notificationBack))
      
      XCTAssertNotEqual(framePosNow, viewController.view.frame.origin.y)
      
      XCTAssertNotEqual(framePosNow, framePos)
   }

}
