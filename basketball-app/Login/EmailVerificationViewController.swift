//
//  EmailVerificationViewController.swift
//  basketball-app
//
//  Created by Mike White on 10/3/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class EmailVerificationViewController: UIViewController {

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
      emailVerification()
    }
    

   @IBAction func resendCode(_ sender: UIButton) {
      emailVerificationTimer = Timer()
      print("resending email")
      Auth.auth().currentUser?.sendEmailVerification { (error) in
         if (Auth.auth().currentUser!.isEmailVerified){
            self.performSegue(withIdentifier: "verifiedSegue", sender: nil)
         }
         else{
            self.emailVerificationTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkEmailValidation), userInfo: nil, repeats: true)
         }
      }
   }
   
   @objc func checkEmailValidation(){
      Auth.auth().currentUser!.reload { (error) in
         print(Auth.auth().currentUser!.isEmailVerified)
         if (Auth.auth().currentUser!.isEmailVerified){
            self.emailVerificationTimer.invalidate()
            self.performSegue(withIdentifier: "verifiedSegue", sender: nil)
         }
      }
   }
   
   func emailVerification(){
      
      print("sending email")
      Auth.auth().currentUser?.sendEmailVerification { (error) in
          if (Auth.auth().currentUser!.isEmailVerified){
              self.performSegue(withIdentifier: "verifiedSegue", sender: nil)
          }
          else{
              self.emailVerificationTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkEmailValidation), userInfo: nil, repeats: true)
          }
      }
   }
   
   

}
