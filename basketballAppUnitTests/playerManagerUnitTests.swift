//
//  playerManagerUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Mike White on 12/1/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class playerManagerUnitTests: XCTestCase {

   var viewController: PlayerManagerViewController!
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "PlaybookManagerViewController") as! PlayerManagerViewController)
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
   
   func CreatePlayerAndAddToTableView(){
      let player = Player(firstName: "Lee", lastName: "Light", photo: UIImage(named: "Default"), position: "Point-Guard", height: "5'0\"", weight: "98", rank: "Freshman", playerId: "Oac5aaqc6tULzR9KAB1WYUOLPfQW-4", teamId: "Oac5aaqc6tULzR9KAB1WYUOLPfQW")
      
      viewController.insertPlayerInTableView(player)
   }
   
   func CreatePlayer() -> Player{
      
      let player = Player(firstName: "Lee", lastName: "Light", photo: UIImage(named: "Default"), position: "Point-Guard", height: "5'0\"", weight: "98", rank: "Freshman", playerId: "Oac5aaqc6tULzR9KAB1WYUOLPfQW-4", teamId: "Oac5aaqc6tULzR9KAB1WYUOLPfQW")
      
      player.points = 45
      player.twoPtMade = 25
      player.threePtMade = 20
      player.offRebounds = 10
      player.personalFoul = 4
      player.assists = 13
      player.twoPtAtt = 55
      player.ftAtt = 23
      player.ftMade = 23
      player.techFoul = 0
      player.steals = 10
      player.defRebounds = 2
      player.deflections = 1
      player.blocks = 0
      player.chargesTaken = 0
      
      return player
   }
   
   func testElementsExistWithFormatting(){
      
      // Text Fields
      XCTAssertNotNil(viewController.playerPositionText)
      XCTAssertNotNil(viewController.playerFirstNameText)
      XCTAssertNotNil(viewController.playerLastNameText)
      XCTAssertNotNil(viewController.playerHeightText)
      XCTAssertNotNil(viewController.playerWeightText)
      XCTAssertNotNil(viewController.playerClassText)
      
      XCTAssert(viewController.playerPositionText.layer.cornerRadius == 5)
      XCTAssert(viewController.playerFirstNameText.layer.cornerRadius == 5)
      XCTAssert(viewController.playerLastNameText.layer.cornerRadius == 5)
      XCTAssert(viewController.playerHeightText.layer.cornerRadius == 5)
      XCTAssert(viewController.playerWeightText.layer.cornerRadius == 5)
      XCTAssert(viewController.playerClassText.layer.cornerRadius == 5)
      
      // Buttons
      XCTAssertNotNil(viewController.saveButton)
      XCTAssertNotNil(viewController.editButton)
      XCTAssertNotNil(viewController.addButton)
      XCTAssertNotNil(viewController.cancelButton)
      
      XCTAssert(viewController.saveButton.layer.cornerRadius == 5)
      XCTAssert(viewController.editButton.layer.cornerRadius == 5)
      XCTAssert(viewController.addButton.layer.cornerRadius == 5)
      XCTAssert(viewController.cancelButton.layer.cornerRadius == 5)
      
      XCTAssertNotNil(viewController.backButton)
      XCTAssertNotNil(viewController.gameTimeButton)
      XCTAssertNotNil(viewController.mainMenuButton)
      XCTAssertNotNil(viewController.performanceButton)
      XCTAssertNotNil(viewController.scheduleButton)
      XCTAssertNotNil(viewController.playbookButton)
      XCTAssertNotNil(viewController.kpiButton)
      
      // Labels
      XCTAssertNotNil(viewController.pointsCell)
      XCTAssertNotNil(viewController.twoPoint)
      XCTAssertNotNil(viewController.threePoint)
      XCTAssertNotNil(viewController.oRebound)
      XCTAssertNotNil(viewController.pFouls)
      XCTAssertNotNil(viewController.assistsCell)
      XCTAssertNotNil(viewController.fGoalCell)
      XCTAssertNotNil(viewController.freeThrowMade)
      XCTAssertNotNil(viewController.freeThrowPerc)
      XCTAssertNotNil(viewController.tFoulCell)
      XCTAssertNotNil(viewController.stealsCell)
      XCTAssertNotNil(viewController.dRebound)
      XCTAssertNotNil(viewController.deflectionCell)
      XCTAssertNotNil(viewController.blockCell)
      XCTAssertNotNil(viewController.chargeCell)
      XCTAssertNotNil(viewController.poundsLabel)
      
      // ImageViews
      XCTAssertNotNil(viewController.playerImage)
      
      XCTAssertEqual(viewController.playerImage.image, UIImage(named: "Default"))
      
      // TableViews
      XCTAssertNotNil(viewController.tableView)
      
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
   
   func testScheduleSegue(){
      XCTAssert(hasSegueWithIdentifier(id: "scheduleSegue"))
   }
   
   func testViewHasGesture(){
      
      // Assert the number of gestures the view has is 1
      XCTAssert((viewController.view.gestureRecognizers?.capacity)! == 1)
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

   func testSetEditPlayerFieldsFalse(){
      
      viewController.setEditPlayerFields(to: false)
      
      XCTAssertFalse(viewController.playerPositionText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerFirstNameText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerLastNameText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerHeightText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerWeightText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerClassText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerImage.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerPositionText.isUserInteractionEnabled)
      
   }
   
   func testSetEditPlayerFieldsTrue(){
      
      viewController.setEditPlayerFields(to: true)
      
      XCTAssertTrue(viewController.playerPositionText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerFirstNameText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerLastNameText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerHeightText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerWeightText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerClassText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerImage.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerPositionText.isUserInteractionEnabled)
      
   }
   
   func testPopulateTable(){
      
      let rows = viewController.tableView.numberOfRows(inSection: 0)
      
      CreatePlayerAndAddToTableView()
      
      XCTAssertNotEqual(rows, viewController.tableView.numberOfRows(inSection: 0))
   }
   
   func testPlayerIsUsersTrue(){
      
      let pid = "Oac5aaqc6tULzR9KAB1WYUOLPfQW-5"
      viewController.uid = "Oac5aaqc6tULzR9KAB1WYUOLPfQW"
      
      XCTAssertTrue(viewController.playerIsUsers(pid))
   }
   
   func testPlayerIsUsersFalse(){
      
      let pid = "Oac5aaqc6tULzR9KAB1WYUOLPfQW-5"
      viewController.uid = "Oac5aaqc6tULzR9KAB1WYUOLPf4W"
      
      XCTAssertFalse(viewController.playerIsUsers(pid))
   }
   
   func testSetSaveButtonToTrue(){
      
      viewController.setSaveButton(to: true)
      
      XCTAssertTrue(viewController.saveButton.isEnabled)
      XCTAssertFalse(viewController.saveButton.isHidden)
   }
   
   func testSetSaveButtonToFalse(){
      
      viewController.setSaveButton(to: false)
      
      XCTAssertFalse(viewController.saveButton.isEnabled)
      XCTAssertTrue(viewController.saveButton.isHidden)
   }
   
   func testSetCancelButtonToTrue(){
      
      viewController.setCancelButton(to: true)
      
      XCTAssertTrue(viewController.cancelButton.isEnabled)
      XCTAssertFalse(viewController.cancelButton.isHidden)
   }
   
   func testSetCancelButtonToFalse(){
      
      viewController.setCancelButton(to: false)
      
      XCTAssertFalse(viewController.cancelButton.isEnabled)
      XCTAssertTrue(viewController.cancelButton.isHidden)
   }
   
   func testSetEditButtonToTrue(){
      
      viewController.setEditButton(to: true)
      
      XCTAssertTrue(viewController.editButton.isEnabled)
      XCTAssertFalse(viewController.editButton.isHidden)
   }
   
   func testSetEditButtonToFalse(){
      
      viewController.setEditButton(to: false)
      
      XCTAssertFalse(viewController.editButton.isEnabled)
      XCTAssertTrue(viewController.editButton.isHidden)
   }
   
   func testSetAddButtonToTrue(){
      
      viewController.setAddButton(to: true)
      
      XCTAssertTrue(viewController.addButton.isEnabled)
      XCTAssertFalse(viewController.addButton.isHidden)
   }
   
   func testSetAddButtonToFalse(){
      
      viewController.setAddButton(to: false)
      
      XCTAssertFalse(viewController.addButton.isEnabled)
      XCTAssertTrue(viewController.addButton.isHidden)
   }
   
   func testSetBackButtonToTrue(){
      
      viewController.setBackButton(to: true)
      
      XCTAssertTrue(viewController.backButton.isEnabled)
      XCTAssertFalse(viewController.backButton.isHidden)
   }
   
   func testSetBackButtonToFalse(){
      
      viewController.setBackButton(to: false)
      
      XCTAssertFalse(viewController.backButton.isEnabled)
      XCTAssertTrue(viewController.backButton.isHidden)
   }
   
   func testResetButtonState(){
      
      viewController.resetButtonState()
      
      XCTAssertTrue(viewController.tableView.allowsSelection)
      XCTAssertTrue(viewController.addButton.isEnabled)
      XCTAssertFalse(viewController.addButton.isHidden)
      XCTAssertTrue(viewController.backButton.isEnabled)
      XCTAssertFalse(viewController.backButton.isHidden)
      XCTAssertFalse(viewController.editButton.isEnabled)
      XCTAssertTrue(viewController.editButton.isHidden)
      XCTAssertFalse(viewController.saveButton.isEnabled)
      XCTAssertTrue(viewController.saveButton.isHidden)
      XCTAssertFalse(viewController.cancelButton.isEnabled)
      XCTAssertTrue(viewController.cancelButton.isHidden)
      XCTAssertFalse(viewController.playerPositionText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerFirstNameText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerLastNameText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerHeightText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerWeightText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerClassText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerImage.isUserInteractionEnabled)
      XCTAssertFalse(viewController.playerPositionText.isUserInteractionEnabled)
   }
   
   func testPopulateStats(){
      
      let player = CreatePlayer()
      
      viewController.populateStats(with: player)
      
      XCTAssertEqual(viewController.pointsCell.text, String(45))
      XCTAssertEqual(viewController.twoPoint.text, String(25))
      XCTAssertEqual(viewController.threePoint.text, String(20))
      XCTAssertEqual(viewController.oRebound.text, String(10))
      XCTAssertEqual(viewController.pFouls.text, String(4))
      XCTAssertEqual(viewController.assistsCell.text, String(13))
      XCTAssertEqual(viewController.fGoalCell.text, String(55))
      XCTAssertEqual(viewController.freeThrowPerc.text, String(23))
      XCTAssertEqual(viewController.freeThrowMade.text, String(23))
      XCTAssertEqual(viewController.tFoulCell.text, String(0))
      XCTAssertEqual(viewController.stealsCell.text, String(10))
      XCTAssertEqual(viewController.dRebound.text, String(2))
      XCTAssertEqual(viewController.deflectionCell.text, String(1))
      XCTAssertEqual(viewController.blockCell.text, String(0))
      XCTAssertEqual(viewController.chargeCell.text, String(0))
      
   }
   
   func testDefaultAllStats(){
      
      viewController.defaultStats()
      
      XCTAssertEqual(viewController.pointsCell.text, String(0))
      XCTAssertEqual(viewController.twoPoint.text, String(0))
      XCTAssertEqual(viewController.threePoint.text, String(0))
      XCTAssertEqual(viewController.oRebound.text, String(0))
      XCTAssertEqual(viewController.pFouls.text, String(0))
      XCTAssertEqual(viewController.assistsCell.text, String(0))
      XCTAssertEqual(viewController.fGoalCell.text, String(0))
      XCTAssertEqual(viewController.freeThrowPerc.text, String(0))
      XCTAssertEqual(viewController.freeThrowMade.text, String(0))
      XCTAssertEqual(viewController.tFoulCell.text, String(0))
      XCTAssertEqual(viewController.stealsCell.text, String(0))
      XCTAssertEqual(viewController.dRebound.text, String(0))
      XCTAssertEqual(viewController.deflectionCell.text, String(0))
      XCTAssertEqual(viewController.blockCell.text, String(0))
      XCTAssertEqual(viewController.chargeCell.text, String(0))
      
   }
   
   func testDefaultAllFields(){
      
      viewController.defaultAllFields()
      
      XCTAssertTrue(viewController.playerFirstNameText.text!.isEmpty)
      XCTAssertTrue(viewController.playerLastNameText.text!.isEmpty)
      XCTAssertTrue(viewController.playerHeightText.text!.isEmpty)
      XCTAssertTrue(viewController.playerWeightText.text!.isEmpty)
      XCTAssertTrue(viewController.playerClassText.text!.isEmpty)
      XCTAssertTrue(viewController.playerPositionText.text!.isEmpty)
      XCTAssertEqual(viewController.playerImage.image, UIImage(named: "Default"))
   }
   
   func testGrabPlayerFields(){
      let indextPath = IndexPath(row: viewController.players.count, section: 0)
      viewController.currentPath = indextPath
      let player = CreatePlayer()
      viewController.players.append(player)
      
      viewController.grabPlayerFields()
      
      XCTAssertEqual(viewController.playerFirstNameText.text, player.firstName)
      XCTAssertEqual(viewController.playerLastNameText.text, player.lastName)
      XCTAssertEqual(viewController.playerHeightText.text, player.height)
      XCTAssertEqual(viewController.playerWeightText.text, player.weight)
      XCTAssertEqual(viewController.playerClassText.text, player.rank)
      XCTAssertEqual(viewController.playerPositionText.text, player.position)
   }
   
   func testSetOldPlayerFields(){
      
      let indextPath = IndexPath(row: viewController.players.count, section: 0)
      viewController.currentPath = indextPath
      let player = CreatePlayer()
      viewController.players.append(player)
      
      viewController.grabPlayerFields()
      
      viewController.setOldPlayerFields()
      
      XCTAssertEqual(viewController.playerFirstNameText.text, player.firstName)
      XCTAssertEqual(viewController.playerLastNameText.text, player.lastName)
      XCTAssertEqual(viewController.playerHeightText.text, player.height)
      XCTAssertEqual(viewController.playerWeightText.text, player.weight)
      XCTAssertEqual(viewController.playerClassText.text, player.rank)
      XCTAssertEqual(viewController.playerPositionText.text, player.position)
   }
   
   func testCreatePositionPicker(){
      // createPositionPicker is called on viewDidLoad
      XCTAssertNotNil(viewController.positionPicker)
   }
   
   func testCreateHeightPicker(){
      // createHeightPicker is called on viewDidLoad
      XCTAssertNotNil(viewController.heightPicker)
   }
   
   func testCreateClassPicker(){
      // createClassPicker is called on viewDidLoad
      XCTAssertNotNil(viewController.classPicker)
   }
   
   func testCreateToolbar(){
      
      viewController.createToolbar()
      
      XCTAssertNotNil(viewController.playerPositionText.inputAccessoryView)
      XCTAssertNotNil(viewController.playerHeightText.inputAccessoryView)
      XCTAssertNotNil(viewController.playerClassText.inputAccessoryView)
   }
   
   func testDismissKeyboard(){
      viewController.dismissKeyboard()
      XCTAssertFalse(viewController.view.isFirstResponder)
   }
   
   
   
}
