//
//  scheduleViewControllerTests.swift
//  basketballAppUnitTests
//
//  Created by Mike White on 12/1/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class scheduleViewControllerTests: XCTestCase {

   var viewController: ScheduleViewController!
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "ScheduleRootViewController") as! ScheduleViewController)
      let _ = viewController.view
   }
   
   override func tearDown() {
      super.tearDown()
      viewController = nil
   }
   
   func hasSegueWithIdentifier(id: String) -> Bool {
      let segues = viewController.value(forKey: "storyboardSegueTemplates") as? [NSObject]
      let filtered = segues?.filter({ $0.value(forKey: "identifier") as? String == id })
      return filtered!.count > 0
   }
   
   func testElementsExistWithFormatting(){
      
      // Buttons
      XCTAssertNotNil(viewController.gameTimeButton)
      XCTAssertNotNil(viewController.mainMenuButton)
      XCTAssertNotNil(viewController.playbookButton)
      XCTAssertNotNil(viewController.playerManagerButton)
      XCTAssertNotNil(viewController.scheduleButton)
      XCTAssertNotNil(viewController.performanceButton)
      XCTAssertNotNil(viewController.backButton)
      XCTAssertNotNil(viewController.kpiButton)
   }
   
   func testMainMenuSegue(){
      XCTAssert(hasSegueWithIdentifier(id: "mainMenu"))
   }
   
   func testPlaybookSegue(){
      XCTAssert(hasSegueWithIdentifier(id: "playbook"))
   }
   
   func testGameViewSegue(){
      XCTAssert(hasSegueWithIdentifier(id: "gameView"))
   }
   
   func testPlayerManagerSegue(){
      XCTAssert(hasSegueWithIdentifier(id: "playerManager"))
   }
   
   func testPerformanceSegue(){
      XCTAssert(hasSegueWithIdentifier(id: "performanceSegue"))
   }
   
   func testKPISegue(){
      XCTAssert(hasSegueWithIdentifier(id: "kpiSegue"))
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
