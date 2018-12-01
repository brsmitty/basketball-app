//
//  newScheduleUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Mike White on 12/1/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class newScheduleUnitTests: XCTestCase {

   var viewController: ViewController!
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "ScheduleNewViewController") as! ViewController)
      let _ = viewController.view
   }
   
   override func tearDown() {
      super.tearDown()
      viewController = nil
   }
   
   func testElementsExistWithFormatting(){
      
      // Text Field
      XCTAssertNotNil(viewController.GameOptionalDetail)
      XCTAssertNotNil(viewController.GameOpponent)
      XCTAssertNotNil(viewController.GameTime)
      XCTAssertNotNil(viewController.GameDate)
      XCTAssertNotNil(viewController.GameType)
      XCTAssertNotNil(viewController.Location)
      
      XCTAssert(viewController.GameOptionalDetail.layer.cornerRadius == 5)
      XCTAssert(viewController.GameOpponent.layer.cornerRadius == 5)
      XCTAssert(viewController.GameTime.layer.cornerRadius == 5)
      XCTAssert(viewController.GameDate.layer.cornerRadius == 5)
      XCTAssert(viewController.GameType.layer.cornerRadius == 5)
      XCTAssert(viewController.Location.layer.cornerRadius == 5)
      
      // Label
      XCTAssertNotNil(viewController.opponentLabel)
      XCTAssertNotNil(viewController.locationLabel)
      XCTAssertNotNil(viewController.typeLabel)
      XCTAssertNotNil(viewController.dateLabel)
      XCTAssertNotNil(viewController.timeLabel)
      XCTAssertNotNil(viewController.detailLabel)
      
      // Buttons
      XCTAssertNotNil(viewController.addButton)
      XCTAssert(viewController.addButton.layer.cornerRadius == 5)
   }
   
   func testPickerNumberOfComponents(){
      
      XCTAssertEqual(viewController.numberOfComponents(in: viewController.locationPicker), 1)
      XCTAssertEqual(viewController.numberOfComponents(in: viewController.typePicker), 1)
   }
   
   func testNumberOfRowsInPicker(){
      
      XCTAssertEqual(viewController.pickerView(viewController.locationPicker, numberOfRowsInComponent: 1), viewController.locationPick.count)
      XCTAssertEqual(viewController.pickerView(viewController.typePicker, numberOfRowsInComponent: 1), viewController.typePick.count)
   }
   
   func testPickerPopulatesTextCorrectly(){
      
      viewController.pickerView(viewController.locationPicker, didSelectRow: 0, inComponent: 1)
      XCTAssertEqual(viewController.Location.text, "Home")
      
      viewController.pickerView(viewController.locationPicker, didSelectRow: 1, inComponent: 1)
      XCTAssertEqual(viewController.Location.text, "Away")
      
      viewController.pickerView(viewController.typePicker, didSelectRow: 0, inComponent: 1)
      XCTAssertEqual(viewController.GameType.text, "Non-Conference")
      
      viewController.pickerView(viewController.typePicker, didSelectRow: 1, inComponent: 1)
      XCTAssertEqual(viewController.GameType.text, "Conference")
      
      viewController.pickerView(viewController.typePicker, didSelectRow: 2, inComponent: 1)
      XCTAssertEqual(viewController.GameType.text, "Playoff")
      
      viewController.pickerView(viewController.typePicker, didSelectRow: 3, inComponent: 1)
      XCTAssertEqual(viewController.GameType.text, "Tournament")
      
   }
   
   func testPickerTitleForRow(){
      
      XCTAssertEqual(viewController.pickerView(viewController.locationPicker, titleForRow: 0, forComponent: 1), "Home")
      XCTAssertEqual(viewController.pickerView(viewController.locationPicker, titleForRow: 1, forComponent: 1), "Away")
      
      XCTAssertEqual(viewController.pickerView(viewController.typePicker, titleForRow: 0, forComponent: 1), "Non-Conference")
      XCTAssertEqual(viewController.pickerView(viewController.typePicker, titleForRow: 1, forComponent: 1), "Conference")
      XCTAssertEqual(viewController.pickerView(viewController.typePicker, titleForRow: 2, forComponent: 1), "Playoff")
      XCTAssertEqual(viewController.pickerView(viewController.typePicker, titleForRow: 3, forComponent: 1), "Tournament")
   }
   
   func testDateChangedPicker(){
      
      let dataFormatter = DateFormatter()
      dataFormatter.dateFormat = "MM/dd/yyyy"
      
      viewController.datePicker.setDate(Date.distantFuture, animated: false)
      viewController.dateChanged(datePicker: viewController.datePicker)
      XCTAssertEqual(viewController.GameDate.text, dataFormatter.string(from:Date.distantFuture))
   }
   
   func testTimeChangedPicker(){
      
      let dataFormatter = DateFormatter()
      dataFormatter.dateFormat = "HH:mm"
      
      viewController.timePicker.setDate(Date.distantPast, animated: false)
      viewController.timeChanged(timePicker: viewController.timePicker)
      XCTAssertEqual(viewController.GameTime.text, dataFormatter.string(from:Date.distantPast))
      
   }
   
   func testViewHasGesture(){
      
      // Assert the number of gestures the view has is 1
      XCTAssert((viewController.view.gestureRecognizers?.capacity)! == 1)
   }

}
