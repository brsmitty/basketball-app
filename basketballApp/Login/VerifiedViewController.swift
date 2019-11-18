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
    var uid: String = ""
    var tid: String = ""
   
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "registerSegue" {
            if let dest = segue.destination as? TeamSummaryViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
    }

}
