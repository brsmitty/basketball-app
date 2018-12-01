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
        viewController = (storyboard.instantiateViewController(withIdentifier: "GameView") as! ShotChartViewController)
        let _ = viewController.view
    }
    
    override func tearDown() {
        super.tearDown()
        viewController = nil
    }


    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testShotSelect(){
        var shotLocation: CGPoint = CGPoint.init()
        viewController.determineThreePoint
    }

}
