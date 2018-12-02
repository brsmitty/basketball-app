//
//  basketballAppIntegrationTests.swift
//  basketballAppIntegrationTests
//
//  Created by Mike White on 12/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class userAuthIntegrationTests: XCTestCase {

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

}
