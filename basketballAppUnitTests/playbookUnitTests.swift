//
//  playbookUnitTests.swift
//  basketballAppUnitTests
//
//  Created by David on 12/1/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class playbookUnitTests: XCTestCase {
   
   var viewController: PlaybookDetailViewController!
   
   override func setUp() {
      super.setUp()
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "playbookDetailView") as! PlaybookDetailViewController)
      let _ = viewController.view
   }
   override func tearDown() {
      super.tearDown()
      viewController = nil
   }

//   func testElementAndGestureLoaded() {
//      XCTAssertNotNil(viewController.addButton)
//      XCTAssertEqual(viewController.addButton.layer.cornerRadius, 5)
//      //XCTAssertNotNil(viewController.view.gestureRecognizers!)
//   }
   
}
