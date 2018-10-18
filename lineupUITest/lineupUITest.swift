//
//  lineupUITest.swift
//  lineupUITest
//
//  Created by Mike White on 10/16/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest

class lineupUITest: XCTestCase {

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
   
   func testCreateLineup(){
      
      let app = XCUIApplication()
      app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 4).tap()
      app.buttons["ADD LINEUP"].tap()
      app.textFields["Starting Lineup"].typeText("New Starters")
      
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element
      element.children(matching: .other).element(boundBy: 1).images["Default"].tap()
      
      let tablesQuery = app.tables
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Michael White"]/*[[".cells.staticTexts[\"Michael White\"]",".staticTexts[\"Michael White\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      element.children(matching: .other).element(boundBy: 2).images["Default"].tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["David Zucco"]/*[[".cells.staticTexts[\"David Zucco\"]",".staticTexts[\"David Zucco\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      element.children(matching: .other).element(boundBy: 3).images["Default"].tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Lebron James"]/*[[".cells.staticTexts[\"Lebron James\"]",".staticTexts[\"Lebron James\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      element.children(matching: .other).element(boundBy: 5).images["Default"].tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Chris Be"]/*[[".cells.staticTexts[\"Chris Be\"]",".staticTexts[\"Chris Be\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      element.children(matching: .other).element(boundBy: 4).images["Default"].tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Final Player"]/*[[".cells.staticTexts[\"Final Player\"]",".staticTexts[\"Final Player\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.textFields["Position 1"].tap()
      
      let pickerWheel = app.pickers.children(matching: .pickerWheel).element
      pickerWheel.tap()
      app.pickers.children(matching: .pickerWheel).element.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      app.textFields["Position 2"].tap()
      app.pickers.children(matching: .pickerWheel).element.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      app.textFields["Position 3"].tap()
      app.pickers.children(matching: .pickerWheel).element.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      app.textFields["Position 4"].tap()
      app.pickers.children(matching: .pickerWheel).element.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      app.textFields["Position 5"].tap()
      app.pickers.children(matching: .pickerWheel).element.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      app.buttons["SAVE"].tap()
      
      
   }

   func testSaveEditedLineup(){
      
      let app = XCUIApplication()
      XCUIApplication().otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 4).tap()
      let tablesQuery = app.tables
      tablesQuery.staticTexts["New Starters"].tap()
      
      app.textFields["Starting Lineup"].typeText("2")
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      
      app.buttons["SAVE"].tap()
      
   }
   
   func testSaveUneditedLineup(){
      
      let app = XCUIApplication()
      XCUIApplication().otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 4).tap()
      let tablesQuery = app.tables
      tablesQuery.staticTexts["New Starters2"].tap()
      
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      
      app.buttons["SAVE"].tap()
      
      
   }
   
   func testCancelEditedLineup(){
      
      let app = XCUIApplication()
      XCUIApplication().otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 4).tap()
      let tablesQuery = app.tables
      tablesQuery.staticTexts["New Starters2"].tap()
      
      app.textFields["Starting Lineup"].typeText("2")
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      
      app.buttons["CANCEL"].tap()
   }
   
   func testCancelUneditedLineup(){
      
      let app = XCUIApplication()
      XCUIApplication().otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 4).tap()
      let tablesQuery = app.tables
      tablesQuery.staticTexts["New Starters2"].tap()
      
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      
      app.buttons["CANCEL"].tap()
      
      
   }
   
   
   func testClearLineupFields(){
 
      let app = XCUIApplication()
      XCUIApplication().otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 4).tap()
      
      let tablesQuery = app.tables
      tablesQuery.staticTexts["New Starters2"].tap()
      
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      app.buttons["Clear1"].tap()
      
      app.buttons["Clear2"].tap()
      
      app.buttons["Clear3"].tap()
      
      app.buttons["Clear4"].tap()
      
      app.buttons["Clear5"].tap()
      
      app.buttons["CANCEL"].tap()
      
   }
   
   func testClearLineupFieldThenReAdd(){
      
      let app = XCUIApplication()
      XCUIApplication().otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 4).tap()
      
      let tablesQuery = app.tables
      tablesQuery.staticTexts["New Starters2"].tap()
      
      app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      app.buttons["Clear1"].tap()
      
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element
      element.children(matching: .other).element(boundBy: 1).images["Default"].tap()
      
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Michael White"]/*[[".cells.staticTexts[\"Michael White\"]",".staticTexts[\"Michael White\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      app.textFields["Position 1"].tap()
      let pickerWheel = app.pickers.children(matching: .pickerWheel).element
      pickerWheel.tap()
      app.pickers.children(matching: .pickerWheel).element.swipeLeft()
      app.toolbars["Toolbar"].buttons["Done"].tap()
      
      app.buttons["SAVE"].tap()
      
      
   }
   
   func testDeleteLineup(){
      
      let app = XCUIApplication()
      XCUIApplication().otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 4).tap()
      
      let tablesQuery = app.tables
      tablesQuery.staticTexts["New Starters2"].swipeLeft()
      
      let deleteButton = tablesQuery.buttons["Delete"]
      deleteButton.tap()
      
   }
   

}
