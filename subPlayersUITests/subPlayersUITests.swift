//
//  subPlayersUITests.swift
//  subPlayersUITests
//
//  Created by Maggie Zhang on 10/18/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest

class subPlayersUITests: XCTestCase {

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

    func testSubPlayerOne() {
        let app = XCUIApplication()
        app.otherElements.containing(.button, identifier:"Logout").children(matching: .button).element(boundBy: 2).tap()
        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element(boundBy: 1).tap()
        app.sheets["Offensive Options"].buttons["Sub"].tap()
        app.sheets["Bench"].buttons["M W"].tap()
        
    }
    
    func testSubPlayerTwo() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.button, identifier:"Logout").children(matching: .button).element(boundBy: 2).tap()
         XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element(boundBy: 4).tap()
        app.sheets["Offensive Options"].buttons["Sub"].tap()
        app.sheets["Bench"].buttons["D Z"].tap()
        
    }
    
    func testSubPlayerThree() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 2).tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).matching(identifier: "Default").element(boundBy: 4).tap()
        app.sheets["Offensive Options"].buttons["Sub"].tap()
        app.sheets["Bench"].buttons["P J"].tap()
    }
    
    func testSubPlayerFour() {
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 2).tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).matching(identifier: "Default").element(boundBy: 3).tap()
        app.sheets["Offensive Options"].buttons["Sub"].tap()
        app.sheets["Bench"].buttons["J K"].tap()
        
    }
    
    func testSubPlayerFive() {
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 2).tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).matching(identifier: "Default").element(boundBy: 1).tap()
        app.sheets["Offensive Options"].buttons["Sub"].tap()
        app.sheets["Bench"].buttons["Y Z"].tap()
        
    }

}
