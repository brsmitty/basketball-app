//
//  basketballAppUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Mike White on 11/29/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
import UIKit
@testable import basketballApp

class userAuthUnitTests: XCTestCase {

   var viewController: UserAuthViewController!
   
    override func setUp() {
      super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "LoginPage") as! UserAuthViewController)
      let _ = viewController.view
    }

    override func tearDown() {
      super.tearDown()
        viewController = nil
    }
   
//   private func waitForElementToAppear(element: XCUIElement,
//                                       file: String = #file, line: UInt = #line) {
//      let existsPredicate = NSPredicate(format: "exists == true")
//      expectation(for: existsPredicate,
//                  evaluatedWith: element, handler: nil)
//      
//      waitForExpectations(timeout: 5) { (error) -> Void in
//         if (error != nil) {
//            let message = "Failed to find \(element) after 5 seconds."
//            self.recordFailure(withDescription: message,
//                               inFile: file, atLine: Int(line), expected: true)
//         }
//      }
//   }
   
   func testElementsExistWithFormatting(){
      
      // Buttons
      XCTAssert(viewController.loginButton.isEnabled)
      XCTAssert(viewController.registerButton.isEnabled)
      XCTAssert(viewController.forgotYourPassword.isEnabled)
      XCTAssertEqual(viewController.loginButton.layer.cornerRadius, 5)
      XCTAssertEqual(viewController.registerButton.layer.cornerRadius, 5)

      
      // Text Fields
      XCTAssert(viewController.loginPass.isEnabled)
      XCTAssertEqual(viewController.loginPass.layer.cornerRadius, 5)
      XCTAssert(viewController.loginEmail.isEnabled)
      XCTAssertEqual(viewController.loginEmail.layer.cornerRadius, 5)
      
      
      // Image
      XCTAssert(!viewController.ballIcon.isEqual(nil))
      XCTAssertEqual(viewController.ballIcon.image, UIImage(named: "ballIconV2"))
      
      
      // Label
      XCTAssertEqual(viewController.appName.text, "LUDIS")
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
