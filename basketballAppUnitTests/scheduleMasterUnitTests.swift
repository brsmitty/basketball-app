//
//  scheduleMasterUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Mike White on 12/1/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
import EventKit
@testable import basketballApp

class scheduleMasterUnitTests: XCTestCase {

   var viewController: MasterViewController!
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "ScheduleMasterViewController") as! MasterViewController)
      let _ = viewController.view
   }
   
   override func tearDown() {
      super.tearDown()
      viewController = nil
   }
   
   func CreateGameAndAddToTableView(){
      let game = Game(title: "temp", detail: "hl")
      
      viewController.insertGameInTableView(game)
      
      viewController.gameTitles.append("temp")
      viewController.gameLocations.append("Home")
      viewController.gameTypes.append("Conference")
      viewController.gameTimes.append("4:00")
      viewController.gameDetails.append("hl")
      viewController.synced.append(false)
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MM, dd, yyyy"
      let date = dateFormatter.date(from: "11/30/1994")
      
      viewController.gameDates.append(date!)
   }
   
   func testElementsExistWithFormatting(){
      
      // Nav
      XCTAssertNotNil(viewController.barNav)
      
      // Buttons
      XCTAssertNotNil(viewController.addButton)
      XCTAssertNotNil(viewController.syncButton)
      
      // TableView
      XCTAssertNotNil(viewController.GameTableView)
   }
   
   func testAppendEvents(){
      
      let inputTitle = "Hello"
      let inputDetail = "There"
      let tempGame = Game(title: inputTitle, detail: inputDetail)
      
      viewController.appendEvents(inputTitle: inputTitle, inputDetail: inputDetail)
      
      XCTAssertEqual(viewController.games.count, 1)
      XCTAssertEqual(viewController.games[0].title, tempGame.title)
      XCTAssertEqual(viewController.games[0].detail, tempGame.detail)
   }
   
   func testGameIsUsersForGameThatIsUsers(){
      
      let uid = "4K37fInsgVYFyUIlJiY4vUcSszn2"
      let gid = "4K37fInsgVYFyUIlJiY4vUcSszn2-3"
      
      viewController.uid = uid
      XCTAssertTrue(viewController.gameIsUsers(gid))
      
   }
   
   func testGameIsUsersForGameThatIsNotUsers(){
      
      let uid = "4K37fInsgVYFyUIlJiY4vUcSszn2"
      let gid = "4K37fInsgVYFyUIlJiY4vUcSs123-3"
      
      viewController.uid = uid
      XCTAssertFalse(viewController.gameIsUsers(gid))
      
   }

   func testInsertGameToTable(){
      
      let rows = viewController.tableView.numberOfRows(inSection: 0)
      
      CreateGameAndAddToTableView()
      
      XCTAssertNotEqual(rows, viewController.tableView.numberOfRows(inSection: 0))
   }
   
   func testNumberOfRowsInTableViewForMoreThanZeroGames(){
      
      let game = Game(title: "1", detail: "2")
      let game2 = Game(title: "2", detail: "2")
      let game3 = Game(title: "3", detail: "2")
      viewController.games.append(game)
      viewController.games.append(game2)
      viewController.games.append(game3)
      
      XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), viewController.games.count)
   }
   
   func testNumberOfRowsInTableViewForZeroGames(){
      
      XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), viewController.games.count)
   }
   
   func testCellForRow(){
      
      let indexPath = IndexPath(row: viewController.games.count, section: 0)
      CreateGameAndAddToTableView()
      
      XCTAssertEqual((viewController.tableView(viewController.tableView, cellForRowAt: indexPath)as! GameCell).GameTitle.text, "temp")
      XCTAssertEqual((viewController.tableView(viewController.tableView, cellForRowAt: indexPath)as! GameCell).GameDetail.text, "hl")
      
   }
   
   func testDeleteRow(){
      
      let indexPath = IndexPath(row: viewController.games.count, section: 0)
      
      CreateGameAndAddToTableView()
      
      let games = viewController.games
      let gameDates = viewController.gameDates
      let gameTypes = viewController.gameTypes
      let locations = viewController.gameLocations
      let gameTitles = viewController.gameTitles
      let gameTimes = viewController.gameTimes
      let gameDetails = viewController.gameDetails
      
      let numberOfRows = viewController.tableView.numberOfRows(inSection: 0)
      
      viewController.tableView(viewController.tableView, commit: .delete, forRowAt: indexPath)
      
      XCTAssertNotEqual(games.count, viewController.games.count)
      XCTAssertNotEqual(gameDates.count, viewController.gameDates.count)
      XCTAssertNotEqual(gameTypes.count, viewController.gameTypes.count)
      XCTAssertNotEqual(locations.count, viewController.gameLocations.count)
      XCTAssertNotEqual(gameTitles.count, viewController.gameTitles.count)
      XCTAssertNotEqual(gameTimes.count, viewController.gameTimes.count)
      XCTAssertNotEqual(gameDetails.count, viewController.gameDetails.count)
      XCTAssertNotEqual(numberOfRows, viewController.tableView.numberOfRows(inSection: 0))
   }
   
   func testUnwind(){
      
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let VC = storyboard.instantiateViewController(withIdentifier: "ScheduleNewViewController") as! ViewController
      
      let date = Date.distantFuture
      let game = Game(title: "hello", detail: "there")
      let gameTitle = "hello"
      let location = "Home"
      let gameType = "Conference"
      let gameTime = "4:00"
      let gameDetail = "there"
      
      VC.gameDate = date
      VC.game = game
      VC.gameTitle = gameTitle
      VC.location = location
      VC.gameType = gameType
      VC.gameTime = gameTime
      VC.gameDetail = gameDetail
      
      
      let segue = UIStoryboardSegue(identifier: "viewController", source: VC, destination: viewController)
      
      viewController.unwindToGameList(sender: segue)
      
      XCTAssertEqual(viewController.gameDates[0], date)
      XCTAssertEqual(viewController.gameTitles[0], gameTitle)
      XCTAssertEqual(viewController.gameLocations[0], location)
      XCTAssertEqual(viewController.gameTypes[0], gameType)
      XCTAssertEqual(viewController.gameDetails[0], gameDetail)
      XCTAssertEqual(viewController.gameTimes[0], gameTime)
      XCTAssertFalse(viewController.synced[0])
   }
   
   func testSyncToCalendar(){
      
      var found = false
      
      CreateGameAndAddToTableView()
      
      viewController.AddEvent(UIButton.init())
      
      
      let calendar = Calendar.current
      let title = "temp"
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MM, dd, yyyy"
      let dateThen = dateFormatter.date(from: "11/30/1994")
      viewController.gameLocations.append("Home")
      viewController.gameTypes.append("Conference")
      viewController.gameTimes.append("4:00")
      viewController.gameDetails.append("hl")
      
      
      // Create the start date components
      var oneDayAgoComponents = DateComponents()
      oneDayAgoComponents.day = -1
      let oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: dateThen!, wrappingComponents: false)
      
      // Create the end date components.
      var oneYearFromNowComponents = DateComponents()
      oneYearFromNowComponents.year = 1
      let oneYearFromNow = calendar.date(byAdding: oneYearFromNowComponents, to: dateThen!, wrappingComponents: false)

      
      let eventStore = viewController.eventStore
      
      let event = EKEvent(eventStore: eventStore)
      event.title = title
      event.startDate = dateThen
      event.endDate = dateThen
      event.calendar = eventStore.defaultCalendarForNewEvents
      var predicate: NSPredicate? = nil
      if let anAgo = oneDayAgo, let aNow = oneYearFromNow {
         predicate = eventStore.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
         let existingEvents = eventStore.events(matching: predicate!)
         for singleEvent in existingEvents{
            if singleEvent.title == title && singleEvent.startDate == dateThen! && singleEvent.endDate == dateThen!{
               found = true
            }
         }
      }
      XCTAssert(found)
   }
   
}
