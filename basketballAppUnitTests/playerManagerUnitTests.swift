//
//  playerManagerUnitTests.swift
//  basketballAppUnitTests
//
//  Created by David on 12/1/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class playerManagerUnitTests: XCTestCase {
    var viewController: PlayerManagerViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = (storyboard.instantiateViewController(withIdentifier: "PlayerManagerViewController") as! PlayerManagerViewController)
        let _ = viewController.view
    }
    
    override func tearDown() {
        super.tearDown()
        viewController = nil
    }

    func testTextFieldDidBeginEditing() {
        
    }
}
