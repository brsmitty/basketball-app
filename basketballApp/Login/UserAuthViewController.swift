//
//  UserAuthViewController.swift
//  basketball-app
//
//  Created by David on 9/10/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//
//  Updated on 10/19: changed to Firestore
import UIKit
import FirebaseFirestore
import FirebaseAuth

enum AlertTypes{
   case RegisterFailed
   case None
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
   @IBOutlet var forgotYourPassword: UIButton!
   @IBOutlet var backToLogin: UIButton!
   
   @IBOutlet var ballIcon: UIImageView!
   @IBOutlet var appName: UILabel!
   @IBOutlet var createAccount: UILabel!
   
    var uid: String = ""
    var tid: String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      if let passwordLabel = passwordMatchLabel{
         passwordLabel.text = ""
      }

      if let validLabel = validityLabel{
         validLabel.text = ""
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
         registerEmail.tag = 2
         registerEmail.delegate = self
         registerEmail.layer.cornerRadius = 5
      }
      if let registerPass = registerPass{
         registerPass.tag = 3
         registerPass.delegate = self
         registerPass.layer.cornerRadius = 5
      }
      if let registerPassCheck = registerPassCheck{
         registerPassCheck.tag = 4
         registerPassCheck.delegate = self
         registerPassCheck.layer.cornerRadius = 5
      }
      if let teamName = teamName{
         teamName.tag = 5
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
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
   }
   
   @objc func keyboardWillChange(notification: Notification){
      
      if notification.name == Notification.Name.UIKeyboardWillChangeFrame || notification.name == Notification.Name.UIKeyboardWillShow{
         
         view.frame.origin.y = -170
      }else {
         view.frame.origin.y = 0
      }
   }
    
    @objc func checkEmailValidation(){
        Auth.auth().currentUser!.reload { (error) in
            if (Auth.auth().currentUser!.isEmailVerified){
                self.emailVerificationTimer.invalidate()
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
            }
        }
    }
    
    @IBAction func registerClicked(_ sender: Any){
      
      if(registerEmail.text == ""){
         createAlert(with: "Registration Failed", and: "Email Required")
      }
      else if(registerPassCheck.text == "" && registerPass.text == ""){
         createAlert(with: "Registration Failed", and: "Password and Re-Type Password Required")
      }else if(registerPass.text != registerPassCheck.text){
         createAlert(with: "Registration Failed", and: "Password and Re-Type Password must match")
      }
      else if(teamName.text == ""){
         createAlert(with: "Registration Failed", and: "Team Name Required")
      }
      else{
        Auth.auth().createUser(withEmail: registerEmail.text!, password: registerPass.text!) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: self.registerEmail.text!, password: self.registerPass.text!) { user, error in
                    if let error = error, user == nil {
                     self.createAlert(with: "Registration Failed", and: error.localizedDescription)
                    }
                    else {
                     self.performSegue(withIdentifier: "verificationSegue", sender: nil)
                    }
                }
                UserDefaults.standard.set(self.teamName.text, forKey: "team")
            }
            else {
               self.createAlert(with: "Registration Failed", and: error!.localizedDescription)
            }
        }
      }
    }
   
   func createAlert(with title:String, and alert: String){
      let alert = UIAlertController(title: title, message: alert, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true, completion: nil)
   }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard
            let email = loginEmail.text,
            let password = loginPass.text
        else { return }
      if (loginPass.text == "" || loginEmail.text == "") {
         createAlert(with: "Sign In Failed", and: "Email and Password field cannot be empty")
      } else {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
               self.createAlert(with: "Sign In Failed", and: error.localizedDescription)
            }
            else {
                print("in else")
                let ref = Firestore.firestore().collection("users").document(user!.user.uid)
                print("made it past ref assignment")
                //let ref = FireRoot.user.child(user!.user.uid)
                var tid = ""
                //ref.child(<#T##pathString: String##String#>)
                ref.getDocument{(document,error) in
                    if let document = document, document.exists{
                        print("uhhhh")
                        //tid = ref.value(forKey: self.uid) as! String
                        tid = document.get("team_name") as! String
                        print("FFFFFFFFFFFFFF")
                        print(tid)
                        UserDefaults.standard.set(user!.user.uid, forKey: "uid")
                        UserDefaults.standard.set(tid, forKey: "tid")
                        print(UserDefaults.standard.string(forKey: "tid"))
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }else{
                        print(" Problem getting document")
                    }
                }
            }
        }
      }
    }
    
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      switch(textField.tag){
         case 0:
            loginPass.becomeFirstResponder()
            break
      case 1:
         textField.resignFirstResponder()
         loginClicked(UIGestureRecognizer.touchesBegan(UIGestureRecognizer.init()))
      case 2:
         registerPass.becomeFirstResponder()
         break
      case 3:
         registerPassCheck.becomeFirstResponder()
         break
      case 4:
         teamName.becomeFirstResponder()
         break
      case 5:
         registerClicked(UIGestureRecognizer.touchesBegan(UIGestureRecognizer.init()))
         break
      default:
         break
      }
      return true
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      switch textField.tag{
         case 2:
            if (registerEmail.text != ""){
               emailCheck()
            }
            break
         case 3:
            if (registerPassCheck.text != "" && registerPass.text != ""){
               passwordCheck()
            }
            break
         case 4:
            if (registerPassCheck.text != "" && registerPass.text != ""){
               passwordCheck()
            }
            break
         case 5:
            break
         default: break
      }
   }
   
   func passwordCheck(){
      if (registerPassCheck.text == registerPass.text) {
         passwordMatchLabel.text = "Passwords Match"
         passwordMatchLabel.textColor = UIColor.green
      }
      else {
         passwordMatchLabel.text = "Passwords Don't Match"
         passwordMatchLabel.textColor = UIColor.red //(red: 193, green: 39, blue: 45, alpha: 1)
      }
   }
   
   
   func emailCheck(){
      if (emailStringCheck()) {
         validityLabel.text = "Valid"
         validityLabel.textColor = UIColor.green
      }
      else {
         validityLabel.text = "Invalid"
         validityLabel.textColor = UIColor.red
      }
   }
   
   func emailStringCheck() -> Bool{
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
      return emailTest.evaluate(with:registerEmail.text)
      // Code from Maxim Shoustin and Gabbyboy - StackOverflow
   }
   
   @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
      view.endEditing(true)
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "loginSegue" {
            if let dest = segue.destination as? TeamSummaryViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        if segue.identifier == "verificationSegue" {
            if let dest = segue.destination as? EmailVerificationViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
    }
}

