//
//  lineupUI_Test.swift
//  lineupUI_Test
//
//  Created by Maggie Zhang on 10/16/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest

class playerManagerUI_Test: XCTestCase {
   
   override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
      
      // In UI tests it is usually best to stop immediately when a failure occurs.
      continueAfterFailure = false
      
      // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
      XCUIApplication().launch()
      
      // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
   }
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
   }
   
   
   func testAddFivePlayers() {
      
      
      let app = XCUIApplication()
      app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 3).tap()
      
      let addButton = app.buttons["ADD PLAYER"]
      addButton.tap()
      
      let firstTextField = app.textFields["First"]
      firstTextField.typeText("Michael")
      
      let lastTextField = app.textFields["Last"]
      lastTextField.tap()
      lastTextField.typeText("White")
      
      let positionTextField = app.textFields["Position"]
      positionTextField.tap()
      
      app.pickerWheels["Point-Guard"].swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      let heightTextField = app.textFields["Height"]
      heightTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["5'0\""]/*[[".pickers.pickerWheels[\"5'0\\\"\"]",".pickerWheels[\"5'0\\\"\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      
      let weightTextField = app.textFields["Weight"]
      weightTextField.tap()
      weightTextField.typeText("145")
      
      let rankTextField = app.textFields["Rank"]
      rankTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["Freshmen"]/*[[".pickers.pickerWheels[\"Freshmen\"]",".pickerWheels[\"Freshmen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      let saveButton = app.buttons["SAVE"]
      saveButton.tap()
      addButton.tap()
      
      firstTextField.typeText("David")
      
      lastTextField.tap()
      lastTextField.typeText("Zucco")
      
      positionTextField.tap()
      
      app.pickerWheels["Point-Guard"].swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      heightTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["5'0\""]/*[[".pickers.pickerWheels[\"5'0\\\"\"]",".pickerWheels[\"5'0\\\"\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      
      weightTextField.tap()
      weightTextField.typeText("155")
      
      rankTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["Freshmen"]/*[[".pickers.pickerWheels[\"Freshmen\"]",".pickerWheels[\"Freshmen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      saveButton.tap()
      addButton.tap()
      
      firstTextField.typeText("Lebron")
      
      lastTextField.tap()
      lastTextField.typeText("James")
      
      positionTextField.tap()
      
      app.pickerWheels["Point-Guard"].swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      heightTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["5'0\""]/*[[".pickers.pickerWheels[\"5'0\\\"\"]",".pickerWheels[\"5'0\\\"\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      
      weightTextField.tap()
      weightTextField.typeText("245")
      
      rankTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["Freshmen"]/*[[".pickers.pickerWheels[\"Freshmen\"]",".pickerWheels[\"Freshmen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      saveButton.tap()
      addButton.tap()
      
      firstTextField.typeText("Chris")
      
      lastTextField.tap()
      lastTextField.typeText("Be")
      
      positionTextField.tap()
      
      app.pickerWheels["Point-Guard"].swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      heightTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["5'0\""]/*[[".pickers.pickerWheels[\"5'0\\\"\"]",".pickerWheels[\"5'0\\\"\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      
      weightTextField.tap()
      weightTextField.typeText("245")
      
      rankTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["Freshmen"]/*[[".pickers.pickerWheels[\"Freshmen\"]",".pickerWheels[\"Freshmen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      saveButton.tap()
      addButton.tap()
      
      firstTextField.typeText("Final")
      
      lastTextField.tap()
      lastTextField.typeText("Player")
      
      positionTextField.tap()
      
      app.pickerWheels["Point-Guard"].swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      heightTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["5'0\""]/*[[".pickers.pickerWheels[\"5'0\\\"\"]",".pickerWheels[\"5'0\\\"\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      
      weightTextField.tap()
      weightTextField.typeText("245")
      
      rankTextField.tap()
      app/*@START_MENU_TOKEN@*/.pickerWheels["Freshmen"]/*[[".pickers.pickerWheels[\"Freshmen\"]",".pickerWheels[\"Freshmen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      saveButton.tap()
      
   }
   
   func testSaveEditPlayer(){
      
      
      
      let app = XCUIApplication()
      app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 3).tap()
      app.tables/*@START_MENU_TOKEN@*/.staticTexts["Michael White"]/*[[".cells.staticTexts[\"Michael White\"]",".staticTexts[\"Michael White\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.buttons["EDIT"].tap()
      let firstTextField = app.textFields["First"]
      firstTextField.typeText("Michael")
      app.buttons["SAVE"].tap()
      
   }
   
   func testCancelEditPlayer(){
      let app = XCUIApplication()
      app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 3).tap()
      app.tables/*@START_MENU_TOKEN@*/.staticTexts["Michael White"]/*[[".cells.staticTexts[\"Michael White\"]",".staticTexts[\"Michael White\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.buttons["EDIT"].tap()
      let firstTextField = app.textFields["First"]
      firstTextField.typeText("Michael")
      app.buttons["CANCEL"].tap()
      
   }
   
   func testDeletePlayers(){
      
      
      let app = XCUIApplication()
      app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 3).tap()
      
      let tablesQuery2 = app.tables
      let tablesQuery = tablesQuery2
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Michael White"]/*[[".cells.staticTexts[\"Michael White\"]",".staticTexts[\"Michael White\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      
      let deleteButton = tablesQuery2.buttons["Delete"]
      deleteButton.tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["David Zucco"]/*[[".cells.staticTexts[\"David Zucco\"]",".staticTexts[\"David Zucco\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      deleteButton.tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Lebron James"]/*[[".cells.staticTexts[\"Lebron James\"]",".staticTexts[\"Lebron James\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      deleteButton.tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Chris Be"]/*[[".cells.staticTexts[\"Chris Be\"]",".staticTexts[\"Chris Be\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
      deleteButton.tap()
      tablesQuery.staticTexts["Final Player"].swipeLeft()
      deleteButton.tap()
      
   }
   
   
}
