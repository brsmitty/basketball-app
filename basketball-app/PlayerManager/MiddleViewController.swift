//
//  MiddleViewController.swift
//  basketball-app
//
//  Created by Mike White on 9/25/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MiddleViewController: UIViewController {

    var admin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(false, forKey: "admin")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
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
    
    @IBAction func toggleAdmin(_ sender: UIButton) {
        print("value on entrance" + String(admin) + "\n")
        if (admin){
            UserDefaults.standard.setValue(false, forKey: "admin")
            admin = false
            print("set to false\n")
        }
        else{
            let alertController = UIAlertController(title: "Confirm Admin Elevation", message: "Please enter your account password", preferredStyle: .alert)
            alertController.addTextField{ (pwdTextField : UITextField!) -> Void in
                pwdTextField.placeholder = "Password"
                pwdTextField.isSecureTextEntry = true
            }
            let saveAction = UIAlertAction(title: "Continue", style: .default, handler: { alert -> Void in
                let textField = alertController.textFields![0] as UITextField
                let pwd = textField.text!
                let user = Auth.auth().currentUser
                let userEmail = user?.email ?? ""
                let credential: AuthCredential = EmailAuthProvider.credential(withEmail: userEmail, password: pwd)
                user?.reauthenticateAndRetrieveData(with: credential, completion: { (auth, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        UserDefaults.standard.setValue(true, forKey: "admin")
                        self.admin = true
                        print("set to true\n")
                    }
                })
            })
            alertController.addAction(saveAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
