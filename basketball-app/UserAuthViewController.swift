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

enum Logging: Error {
   case invalidEmail
}

class UserAuthViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPass: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPass: UITextField!
   @IBOutlet weak var registerPassCheck: LoginTextField!
   @IBOutlet weak var teamName: LoginTextField!
   @IBOutlet weak var validityLabel: UILabel!
   @IBOutlet weak var passwordMatchLabel: UILabel!
   var emailVerificationTimer: Timer!
    
   @IBOutlet weak var loginButton: UIButton!
   @IBOutlet weak var registerButton: UIButton!
   @IBOutlet weak var signUpButton: UIButton!
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
      if let emailField = loginEmail{
         emailField.delegate = self
         emailField.tag = 0
         emailField.layer.cornerRadius = 5
      }
      if let passField = loginPass{
         passField.delegate = self
         passField.tag = 1
         passField.layer.cornerRadius = 5
      }
      
      if let registerEmail = registerEmail{
         registerEmail.delegate = self
         registerEmail.layer.cornerRadius = 5
      }
      if let registerPass = registerPass{
         registerPass.delegate = self
         registerPass.layer.cornerRadius = 5
      }
      if let registerPassCheck = registerPassCheck{
         registerPassCheck.delegate = self
         registerPassCheck.layer.cornerRadius = 5
      }
      if let teamName = teamName{
         teamName.delegate = self
         teamName.layer.cornerRadius = 5
      }
      if let loginButton = loginButton{
         loginButton.layer.cornerRadius = 5
      }
      if let registerButton = registerButton{
         registerButton.layer.cornerRadius = 5
      }
      if let signUpButton = signUpButton{
         signUpButton.layer.cornerRadius = 5
      }
      
    }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
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
                     self.performSegue(withIdentifier: "verificationSegue", sender: nil)
//                        print("sending email")
//                        Auth.auth().currentUser?.sendEmailVerification { (error) in
//                            if (Auth.auth().currentUser!.isEmailVerified){
//                                self.performSegue(withIdentifier: "registerSegue", sender: nil)
//                            }
//                            else{
//                                self.emailVerificationTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkEmailValidation), userInfo: nil, repeats: true)
//                            }
//                        }
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
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
      textField.resignFirstResponder()
      return true
   }
}

