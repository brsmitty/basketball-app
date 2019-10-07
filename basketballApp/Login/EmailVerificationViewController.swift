//
//  EmailVerificationViewController.swift
//  basketball-app
//
//  Created by Mike White on 10/3/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EmailVerificationViewController: UIViewController {

   var emailVerificationTimer: Timer!
   var AuthU = Auth.auth()
   var DatabaseU = Database.database()
   @IBOutlet var descriptOne: UILabel!
   @IBOutlet var descriptTwo: UILabel!
   @IBOutlet var descriptThree: UILabel!
    var uid: String = ""
    var tid: String = ""
   
   @IBOutlet var resendCodeButton: UIButton!
   
   override func viewDidLoad() {
        super.viewDidLoad()
        emailVerification()
    }
    

   @IBAction func resendCode(_ sender: UIButton) {
      emailVerificationTimer = Timer()
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
            self.createUser()
            self.performSegue(withIdentifier: "verifiedSegue", sender: nil)
         }
      }
   }
    //Important to note putting user into database
    func createUser(){ // create OUR OWN user record in the database. NOTE: this is independent from the Firebase Authentication System!!!
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        DBApi.sharedInstance.currentUserId = uid
        
        let firebaseRef = Database.database().reference(withPath: "users")
        let userRef = firebaseRef.child(uid)
        let tid = String(format: "%f", NSDate().timeIntervalSince1970).replacingOccurrences(of: ".", with: "")
        let userData : [String: Any] = ["uid":  uid, "tid": tid]
        userRef.setValue(userData)
        storePersistentData(uid: uid, tid: tid)
    }
    
    func storePersistentData(uid: String, tid: String){
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: "uid")
        defaults.set(tid, forKey: "tid")
    }
    
    func retrievePersistentData(){
        let defaults = UserDefaults.standard
        print(defaults.string(forKey: "uid")!)
        print(defaults.string(forKey: "tid")!)
    }
   
   func emailVerification(){
      Auth.auth().currentUser?.sendEmailVerification { (error) in
          if (Auth.auth().currentUser!.isEmailVerified){
              self.performSegue(withIdentifier: "verifiedSegue", sender: nil)
          }
          else{
              self.emailVerificationTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkEmailValidation), userInfo: nil, repeats: true)
          }
      }
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "verifiedSegue" {
            if let dest = segue.destination as? VerifiedViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
    }
   
   

}
