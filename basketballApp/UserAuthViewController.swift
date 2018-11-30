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
    }
    
    @objc func checkEmailValidation(){ // reload user from firebase every 5 seconds until email is verified
        Auth.auth().currentUser!.reload { (error) in
            if (Auth.auth().currentUser!.isEmailVerified){
                self.emailVerificationTimer.invalidate()
                self.createUser()
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
            }
        }
    }
    
    func createUser(){ // create OUR OWN user record in the database. NOTE: this is independent from the Firebase Authentication System!!!
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let firebaseRef = Database.database().reference(withPath: "users")
        let userRef = firebaseRef.child(uid)
        let tid = String(format: "%f", NSDate().timeIntervalSince1970).replacingOccurrences(of: ".", with: "")
        let userData : [String: Any] = ["uid":  uid, "tid": tid]
        userRef.setValue(userData)
        createTeam(tid: tid)
        storePersistentData(uid: uid, tid: tid)
    }
    
    func createTeam(tid: String){ // create team record for the newly created team of the newly created user
        let firebaseRef = Database.database().reference(withPath: "teams")
        let teamRef = firebaseRef.child(tid)
        let teamData : [String: Any] = ["tid":  tid]
        teamRef.setValue(teamData)
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
    
    @IBAction func registerClicked(_ sender: Any) {
        Auth.auth().createUser(withEmail: registerEmail.text!, password: registerPass.text!) { user, error in // attempt to register new user
            if error == nil { // proceed if account WAS successfully created
                Auth.auth().signIn(withEmail: self.registerEmail.text!, password: self.registerPass.text!) { user, error in // attempt to sign in the newly registered user
                    if let error = error, user == nil { // display error if sign in was NOT successful
                        let alert = UIAlertController(title: "Sign In Failed", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else { // proceed if sign in WAS successful
                        Auth.auth().currentUser?.sendEmailVerification { (error) in // send verification email and begin timer on 5-second interval until email is verified
                            self.emailVerificationTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkEmailValidation), userInfo: nil, repeats: true)
                        }
                    }
                }
            }
            else { // display error if registration was NOT successful
                let alert = UIAlertController(title: "Registration Failed", message: error!.localizedDescription, preferredStyle: .alert)
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
        else { return }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.retrievePersistentData()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
}

