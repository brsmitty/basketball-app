//
//  gameViewUnitTests.swift
//  basketballAppUnitTests
//
//  Created by David on 12/1/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class gameViewUnitTests: XCTestCase {

    var viewController: GameViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = (storyboard.instantiateViewController(withIdentifier: "GameView") as! GameViewController)
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
    
    func testElementsLoadedWithFormatting() {
        
    }
    
    func testFreethrowSegueExists() {
        XCTAssert(hasSegueWithIdentifier(id: "freethrowSegue"))
    }
    
    func testHandleSwipe() {
        
    }
    
    func testHandlePinch() {
        
    }
    
    func testSwitchToDefense() {
        
    }
    
    func testSwitchToOffense() {
        
    }
    
    func testGetPlayer() {
        
    }
    
    func testUpdateCounter() {
        
    }
    
    func testStart() {
        
    }
    
    func testStop() {
        
    }
    
    func testRestart() {
        
    }
    
    func testSyncPlayerToFirebase() {
        
    }
    
    func testResetBorders() {
        
    }
    
    func testAddBorder() {
        
    }
    
    func testGetPlayerObj(){
        
    }

}
