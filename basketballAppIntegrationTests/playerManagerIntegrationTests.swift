//
//  playerManagerIntegrationTests.swift
//  basketballAppIntegrationTests
//
//  Created by David on 12/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class playerManagerIntegrationTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name: "Main", bundle: nil)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testUidTidPassedFromPlayerManagerViewToPlaybookView() {
        let src = storyboard.instantiateViewController(withIdentifier: "PlaybookManagerViewController") as! PlayerManagerViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "Playbook") as! PlaybookMasterViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "playbook", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromPlayerManagerViewToKpiView() {
        let src = storyboard.instantiateViewController(withIdentifier: "PlaybookManagerViewController") as! PlayerManagerViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "kpiView") as! kpiViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "kpiSegue", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromPlayerManagerViewToPerformanceView() {
        let src = storyboard.instantiateViewController(withIdentifier: "PlaybookManagerViewController") as! PlayerManagerViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "performanceView") as! PerformanceViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "performanceSegue", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromPlayerManagerViewToGameView() {
        let src = storyboard.instantiateViewController(withIdentifier: "PlaybookManagerViewController") as! PlayerManagerViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "GameView") as! GameViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "gameView", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromPlayerManagerViewToScheduleView() {
        let src = storyboard.instantiateViewController(withIdentifier: "PlaybookManagerViewController") as! PlayerManagerViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "ScheduleRootViewController") as! ScheduleViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "schedule", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromPlayerManagerViewToMiddleView() {
        let src = storyboard.instantiateViewController(withIdentifier: "PlaybookManagerViewController") as! PlayerManagerViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "MiddleView") as! MiddleViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "mainMenu", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
}
