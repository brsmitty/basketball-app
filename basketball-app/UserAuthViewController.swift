//
//  UserAuthViewController.swift
//  basketball-app
//
//  Created by David on 9/10/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserAuthViewController: UIViewController {
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPass: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
//                at this point, we know the user is authenticated, and can proceed to auth guarded app screens.
//                self.performSegue(withIdentifier: self.viewController, sender: nil)
                self.loginEmail.text = nil
                self.loginPass.text = nil
                self.registerEmail.text = nil
                self.registerPass.text = nil
            }
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        Auth.auth().createUser(withEmail: registerEmail.text!, password: registerPass.text!) { (authResult, error) in
            if error == nil {
                guard let user = authResult?.user else { return }
                let ref = Database.database().reference(withPath: "users")
                let userRef = ref.child(user.uid)
                let userData : [String: Any] = ["uid":  user.uid]
                userRef.setValue(userData)
            }
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        Auth.auth().signIn(withEmail: loginEmail.text!, password: loginPass.text!) { (user, error) in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

