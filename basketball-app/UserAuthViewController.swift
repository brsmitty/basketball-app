//
//  UserAuthViewController.swift
//  basketball-app
//
//  Created by David on 9/10/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserAuthViewController: UIViewController {
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPass: UITextField!
    
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerUser: UITextField!
    @IBOutlet weak var registerPass: UITextField!
    
    
    @IBAction func loginClicked(_ sender: Any) {
        var db: DatabaseReference!
        var db_handler: DatabaseHandle!
        db = Database.database().reference()
        db.child("APM").setValue("Mike")
        db_handler = db.child("APM").observe(.childAdded, with: { (data) in
            let value : String = (data.value as? String)!
            print(value)
        })
        Auth.auth().signIn(withEmail: loginEmail.text!, password: loginPass.text!) { (user, error) in
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        Auth.auth().createUser(withEmail: registerEmail.text!, password: registerPass.text!) { (authResult, error) in
            guard let user = authResult?.user else { return }
            
        }
    }
    
}
