//
//  gestureUITests.swift
//  gestureUITests
//
//  Created by Maggie Zhang on 10/17/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest

class gestureUITests: XCTestCase {

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

    func testShootMade() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 2).tap()
        app.images["VerifiedBall"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        app.sheets["Shot Outcome"].buttons["Made"].tap()
        
    }
    
    func testShootMissing() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 2).tap()
        app.images["VerifiedBall"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        app.sheets["Shot Outcome"].buttons["Missed"].tap()
        
    }
    
    func testShootingPlayerOne() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 2).tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        app.sheets["Shot Result?"].buttons["Made"].tap()
       
    }
    
    func testShootingPlayerTwo() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 2).tap()
        let window = app.children(matching: .window).element(boundBy: 0)
        window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element(boundBy: 4)/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        window.children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        app.sheets["Shot Result?"].buttons["Made"].tap()
        
    }
    
    func testShootingPlayerThree() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 2).tap()
        let window = app.children(matching: .window).element(boundBy: 0)
        window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element(boundBy: 6).swipeLeft()
        window.children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        app.sheets["Shot Result?"].buttons["Made"].tap()
        
    }
    
    func testShootingPlayerFour() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"welcomeBar").children(matching: .button).element(boundBy: 2).tap()
        let window = app.children(matching: .window).element(boundBy: 0)
        window.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .image).matching(identifier: "Default").element(boundBy: 3)/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeDown()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        window.children(matching: .other).element(boundBy: 3).children(matching: .other).element.tap()
        app.sheets["Shot Result?"].buttons["Made"].tap()
        
    }
    
    func testShootingPlayerFive() {
        
        
        let app = XCUIApplication()
        let window = app.children(matching: .window).element(boundBy: 0)
        window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).matching(identifier: "Default").element(boundBy: 1).swipeDown()
        window.children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        app.sheets["Shot Result?"].buttons["Made"].tap()
        
    }
    
    
    

}
