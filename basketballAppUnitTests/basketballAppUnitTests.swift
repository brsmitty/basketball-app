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

class basketballAppUnitTests: XCTestCase {

   var viewController: UserAuthViewController!
   
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "LoginPage") as! UserAuthViewController)
      let _ = viewController.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
   
   func testButtonsAreThere(){
      
      XCTAssert(viewController.loginButton.isEnabled)
   }

}
