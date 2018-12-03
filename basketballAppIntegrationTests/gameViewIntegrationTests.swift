//
//  basketballAppIntegrationTests.swift
//  basketballAppIntegrationTests
//
//  Created by Mike White on 12/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class gameViewIntegrationTests: XCTestCase {
    
    var vc: GameViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = (storyboard.instantiateViewController(withIdentifier: "GameView") as! GameViewController)
        let _ = vc.view
    }
    
    override func tearDown() {
        super.tearDown()
        vc = nil
    }
    
    func testGameStatePassedToShotChart() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: "ShotChartViewController") as! ShotChartViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "shotchartSegue", source: vc, destination: targetVC)
        vc.gameState["possession"] = "testString"
        vc.prepare(for: seg, sender: vc)
        XCTAssertEqual("testString", targetVC.gameState["possession"] as! String)
    }
    
    func testGameStatePassedToFreeThrow() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: "FreeThrowView") as! FreethrowViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "freethrowSegue", source: vc, destination: targetVC)
        vc.gameState["possession"] = "testString"
        vc.prepare(for: seg, sender: vc)
        XCTAssertEqual("testString", targetVC.gameState["possession"] as! String)
    }
    
    func testGameStatePassedToGameViewFromShotChart() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: "ShotChartViewController") as! ShotChartViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "gameviewSegue", source: targetVC, destination: vc)
        targetVC.gameState["possession"] = "testString"
        targetVC.prepare(for: seg, sender: targetVC)
        XCTAssertEqual("testString", vc.gameState["possession"] as! String)
    }
    
    func testGameStatePassedToGameViewFromFreeThrow() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: "FreeThrowView") as! FreethrowViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "gameviewSegue2", source: targetVC, destination: vc)
        targetVC.gameState["possession"] = "testString"
        targetVC.prepare(for: seg, sender: targetVC)
        XCTAssertEqual("testString", vc.gameState["possession"] as! String)
    }
    
    func testUidTidPassedFromGameViewToMiddleView() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let src = storyboard.instantiateViewController(withIdentifier: "GameView") as! GameViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "MiddleView") as! MiddleViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "mainMenu", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    
}
