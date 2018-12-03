//
//  kpiIntegrationTests.swift
//  basketballAppIntegrationTests
//
//  Created by David on 12/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class kpiIntegrationTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name: "Main", bundle: nil)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testUidTidPassedFromKpiViewToPlaybookView() {
        let src = storyboard.instantiateViewController(withIdentifier: "kpiView") as! kpiViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "Playbook") as! PlaybookMasterViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "playbook", source: src, destination: dest)
        
         src.uid = "4afks9df92k3eads0k"
         src.tid = "12392949234923234"
         src.prepare(for: seg, sender: src)
         
         XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
         XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromKpiViewToPlayerManagerView() {
        let src = storyboard.instantiateViewController(withIdentifier: "kpiView") as! kpiViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "PlaybookManagerViewController") as! PlayerManagerViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "playerManager", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromKpiViewToPerformanceView() {
        let src = storyboard.instantiateViewController(withIdentifier: "kpiView") as! kpiViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "performanceView") as! PerformanceViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "performanceSegue", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromKpiViewToGameView() {
        let src = storyboard.instantiateViewController(withIdentifier: "kpiView") as! kpiViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "GameView") as! GameViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "gameView", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromKpiViewToScheduleView() {
        let src = storyboard.instantiateViewController(withIdentifier: "kpiView") as! kpiViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "ScheduleRootViewController") as! ScheduleViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "schedule", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromKpiViewToMiddleView() {
        let src = storyboard.instantiateViewController(withIdentifier: "kpiView") as! kpiViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "MiddleView") as! MiddleViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "mainMenu", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
}
