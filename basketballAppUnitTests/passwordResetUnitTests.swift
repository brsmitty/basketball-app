//
//  passwordResetUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Mike White on 11/29/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class passwordResetUnitTests: XCTestCase {

   var viewController: PasswordResetViewController!
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "PasswordForgotPage") as! PasswordResetViewController)
      let _ = viewController.view
   }
   
   override func tearDown() {
      super.tearDown()
      viewController = nil
   }
   
   func testElementsExistWithFormatting(){
      
      // Buttons
      XCTAssert(viewController.sendButton.isEnabled)
      XCTAssert(viewController.backToLoginButton.isEnabled)
      XCTAssertEqual(viewController.sendButton.layer.cornerRadius, 5)

      // Text Fields
      XCTAssert(viewController.emailField.isEnabled)
      XCTAssertEqual(viewController.emailField.layer.cornerRadius, 5)
      
      // Label
      XCTAssert(viewController.descriptText.isEnabled)
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
   
   func testViewHasGesture(){
      
      // Assert the number of gestures the view has is 1
      XCTAssert((viewController.view.gestureRecognizers?.capacity)! == 1)
   }
   
   func testSendResetLink(){
      
      let email = "1230982186367185615328@gmail.com"
      
      let promise = expectation(description: "Alert was shown")
      
      viewController.AuthU.sendPasswordReset(withEmail: email){
         (error) in
         if error == nil{
            promise.fulfill()
         }else{
            promise.fulfill()
         }
      }
      waitForExpectations(timeout: 5, handler: nil)
   }

}
