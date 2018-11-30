//
//  VerifiedViewController.swift
//  basketball-app
//
//  Created by Mike White on 10/3/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class VerifiedViewController: UIViewController {

   var verifiedTimer: Timer!
   
    override func viewDidLoad() {
        super.viewDidLoad()

      verifiedWait()
        // Do any additional setup after loading the view.
    }
   
   @objc func segueToMainMenu(){
      self.performSegue(withIdentifier: "registerSegue", sender: nil)
   }

   func verifiedWait(){
 
      self.verifiedTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.segueToMainMenu), userInfo: nil, repeats: true)
        
   }

}
