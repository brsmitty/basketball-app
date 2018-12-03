//
//  basketballAppIntegrationTests.swift
//  basketballAppIntegrationTests
//
//  Created by Mike White on 12/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import XCTest
@testable import basketballApp

class userAuthIntegrationTests: XCTestCase {

    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name: "Main", bundle: nil)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUidTidPassedFromLoginViewToMiddleView() {
        let src = storyboard.instantiateViewController(withIdentifier: "LoginPage") as! UserAuthViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "MiddleView") as! MiddleViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "loginSegue", source: src, destination: dest)
        
         src.uid = "4afks9df92k3eads0k"
         src.tid = "12392949234923234"
         src.prepare(for: seg, sender: src)
         
         XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
         XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromRegisterViewToVerifyingView() {
        let src = storyboard.instantiateViewController(withIdentifier: "RegisterPage") as! UserAuthViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "EmailVerifPage") as! EmailVerificationViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "verificationSegue", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromVerifyingViewToVerifiedView() {
        let src = storyboard.instantiateViewController(withIdentifier: "EmailVerifPage") as! EmailVerificationViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "VerifiedPage") as! VerifiedViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "verifiedSegue", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }
    
    func testUidTidPassedFromVerifiedViewToMiddleView() {
        let src = storyboard.instantiateViewController(withIdentifier: "VerifiedPage") as! VerifiedViewController
        let dest = storyboard.instantiateViewController(withIdentifier: "MiddleView") as! MiddleViewController
        let seg: UIStoryboardSegue = UIStoryboardSegue(identifier: "registerSegue", source: src, destination: dest)
        
        src.uid = "4afks9df92k3eads0k"
        src.tid = "12392949234923234"
        src.prepare(for: seg, sender: src)
        
        XCTAssertEqual("4afks9df92k3eads0k", dest.uid)
        XCTAssertEqual("12392949234923234", dest.tid)
    }


}
