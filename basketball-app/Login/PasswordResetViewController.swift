//
//  PasswordResetViewController.swift
//  basketball-app
//
//  Created by Mike White on 10/14/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordResetViewController: UIViewController, UITextFieldDelegate {

   @IBOutlet weak var emailField: LoginTextField!
   
   @IBOutlet weak var sendButton: UIButton!
   override func viewDidLoad() {
        super.viewDidLoad()
      
      emailField.delegate = self
      emailField.layer.cornerRadius = 5

      sendButton.layer.cornerRadius = 5
      self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
      
      // Listen for keyboard events
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
   }
   
   deinit {
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
   }
   
   @objc func keyboardWillChange(notification: Notification){
      
      if notification.name == Notification.Name.UIKeyboardWillChangeFrame || notification.name == Notification.Name.UIKeyboardWillShow{
         
         view.frame.origin.y = -170
      }else {
         view.frame.origin.y = 0
      }
   }

   @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
      view.endEditing(true)
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
      textField.resignFirstResponder()
      sendResetLink(sendButton)
      return true
   }

   @IBAction func sendResetLink(_ sender: UIButton) {
      Auth.auth().sendPasswordReset(withEmail: emailField.text!) {(error) in
         if error == nil{
            self.createAlert(with: "Reset Link Sent!", and: "Please check your email for the reset link.\nIf it is not in your inbox, check your junk.")
         }else{
            self.createAlert(with: "Reset Failed", and: error!.localizedDescription)
         }
      }
   }
   
   func createAlert(with title:String, and alert: String){
      let alert = UIAlertController(title: title, message: alert, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true, completion: nil)
   }
}
