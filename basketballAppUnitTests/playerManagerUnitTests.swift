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
   
   func populateFields(){
      viewController.playerFirstNameText.text = "Lee"
      viewController.playerLastNameText.text = "Light"
      viewController.playerPositionText.text = "Point-Guard"
      viewController.playerHeightText.text = "5'0\""
      viewController.playerWeightText.text = "98"
      viewController.playerClassText.text = "Freshman"
      viewController.playerImage.image = UIImage(named: "Default")
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
      XCTAssert((viewController.view.gestureRecognizers?.capacity)! > 0)
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
      viewController.createPositionPicker()
      XCTAssertNotNil(viewController.positionPicker)
   }
   
   func testCreateHeightPicker(){
      viewController.createHeightPicker()
      XCTAssertNotNil(viewController.heightPicker)
   }
   
   func testCreateClassPicker(){
      viewController.createClassPicker()
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
   
   func testPickerNumberOfComponents(){
      
      XCTAssertEqual(viewController.numberOfComponents(in: viewController.positionPicker), 1)
      XCTAssertEqual(viewController.numberOfComponents(in: viewController.heightPicker), 1)
      XCTAssertEqual(viewController.numberOfComponents(in: viewController.classPicker), 1)
   }
   
   func testNumberOfRowsInPicker(){
      viewController.createHeightPicker()
      viewController.createClassPicker()
      viewController.createPositionPicker()
      XCTAssertEqual(viewController.pickerView(viewController.positionPicker, numberOfRowsInComponent: 1), viewController.positionNames.count)
      XCTAssertEqual(viewController.pickerView(viewController.heightPicker, numberOfRowsInComponent: 1), viewController.heights.count)
      XCTAssertEqual(viewController.pickerView(viewController.classPicker, numberOfRowsInComponent: 1), viewController.ranks.count)
   }
   
   func testPickerTitleForRow(){
      
      viewController.createHeightPicker()
      viewController.createClassPicker()
      viewController.createPositionPicker()
      
      var i = 0
      for name in viewController.heights {
         XCTAssertEqual(viewController.pickerView(viewController.heightPicker, titleForRow: i, forComponent: 1), name)
         i = i + 1
      }
      
      var j = 0
      for name in viewController.ranks {
         XCTAssertEqual(viewController.pickerView(viewController.classPicker, titleForRow: j, forComponent: 1), name)
         j = j + 1
      }
      
      var k = 0
      for name in viewController.positionNames {
         XCTAssertEqual(viewController.pickerView(viewController.positionPicker, titleForRow: k, forComponent: 1), name)
         k = k + 1
      }
   }
   
   func testDidSelectRowPicker(){
      
      viewController.createHeightPicker()
      viewController.createClassPicker()
      viewController.createPositionPicker()
      
      var i = 0
      for _ in viewController.positionNames {
         viewController.pickerView(viewController.positionPicker, didSelectRow: i, inComponent: 1)
         XCTAssertEqual(viewController.selectedPosition, viewController.positionNames[i])
         XCTAssertEqual(viewController.playerPositionText.text, viewController.selectedPosition)
         i = i + 1
      }
      
      var j = 0
      for _ in viewController.heights {
         viewController.pickerView(viewController.heightPicker, didSelectRow: j, inComponent: 1)
         XCTAssertEqual(viewController.selectedHeight, viewController.heights[j])
         XCTAssertEqual(viewController.playerHeightText.text, viewController.selectedHeight)
         j = j + 1
      }
      
      var k = 0
      for _ in viewController.ranks {
         viewController.pickerView(viewController.classPicker, didSelectRow: k, inComponent: 1)
         XCTAssertEqual(viewController.selectedRank, viewController.ranks[k])
         XCTAssertEqual(viewController.playerClassText.text, viewController.selectedRank)
         k = k + 1
      }
   }
   
   func testDidSelectRowTable(){
      let indexPath = IndexPath(row: viewController.players.count, section: 0)
      CreatePlayerAndAddToTableView()
      viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)
      
      XCTAssertEqual(viewController.playerImage.image , viewController.players[indexPath.row].photo)
      XCTAssertEqual(viewController.playerFirstNameText.text , viewController.players[indexPath.row].firstName)
      XCTAssertEqual(viewController.playerLastNameText.text , viewController.players[indexPath.row].lastName)
      XCTAssertEqual(viewController.playerHeightText.text , viewController.players[indexPath.row].height)
      XCTAssertEqual(viewController.playerWeightText.text , viewController.players[indexPath.row].weight)
      XCTAssertEqual(viewController.playerClassText.text , viewController.players[indexPath.row].rank)
      XCTAssertEqual(viewController.playerPositionText.text , viewController.players[indexPath.row].position)
      
      XCTAssertTrue(viewController.editButton.isEnabled)
      XCTAssertFalse(viewController.editButton.isHidden)
      
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
   
   func testNumberOfSectionsInTableView(){
      XCTAssertEqual(viewController.numberOfSections(in: viewController.tableView),1)
   }
   
   func testNumberOfRowsInSectionForTableView(){
      XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0),viewController.players.count)
   }
   
   func testCellForRowInTableView(){
      let indexPath = IndexPath(row: viewController.players.count, section: 0)
      
      CreatePlayerAndAddToTableView()
      
      XCTAssertEqual((viewController.tableView(viewController.tableView, cellForRowAt: indexPath)as! PlayerTableViewCell).nameLabel.text, "Lee Light")
      XCTAssertEqual((viewController.tableView(viewController.tableView, cellForRowAt: indexPath)as! PlayerTableViewCell).photoImageView!.image, UIImage(named: "Default"))
   }
   
   func testTableViewRowsAreEditable(){
      
      let indexPath = IndexPath(row: viewController.players.count, section: 0)
      
      CreatePlayerAndAddToTableView()
      
      XCTAssertTrue(viewController.tableView(viewController.tableView, canEditRowAt: indexPath))
   }
   
   func testDeleteRowFromTableView(){
      
      let indexPath = IndexPath(row: viewController.players.count, section: 0)
      
      CreatePlayerAndAddToTableView()
      
      let numberOfRows = viewController.tableView.numberOfRows(inSection: 0)
      
      let playerNum = viewController.players.count
      
      XCTAssertEqual(viewController.removePlayer(indexPath, viewController.tableView),"Oac5aaqc6tULzR9KAB1WYUOLPfQW-4")
      
      XCTAssertNotEqual(numberOfRows, viewController.tableView.numberOfRows(inSection: 0))
      XCTAssertNotEqual(playerNum, viewController.players.count)
      
      XCTAssertTrue(viewController.playerFirstNameText.text!.isEmpty)
      XCTAssertTrue(viewController.playerLastNameText.text!.isEmpty)
      XCTAssertTrue(viewController.playerHeightText.text!.isEmpty)
      XCTAssertTrue(viewController.playerWeightText.text!.isEmpty)
      XCTAssertTrue(viewController.playerClassText.text!.isEmpty)
      XCTAssertTrue(viewController.playerPositionText.text!.isEmpty)
      XCTAssertEqual(viewController.playerImage.image, UIImage(named: "Default"))
      
   }
   
   func testImagePickerDidCancel(){
      
      viewController.addPlayer(UIButton.init())
      
      viewController.imagePickerController.sourceType = .photoLibrary
      viewController.present(viewController.imagePickerController, animated: false, completion: nil)
      viewController.imagePickerController.viewDidLoad()
      viewController.imagePickerControllerDidCancel(viewController.imagePickerController)
      
      XCTAssertFalse(viewController.addButton.isEnabled)
      XCTAssertTrue(viewController.addButton.isHidden)
      XCTAssertTrue(viewController.tableView.allowsSelection)
      XCTAssertTrue(viewController.playerPositionText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerFirstNameText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerLastNameText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerHeightText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerWeightText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerClassText.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerImage.isUserInteractionEnabled)
      XCTAssertTrue(viewController.playerPositionText.isUserInteractionEnabled)
      XCTAssertFalse(viewController.editButton.isEnabled)
      XCTAssertTrue(viewController.editButton.isHidden)
      XCTAssertTrue(viewController.saveButton.isEnabled)
      XCTAssertFalse(viewController.saveButton.isHidden)
      XCTAssertTrue(viewController.cancelButton.isEnabled)
      XCTAssertFalse(viewController.cancelButton.isHidden)
      
   }
   
   func testCropToBounds(){
      
      XCTAssertEqual(viewController.cropToBounds(image: UIImage(named: "Default")!, width: 10, height: 10).cgImage!.width, 10)
      XCTAssertEqual(viewController.cropToBounds(image: UIImage(named: "Default")!, width: 10, height: 10).cgImage!.height, 10)
   }
   
   func testEditPlayerInfo(){
      
      viewController.editPlayerInfo(UIButton.init())
      testSetEditPlayerFieldsTrue()
      testSetSaveButtonToTrue()
      testSetCancelButtonToTrue()
      testSetAddButtonToFalse()
      testSetEditButtonToFalse()
      XCTAssertFalse(viewController.tableView.allowsSelection)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
         XCTAssertTrue(self.viewController.playerFirstNameText.isFirstResponder)
      })
   }
   
   func testAddPlayer(){
      viewController.addPlayer(UIButton.init())
      testSetEditPlayerFieldsTrue()
      testSetAddButtonToFalse()
      testSetEditButtonToFalse()
      testSetSaveButtonToTrue()
      testSetCancelButtonToTrue()
      testSetBackButtonToFalse()
      testDefaultAllFields()
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
         XCTAssertTrue(self.viewController.playerFirstNameText.isFirstResponder)
      })
   }
   
   func testCancelPlayerManageWithNoCurrentPath(){
      testResetButtonState()
      testGrabPlayerFields()
   }
   
   func testCancelPlayerManageWithCurrentPath(){
      let indexPath = IndexPath(row: viewController.players.count, section: 0)
      
      CreatePlayerAndAddToTableView()
      viewController.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      viewController.editPlayerInfo(UIButton.init())
      
      viewController.cancelManage(UIButton.init())
      testDefaultAllFields()
   }
   
   func testSavePlayer(){
      let indexPath = IndexPath(row: viewController.players.count, section: 0)
      
      CreatePlayerAndAddToTableView()
      let player = CreatePlayer()
      populateFields()
      
      viewController.currentPath = indexPath
      viewController.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      
      viewController.savePlayer(UIButton.init())
      
      XCTAssertEqual(viewController.playerFirstNameText.text, player.firstName)
      XCTAssertEqual(viewController.playerLastNameText.text, player.lastName)
      XCTAssertEqual(viewController.playerHeightText.text, player.height)
      XCTAssertEqual(viewController.playerWeightText.text, player.weight)
      XCTAssertEqual(viewController.playerClassText.text, player.rank)
      XCTAssertEqual(viewController.playerPositionText.text, player.position)
      testResetButtonState()
   }
   
   func testTextPopulatesForPositionPicker(){
      viewController.textFieldDidBeginEditing(viewController.playerPositionText)
      let text = viewController.playerPositionText.text
      XCTAssertEqual(viewController.playerPositionText.text, viewController.positionNames[viewController.positionNames.firstIndex(of: text!)!])
   }
   
   func testTextPopulatesForHeightPicker(){
      viewController.textFieldDidBeginEditing(viewController.playerHeightText)
      let text = viewController.playerHeightText.text
      XCTAssertEqual(viewController.playerHeightText.text, viewController.heights[viewController.heights.firstIndex(of: text!)!])
   }
   
   func testTextPopulatesForClassPicker(){
      viewController.textFieldDidBeginEditing(viewController.playerClassText)
      let text = viewController.playerClassText.text
      XCTAssertEqual(viewController.playerClassText.text, viewController.ranks[viewController.ranks.firstIndex(of: text!)!])
   }
   
}
