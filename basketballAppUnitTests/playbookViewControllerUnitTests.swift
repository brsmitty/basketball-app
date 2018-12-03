//
//  playbookViewControllerUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Mike White on 12/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class playbookViewControllerUnitTests: XCTestCase {

   var viewController: PlaybookViewController!
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "playbookViewController") as! PlaybookViewController)
      let _ = viewController.view
   }
   
   override func tearDown() {
      super.tearDown()
      viewController = nil
   }

   func testElementsExistWithFormatting(){
      XCTAssertNotNil(viewController.PlaybookTableView)
   }
   
   
   func testNumberOfRowsInSection(){
      XCTAssertEqual(viewController.tableView(viewController.PlaybookTableView, numberOfRowsInSection: 0), 0)
   }
   
   func testCellForRowTableView(){
      
      let indexPath = IndexPath(row: viewController.playbooks.count, section: 0)
      let playbook = Playbook(title: "Test")
      viewController.playbooks.append(playbook)
      
      XCTAssertEqual((viewController.tableView(viewController.PlaybookTableView, cellForRowAt: indexPath) as! PlaybookCell).title.text, playbook.title)
   }
   
   func testDeleteRow(){
      
      let indexPath = IndexPath(row: viewController.playbooks.count, section: 0)
      let playbook = Playbook(title: "Test")
      viewController.playbooks.append(playbook)
      viewController.storedPlaybooks.append(playbook.title)
      viewController.fileNames.append(playbook.title)
      
      viewController.tableView(viewController.PlaybookTableView, commit: .delete, forRowAt: indexPath)
      XCTAssertFalse(viewController.playbooks.contains(playbook))
      XCTAssertEqual(viewController.tableView(viewController.PlaybookTableView, numberOfRowsInSection: 0), 0)
      XCTAssertFalse(viewController.storedPlaybooks.contains(playbook.title))
      
   }
   
   func testUnwind(){
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let VC = storyboard.instantiateViewController(withIdentifier: "playbookDetailView") as! PlaybookDetailViewController
      
      VC.fileName = "Test"
      VC.playbook = "TestPlaybook"
      
      
      let segue = UIStoryboardSegue(identifier: "playbookViewController", source: VC, destination: viewController)
      
      viewController.unwindToPlaybookList(sender: segue)
      
      XCTAssertEqual(viewController.storedPlaybooks[0], VC.playbook)
      XCTAssertEqual(viewController.fileNames[0], VC.fileName)
      XCTAssertEqual(viewController.PlaybookTableView.numberOfRows(inSection: 0), 1)
   }

}
