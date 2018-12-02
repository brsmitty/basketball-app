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

   func testElementsExistWithFormatting(){
      XCTAssertNotNil(viewController.addButton)
      XCTAssertNotNil(viewController.nameLabel)
      XCTAssertNotNil(viewController.fileLabel)
      
      XCTAssertNotNil(viewController.FileName)
      XCTAssertNotNil(viewController.PlaybookName)
      
      XCTAssertEqual(viewController.PlaybookName.layer.cornerRadius, 5)
      XCTAssertEqual(viewController.FileName.layer.cornerRadius, 5)
      XCTAssertEqual(viewController.addButton.layer.cornerRadius, 5)
      
   }
   
   func testViewHasGesture(){
      XCTAssertNotNil(viewController.view.gestureRecognizers)
   }
   
}
