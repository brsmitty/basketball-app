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
    @IBOutlet weak var registerPass: UITextField!
    var emailVerificationTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let uid = user?.uid else { return }
                let ref = Database.database().reference(withPath: "users")
                let userRef = ref.child(uid)
                let userData : [String: Any] = ["uid":  uid, "verified": false]
                userRef.setValue(userData)
            }
        }
    }
    
    @objc func checkEmailValidation(){
        Auth.auth().currentUser!.reload { (error) in
            print(Auth.auth().currentUser!.isEmailVerified)
            if (Auth.auth().currentUser!.isEmailVerified){
                self.emailVerificationTimer.invalidate()
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
            }
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: registerEmail.text!, password: registerPass.text!) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: self.registerEmail.text!, password: self.registerPass.text!) { user, error in
                    if let error = error, user == nil {
                        let alert = UIAlertController(title: "Sign In Failed",
                                                      message: error.localizedDescription,
                                                      preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        print("sending email")
                        Auth.auth().currentUser?.sendEmailVerification { (error) in
                            if (Auth.auth().currentUser!.isEmailVerified){
                                self.performSegue(withIdentifier: "registerSegue", sender: nil)
                            }
                            else{
                                self.emailVerificationTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkEmailValidation), userInfo: nil, repeats: true)
                            }
                        }
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "Registration Failed",
                                              message: error!.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard
            let email = loginEmail.text,
            let password = loginPass.text,
            email.count > 0,
            password.count > 0
            else {
                return
            }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in

            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            }
        }
    }
}

