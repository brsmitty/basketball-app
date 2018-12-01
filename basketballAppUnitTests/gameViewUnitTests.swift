//
//  gameViewUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Maggie Zhang on 12/1/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class gameViewUnitTests: XCTestCase {
   
    var viewController: GameViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = (storyboard.instantiateViewController(withIdentifier: "GameView") as! GameViewController)
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
    
    func testPassingBall(){
        viewController.gameState["possession"] = "offense"
        var tempArray:[Player] = []
        let p: Player = Player.init(firstName: "", lastName: "", photo: nil, position: "", height: "", weight: "", rank: "", playerId: "", teamId: "")
        tempArray.append(p)
        tempArray.append(p)
        tempArray.append(p)
        tempArray.append(p)
        tempArray.append(p)
        viewController.gameState["active"] = tempArray
        viewController.gameState["ballIndex"] = 0
        viewController.pass(to: 2)
        XCTAssertEqual(viewController.gameState["ballIndex"] as! Int, 2)
        XCTAssertEqual(viewController.gameState["assistingPlayerIndex"] as! Int, 0)
    }
    
    func testHandleTurnOverOffense(){
        let temp = UIButton()
        viewController.gameState["possession"] = "offense"
        viewController.handleTurnover(temp)
        XCTAssertEqual(viewController.gameState["possession"] as! String, "defense")
    }
    
    func testHandleTurnOverDefense(){
        let temp = UIButton()
        viewController.gameState["possession"] = "defense"
        viewController.handleTurnover(temp)
        XCTAssertEqual(viewController.gameState["possession"] as! String, "offense")
    }

    func testSwitchToDefense1(){
        viewController.imageHoop.center.y = 0
        viewController.imagePlayer1.center.y = 0
        viewController.imagePlayer2.center.y = 0
        viewController.imagePlayer3.center.y = 0
        viewController.imagePlayer4.center.y = 0
        viewController.imagePlayer5.center.y = 0
        viewController.gameState["oppFullTimeouts"] = 0
        viewController.gameState["oppHalfTimeouts"] = 0
        viewController.switchToDefense()
        XCTAssertEqual(viewController.gameState["possession"] as! String, "defense")
        XCTAssertEqual(viewController.imageHoop.center.y, 400)
        XCTAssertEqual(viewController.imagePlayer1.center.y, 400)
        XCTAssertEqual(viewController.imagePlayer2.center.y, -100)
        XCTAssertEqual(viewController.imagePlayer3.center.y, -350)
        XCTAssertEqual(viewController.imagePlayer4.center.y, -100)
        XCTAssertEqual(viewController.imagePlayer5.center.y, 400)
        XCTAssertFalse(viewController.timeoutButton.isEnabled)
    }
    
    func testSwitchToDefense2(){
        viewController.imageHoop.center.y = 10
        viewController.imagePlayer1.center.y = 10
        viewController.imagePlayer2.center.y = 0
        viewController.imagePlayer3.center.y = 0
        viewController.imagePlayer4.center.y = 0
        viewController.imagePlayer5.center.y = 10
        viewController.gameState["oppFullTimeouts"] = 10
        viewController.gameState["oppHalfTimeouts"] = 10
        viewController.switchToDefense()
        XCTAssertEqual(viewController.gameState["possession"] as! String, "defense")
        XCTAssertEqual(viewController.imageHoop.center.y, 410)
        XCTAssertEqual(viewController.imagePlayer1.center.y, 410)
        XCTAssertEqual(viewController.imagePlayer2.center.y, -100)
        XCTAssertEqual(viewController.imagePlayer3.center.y, -350)
        XCTAssertEqual(viewController.imagePlayer4.center.y, -100)
        XCTAssertEqual(viewController.imagePlayer5.center.y, 410)
        XCTAssertTrue(viewController.timeoutButton.isEnabled)
    }
    
    func testSwitchToOffense1(){
        viewController.imageHoop.center.y = 0
        viewController.imagePlayer1.center.y = 0
        viewController.imagePlayer2.center.y = 0
        viewController.imagePlayer3.center.y = 0
        viewController.imagePlayer4.center.y = 0
        viewController.imagePlayer5.center.y = 0
        viewController.gameState["fullTimeouts"] = 0
        viewController.gameState["halfTimeouts"] = 0
        viewController.switchToOffense()
        XCTAssertEqual(viewController.gameState["possession"] as! String, "offense")
        XCTAssertEqual(viewController.imageHoop.center.y, -400)
        XCTAssertEqual(viewController.imagePlayer1.center.y, -400)
        XCTAssertEqual(viewController.imagePlayer2.center.y, 100)
        XCTAssertEqual(viewController.imagePlayer3.center.y, 350)
        XCTAssertEqual(viewController.imagePlayer4.center.y, 100)
        XCTAssertEqual(viewController.imagePlayer5.center.y, -400)
        XCTAssertFalse(viewController.timeoutButton.isEnabled)
        
    }
    
    func testSwitchToOffense2(){
        viewController.imageHoop.center.y = 0
        viewController.imagePlayer1.center.y = 0
        viewController.imagePlayer2.center.y = 0
        viewController.imagePlayer3.center.y = 0
        viewController.imagePlayer4.center.y = 0
        viewController.imagePlayer5.center.y = 0
        viewController.switchToOffense()
        XCTAssertEqual(viewController.gameState["possession"] as! String, "offense")
        XCTAssertEqual(viewController.imageHoop.center.y, -400)
        XCTAssertEqual(viewController.imagePlayer1.center.y, -400)
        XCTAssertEqual(viewController.imagePlayer2.center.y, 100)
        XCTAssertEqual(viewController.imagePlayer3.center.y, 350)
        XCTAssertEqual(viewController.imagePlayer4.center.y, 100)
        XCTAssertEqual(viewController.imagePlayer5.center.y, -400)
        XCTAssertTrue(viewController.timeoutButton.isEnabled)
    }
    
    func testRoundImages(){
        viewController.imagePlayer1.frame.size.width = 10
        viewController.roundImages()
        XCTAssertTrue(viewController.imagePlayer1.clipsToBounds)
        XCTAssertTrue(viewController.imagePlayer1.clipsToBounds)
        XCTAssertTrue(viewController.imagePlayer1.clipsToBounds)
        XCTAssertTrue(viewController.imagePlayer1.clipsToBounds)
        XCTAssertTrue(viewController.imagePlayer1.clipsToBounds)
        XCTAssertEqual(viewController.imagePlayer1.layer.cornerRadius, 5)
        XCTAssertEqual(viewController.imagePlayer2.layer.cornerRadius, 5)
        XCTAssertEqual(viewController.imagePlayer3.layer.cornerRadius, 5)
        XCTAssertEqual(viewController.imagePlayer4.layer.cornerRadius, 5)
        XCTAssertEqual(viewController.imagePlayer5.layer.cornerRadius, 5)
    }
    
    func testPushPlaySequence(){
        var playSequence = viewController.gameState["playSequence"] as! [String]
        playSequence.append("TEST")
        viewController.pushPlaySequence(event: "TEST")
        XCTAssertEqual(viewController.displayLabel.text, "TEST")
        XCTAssertEqual(viewController.gameState["playSequence"] as! [String], playSequence)
    }
    
    func testHandleJumpball1(){
        viewController.status = true
        viewController.gameState["began"] = false
        viewController.gameState["stateIndex"] = 0
        
        viewController.handleJumpball(index: 0)
     XCTAssertEqual(viewController.gameState["stateIndex"] as! Int, 1)
     XCTAssertEqual(viewController.states[1], viewController.gameStateBoard.text)
        XCTAssertEqual(viewController.states[1], viewController.gameState["quarterIndex"] as!String)
        XCTAssertTrue(viewController.gameState["began"] as! Bool)
      XCTAssertEqual(viewController.gameState["ballIndex"] as! Int, 0)
        
        
        
    }
    
    func testHandleJumpball2(){
        viewController.status = true
        viewController.gameState["began"] = true
        viewController.gameState["stateIndex"] = 0
        viewController.gameState["possessionArrow"] = "defense"
        
        viewController.handleJumpball(index: 0)
        XCTAssertEqual(viewController.gameState["stateIndex"] as! Int, 1)
        XCTAssertEqual(viewController.states[1], viewController.gameStateBoard.text)
        XCTAssertEqual(viewController.states[1], viewController.gameState["quarterIndex"] as!String)
        XCTAssertEqual(viewController.gameState["possessionArrow"] as! String, "offense")
    }
    
    func testHandleJumpball3(){
        viewController.status = true
        viewController.gameState["began"] = true
        viewController.gameState["stateIndex"] = 0
        viewController.gameState["possessionArrow"] = "offense"
        
        viewController.handleJumpball(index: 0)
        XCTAssertEqual(viewController.gameState["stateIndex"] as! Int, 1)
        XCTAssertEqual(viewController.states[1], viewController.gameStateBoard.text)
        XCTAssertEqual(viewController.states[1], viewController.gameState["quarterIndex"] as!String)
        XCTAssertEqual(viewController.gameState["possessionArrow"] as! String, "defense")
    }
    
    func isNewLineup(){
        XCTAssertTrue(viewController.isNewLineup())
    }
    
    func testHandleFoul1(){
        let p: Player = Player.init(firstName: "", lastName: "", photo: nil, position: "", height: "", weight: "", rank: "", playerId: "", teamId: "")
        viewController.gameState["teamFouls"] = 0
        viewController.handleFoul(player: p)
        XCTAssertEqual(viewController.gameState["fouledPlayer"] as! Player, p)
        XCTAssertEqual(viewController.gameState["teamFouls"] as! Int, 1)
        XCTAssertEqual(viewController.homeFouls.text, "01")
    }
    
    func testHandleFoul2(){
        let p: Player = Player.init(firstName: "", lastName: "", photo: nil, position: "", height: "", weight: "", rank: "", playerId: "", teamId: "")
        viewController.gameState["teamFouls"] = 10
        viewController.handleFoul(player: p)
        XCTAssertEqual(viewController.gameState["fouledPlayer"] as! Player, p)
        XCTAssertEqual(viewController.gameState["teamFouls"] as! Int, 11)
        XCTAssertEqual(viewController.homeScore.text!, "11")
    }
    
    func testHandleFoul3(){
        let p: Player = Player.init(firstName: "", lastName: "", photo: nil, position: "", height: "", weight: "", rank: "", playerId: "", teamId: "")
        viewController.gameState["teamFouls"] = 10
        viewController.handleFoul(player: p)
        XCTAssertEqual(viewController.gameState["fouledPlayer"] as! Player, p)
        XCTAssertEqual(viewController.gameState["teamFouls"] as! Int, 11)
        XCTAssertEqual(viewController.homeScore.text, "11")
        XCTAssertEqual(viewController.gameState["fouledPlayer"] as! Player, p)
    }
    
    func testHandleTechFoul1(){
        viewController.gameState["began"] = true
        viewController.gameState["teamFouls"] = 0
        viewController.handleTechFoul(index: 0)
        XCTAssertEqual(viewController.gameState["teamFouls"] as! Int, 1)
        XCTAssertEqual(viewController.homeFouls.text, "01")
        XCTAssertEqual(viewController.gameState["fouledPlayerIndex"] as! Int, 999)
    }
    func testHandleTechFoul2(){
        viewController.gameState["began"] = true
        viewController.gameState["teamFouls"] = 10
        viewController.handleTechFoul(index: 0)
        XCTAssertEqual(viewController.gameState["teamFouls"] as! Int, 11)
        XCTAssertEqual(viewController.homeScore.text!, "11")
        XCTAssertEqual(viewController.gameState["fouledPlayerIndex"] as! Int, 999)
    }
    
    func testHandleCharge(){
        viewController.gameState["began"] = true
        viewController.gameState["possession"] = "defense"
        viewController.gameState["oppCharges"] = 0
        let temp = UIButton()
        viewController.handleCharge(temp)
        XCTAssertEqual(viewController.gameState["oppCharges"] as! Int, 1)
    }
    
    func testRestart(){
        viewController.quarterTime = 10
        viewController.restart()
        XCTAssertTrue(viewController.status)
        XCTAssertEqual(viewController.gameState["startTime"] as! Int, 0)
        XCTAssertEqual(viewController.time, 0)
        XCTAssertEqual(viewController.elapsed, 0)
        XCTAssertEqual(viewController.labelSecond.text, "00")
        XCTAssertEqual(viewController.labelMinute.text, "10")
    }
    
    func testStop(){
        viewController.stop()
        XCTAssertEqual(viewController.status, true)
    }
    
    func testStart(){
        viewController.status = true
        viewController.start()
        XCTAssertEqual(viewController.status, false)
    }
    
}
