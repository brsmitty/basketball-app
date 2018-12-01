//
//  middleViewUnitTests.swift
//  basketballAppUnitTests
//
//  Created by David on 11/30/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class middleViewUnitTests: XCTestCase {

    var viewController: MiddleViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = (storyboard.instantiateViewController(withIdentifier: "MiddleView") as! MiddleViewController)
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
    
    func testElementsLoaded() {
        XCTAssertNotNil(viewController.settingsBtn)
        XCTAssertNotNil(viewController.kpiBtn)
        XCTAssertNotNil(viewController.performanceBtn)
        XCTAssertNotNil(viewController.playbookBtn)
        XCTAssertNotNil(viewController.gameTimeBtn)
        XCTAssertNotNil(viewController.scheduleBtn)
        XCTAssertNotNil(viewController.playerManagerBtn)
        XCTAssertNotNil(viewController.welcomeBar)
        XCTAssertNotNil(viewController.settingsView)
    }
    
    func testGestureRecognizerLoaded() {
        XCTAssertNotNil(viewController.tapGesture)
    }
    
    func testPlayerManagerSegueExists() {
        XCTAssert(hasSegueWithIdentifier(id: "playerManagerSegue"))
    }
    
    func testPerformanceSegueExists() {
        XCTAssert(hasSegueWithIdentifier(id: "performanceSegue"))
    }
    
    func testGameTimeSegueExists() {
        XCTAssert(hasSegueWithIdentifier(id: "gameTimeSegue"))
    }
    
    func testKpiSegueExists() {
        XCTAssert(hasSegueWithIdentifier(id: "kpiSegue"))
    }
    
    func testScheduleSegueExists() {
        XCTAssert(hasSegueWithIdentifier(id: "scheduleSegue"))
    }
    
    func testPlaybookSegueExists() {
        XCTAssert(hasSegueWithIdentifier(id: "playbookSegue"))
    }
    
    func testSettingsSegueExists() {
        XCTAssert(hasSegueWithIdentifier(id: "settingsSegue"))
    }
    
    func testOpenSettings() {
        viewController.openSettings(viewController.settingsBtn)
        XCTAssert(!viewController.settingsView.isHidden)
    }
    
    func testCloseSettings() {
        viewController.closeSettings(viewController.tapGesture)
        XCTAssert(viewController.settingsView.isHidden)
    }
    
    func testGameIsUsers() {
        viewController.uid = "5fsdf238r2832848283482848234"
        XCTAssert(viewController.gameIsUsers("5fsdf238r2832848283482848234-23"))
    }
}
