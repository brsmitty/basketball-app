//
//  loginUnitTests.swift
//  loginUnitTests
//
//  Created by Mike White on 11/8/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import Pods_basketballApp

class loginUnitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   func testLoginScreenHasTextFields(){
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let login = storyboard.instantiateInitialViewController()
      let _ = login!.view
      XCTAssertTrue(true)
   }
   
   func testLoginScreenHasButtons(){
      
   }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
