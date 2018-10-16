//
//  lineupUI_Test.swift
//  lineupUI_Test
//
//  Created by Maggie Zhang on 10/16/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest

class lineupUI_Test: XCTestCase {

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

    func testPlayerOne() {
        XCUIApplication().navigationBars["Team Player Manager"].buttons["Add"].tap()
        
        let app = XCUIApplication()
        app.textFields["First"].tap()
        
        let lastTextField = app.textFields["Last"]
        lastTextField.tap()
        lastTextField.tap()
        
        let heightTextField = app.textFields["Height"]
        heightTextField.tap()
        heightTextField.tap()
        
        let app2 = app
        app2/*@START_MENU_TOKEN@*/.pickerWheels["5'4\""].press(forDuration: 0.9);/*[[".pickers.pickerWheels[\"5'4\\\"\"]",".tap()",".press(forDuration: 0.9);",".pickerWheels[\"5'4\\\"\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        app.textFields["Weight"].tap()
        
        let rankTextField = app.textFields["Rank"]
        rankTextField.tap()
        rankTextField.tap()
        app2/*@START_MENU_TOKEN@*/.pickerWheels["Senior"].press(forDuration: 1.6);/*[[".pickers.pickerWheels[\"Senior\"]",".tap()",".press(forDuration: 1.6);",".pickerWheels[\"Senior\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        app.textFields["Position"].tap()
        app2/*@START_MENU_TOKEN@*/.pickerWheels["Point-Guard"].press(forDuration: 1.8);/*[[".pickers.pickerWheels[\"Point-Guard\"]",".tap()",".press(forDuration: 1.8);",".pickerWheels[\"Point-Guard\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        app.navigationBars["Team Player Manager"].buttons["Save"].tap()
        
    }
    
    func testPlayerTwo() {
        
        let app = XCUIApplication()
        app.textFields["First"].tap()
        
        let lastTextField = app.textFields["Last"]
        lastTextField.tap()
        lastTextField.tap()
        
        let heightTextField = app.textFields["Height"]
        heightTextField.tap()
        heightTextField.tap()
        
        let app2 = app
        app2/*@START_MENU_TOKEN@*/.pickerWheels["5'0\""]/*[[".pickers.pickerWheels[\"5'0\\\"\"]",".pickerWheels[\"5'0\\\"\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        app.textFields["Weight"].tap()
        
        let rankTextField = app.textFields["Rank"]
        rankTextField.tap()
        rankTextField.tap()
        app2/*@START_MENU_TOKEN@*/.pickerWheels["Freshmen"]/*[[".pickers.pickerWheels[\"Freshmen\"]",".pickerWheels[\"Freshmen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        app.textFields["Position"].tap()
        app2/*@START_MENU_TOKEN@*/.pickerWheels["Point-Guard"].press(forDuration: 1.1);/*[[".pickers.pickerWheels[\"Point-Guard\"]",".tap()",".press(forDuration: 1.1);",".pickerWheels[\"Point-Guard\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        app.navigationBars["Team Player Manager"].buttons["Save"].tap()
        
        
    }
    
    func testPlayerThree() {
        
        let app = XCUIApplication()
        let teamPlayerManagerNavigationBar = app.navigationBars["Team Player Manager"]
        teamPlayerManagerNavigationBar.buttons["Add"].tap()
        
        let lastTextField = app.textFields["Last"]
        lastTextField.tap()
        lastTextField.tap()
        
        let heightTextField = app.textFields["Height"]
        heightTextField.tap()
        heightTextField.tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["6'5\""].press(forDuration: 1.1);/*[[".pickers.pickerWheels[\"6'5\\\"\"]",".tap()",".press(forDuration: 1.1);",".pickerWheels[\"6'5\\\"\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        app.textFields["Weight"].tap()
        
        let rankTextField = app.textFields["Rank"]
        rankTextField.tap()
        rankTextField.tap()
        
        let seniorPickerWheel = app/*@START_MENU_TOKEN@*/.pickerWheels["Senior"]/*[[".pickers.pickerWheels[\"Senior\"]",".pickerWheels[\"Senior\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        seniorPickerWheel.tap()
        seniorPickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 1.5);/*[[".tap()",".press(forDuration: 1.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        app.textFields["Position"].tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["Shooting-Guard"].press(forDuration: 1.1);/*[[".pickers.pickerWheels[\"Shooting-Guard\"]",".tap()",".press(forDuration: 1.1);",".pickerWheels[\"Shooting-Guard\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        teamPlayerManagerNavigationBar.buttons["Save"].tap()
        
        
    }
    
    func testPlayerFour() {
        
        let app = XCUIApplication()
        let teamPlayerManagerNavigationBar = app.navigationBars["Team Player Manager"]
        teamPlayerManagerNavigationBar.buttons["Add"].tap()
        
        let lastTextField = app.textFields["Last"]
        lastTextField.tap()
        lastTextField.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.tap()
        element.tap()
        
        let heightTextField = app.textFields["Height"]
        heightTextField.tap()
        heightTextField.tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["6'6\""]/*[[".pickers.pickerWheels[\"6'6\\\"\"]",".pickerWheels[\"6'6\\\"\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        app.textFields["Weight"].tap()
        
        let rankTextField = app.textFields["Rank"]
        rankTextField.tap()
        rankTextField.tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["Senior"].press(forDuration: 1.5);/*[[".pickers.pickerWheels[\"Senior\"]",".tap()",".press(forDuration: 1.5);",".pickerWheels[\"Senior\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        app.textFields["Position"].tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["Small-Forward"].press(forDuration: 1.0);/*[[".pickers.pickerWheels[\"Small-Forward\"]",".tap()",".press(forDuration: 1.0);",".pickerWheels[\"Small-Forward\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        teamPlayerManagerNavigationBar.buttons["Save"].tap()
        
    }
    
    func testPlayerFive() {
        
        let app = XCUIApplication()
        let teamPlayerManagerNavigationBar = app.navigationBars["Team Player Manager"]
        teamPlayerManagerNavigationBar.buttons["Add"].tap()
        app.textFields["First"].tap()
        
        let app2 = app
        app2/*@START_MENU_TOKEN@*/.otherElements["“Kevin”"]/*[[".keyboards",".otherElements[\"Top bar\"]",".otherElements[\"Typing Predictions\"].otherElements[\"“Kevin”\"]",".otherElements[\"“Kevin”\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let lastTextField = app.textFields["Last"]
        lastTextField.tap()
        app2/*@START_MENU_TOKEN@*/.otherElements["“A”"]/*[[".keyboards",".otherElements[\"Top bar\"]",".otherElements[\"Typing Predictions\"].otherElements[\"“A”\"]",".otherElements[\"“A”\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let heightTextField = app.textFields["Height"]
        heightTextField.tap()
        heightTextField.tap()
        app2/*@START_MENU_TOKEN@*/.pickerWheels["6'7\""].press(forDuration: 1.0);/*[[".pickers.pickerWheels[\"6'7\\\"\"]",".tap()",".press(forDuration: 1.0);",".pickerWheels[\"6'7\\\"\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        
        let weightTextField = app.textFields["Weight"]
        weightTextField.tap()
        
        let rankTextField = app.textFields["Rank"]
        rankTextField.tap()
        app2/*@START_MENU_TOKEN@*/.pickerWheels["Senior"].press(forDuration: 1.4);/*[[".pickers.pickerWheels[\"Senior\"]",".tap()",".press(forDuration: 1.4);",".pickerWheels[\"Senior\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        app.toolbars["Toolbar"].buttons["Done"].tap()
        teamPlayerManagerNavigationBar.buttons["Save"].tap()
        
        
    }

}
