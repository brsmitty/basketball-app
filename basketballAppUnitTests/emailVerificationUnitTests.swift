//
//  emailVerificationUnitTests.swift
//  basketballAppUnitTests
//
//  Created by Mike White on 11/30/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp


class emailVerificationUnitTests: XCTestCase {

   var viewController: EmailVerificationViewController!
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController = (storyboard.instantiateViewController(withIdentifier: "EmailVerifPage") as! EmailVerificationViewController)
      let _ = viewController.view
   }
   
   override func tearDown() {
      super.tearDown()
      viewController = nil
   }

   func testElementsExistWithFormatting(){
      
      // Buttons
      XCTAssert(viewController.resendCodeButton.isEnabled)
      
      // Label
      XCTAssert(viewController.descriptOne.isEnabled)
      XCTAssert(viewController.descriptTwo.isEnabled)
      XCTAssert(viewController.descriptThree.isEnabled)
   }
   
//   func testCreateTeamData(){
//      
//      viewController.AuthU.createUser(withEmail: "123764271778@gmail.com", password: "testPassword") { user, error in
//         if error == nil {
//            self.viewController.AuthU.signIn(withEmail: "123764271778@gmail.com", password: "testPassword") { user, error in
//               if let error = error, user == nil {
//                  XCTFail(error.localizedDescription)
//               }
//            }
//         }
//      }
//      
//      let uidFirst = UserDefaults.standard.string(forKey: "uid")
//      let tidFirst = UserDefaults.standard.string(forKey: "tid")
//
//      guard let uid = viewController.AuthU.currentUser?.uid else { return }
//      let firebaseRef = viewController.DatabaseU.reference(withPath: "users")
//      let userRef = firebaseRef.child(uid)
//      let tid = String(format: "%f", NSDate().timeIntervalSince1970).replacingOccurrences(of: ".", with: "")
//      let userData : [String: Any] = ["uid":  uid, "tid": tid]
//      userRef.setValue(userData)
//      viewController.createTeam(tid: tid)
//      viewController.storePersistentData(uid: uid, tid: tid)
//      
//      XCTAssertNotEqual(uidFirst, UserDefaults.standard.string(forKey: "uid"))
//      XCTAssertNotEqual(tidFirst, UserDefaults.standard.string(forKey: "tid"))
//   }

}
