//
//  DropDownViewController.swift
//  basketball-app
//
//  Created by Mike White on 11/8/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

/**
 controls view for dropdown menu
 */
class DropDownViewController: UIViewController {

   @IBOutlet weak var logoutButton: UIButton!
   @IBOutlet weak var settingsButton: UIButton!
   override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.layer.cornerRadius = 5
      settingsButton.layer.cornerRadius = 5
    }
    

    /**
     provides logout feature
     */
   @IBAction func logout(_ sender: UIButton) {
      let firebaseAuth = Auth.auth()
      do {
         try firebaseAuth.signOut()
         self.performSegue(withIdentifier: "logoutSegue", sender: nil)
      } catch let signOutError as NSError {
         print ("Error signing out: %@", signOutError)
      }
   }

}
