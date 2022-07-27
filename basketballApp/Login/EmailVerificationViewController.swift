//
//  EmailVerificationViewController.swift
//  basketball-app
//
//  Created by Mike White on 10/3/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//
//  Updated on 10/19 : Updated to Firestore

import UIKit
import FirebaseAuth
import FirebaseFirestore

/** logic for sending email verifcation and adding a user to the database*/
class EmailVerificationViewController: UIViewController {

   var emailVerificationTimer: Timer!
   var AuthU = Auth.auth()
   @IBOutlet var descriptOne: UILabel!
   @IBOutlet var descriptTwo: UILabel!
   @IBOutlet var descriptThree: UILabel!
    var uid: String = ""
    var tid: String = ""
   
   @IBOutlet var resendCodeButton: UIButton!
   
   override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black
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
    
    //MARK: Create User
    /**Function putting user into database*/
    func createUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("Adding: " + uid)
        
        let tid = String(format: "%f", NSDate().timeIntervalSince1970).replacingOccurrences(of: ".", with: "")
        
        //Adding user as document and, creating a team id from current time reference and adds team_id and team_name as fields to user id
        let teamName = UserDefaults.standard.string(forKey: "team") ?? ""
        FireRoot.root.document(uid).setData(["team": tid, "team_name": teamName]){
            err in
            if let err = err{
                print(err.localizedDescription)
            }else{
                print("Added user and team name")
            }
        }
        storePersistentData(uid: uid, tid: tid)
    }
    
    //MARK: Store Persistent Data
    func storePersistentData(uid: String, tid: String){
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: "uid")
        defaults.set(tid, forKey: "tid")
    }

    //MARK: Email Verification
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
