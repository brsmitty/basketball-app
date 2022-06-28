//
//  shortChartViewUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Maggie Zhang on 12/1/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class shortChartViewUnitTests: XCTestCase {
    var viewController: ShotChartViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = (storyboard.instantiateViewController(withIdentifier: "ShotChartViewController") as! ShotChartViewController)
        let _ = viewController.view
    }
    
    override func tearDown() {
        super.tearDown()
        viewController = nil
    }
    
   func testThreePointShots1(){
      var shotLocation: CGPoint = CGPoint.init()
      shotLocation.x = 105
      shotLocation.y = 100
      XCTAssertFalse(viewController.determineThreePoint(location: shotLocation))
   }
   func testThreePointShots2(){
      var shotLocation: CGPoint = CGPoint.init()
      shotLocation.x = 100
      shotLocation.y = 600
      XCTAssertTrue(viewController.determineThreePoint(location: shotLocation))
   }
   func testThreePointShots3(){
      var shotLocation: CGPoint = CGPoint.init()
      shotLocation.x = 50
      shotLocation.y = 100
      XCTAssertTrue(viewController.determineThreePoint(location: shotLocation))
   }
   func testThreePointShots4(){
      var shotLocation: CGPoint = CGPoint.init()
      shotLocation.x = 550
      shotLocation.y = 600
      XCTAssertTrue(viewController.determineThreePoint(location: shotLocation))
   }

    func testThreePointShots5(){
       var shotLocation: CGPoint = CGPoint.init()
       shotLocation.x = 0
       shotLocation.y = 0
       XCTAssertTrue(viewController.determineThreePoint(location: shotLocation))
    }
}
