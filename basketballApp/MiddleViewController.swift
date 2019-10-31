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
import FirebaseDatabase




class MiddleViewController: UIViewController {
    
    var schedules: [String] = []
    var times: [String] = []
    var dates: [Date] = []
    var locations: [String] = []
    var uid: String = ""
    var tid: String = ""
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var welcomeBar: UIImageView!
    
    @IBOutlet weak var kpiBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var playbookBtn: UIButton!
    @IBOutlet weak var scheduleBtn: UIButton!
    @IBOutlet weak var performanceBtn: UIButton!
    @IBOutlet weak var gameTimeBtn: UIButton!
    @IBOutlet weak var playerManagerBtn: UIButton!
    
    @IBOutlet weak var NGDetail: UILabel!
    @IBOutlet weak var NGDate: UILabel!
    
   @IBOutlet var mainView: UIView!
   @IBOutlet weak var settingsView: UIView!
   @IBOutlet weak var NGTitle: UILabel!
    var admin: Bool = false
    // holds the player reference to firebase
    var playRef:DatabaseReference?
    // holds the database reference to firebase
    var databaseHandle:DatabaseHandle?
    // holds the users unique user ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(false, forKey: "admin")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        //let defaults = UserDefaults.standard
        //uid = defaults.string(forKey: "uid")!
        
        // Get the user id and set it to the user id global variable
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let uId = user?.uid else {return}
                self.uid = uId
            }
        }
      settingsView.isHidden = true
        getGames()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Store the new players in firebase
        playRef?.removeObserver(withHandle: databaseHandle!)
    }
    
    
    func gameIsUsers(_ lid:String)-> Bool{
        var isUsers = false
        
        let lineupId = lid.prefix(28)
        isUsers = lineupId == uid
        
        return isUsers
    }
    
    func getGames(){
        // Set up the references
        //Change this function only
        playRef = Database.database().reference()
        databaseHandle = playRef?.child("games").observe(.childAdded, with: { (snapshot) in
            
            // If the player is one of the users players add it to the table
                // take data from the snapshot and add a player object
                if(self.gameIsUsers(snapshot.key)){
                    let title = snapshot.childSnapshot(forPath: "title")
                    let location = snapshot.childSnapshot(forPath: "location")
                    let gameDate = snapshot.childSnapshot(forPath: "gameDate")
                    let gameTime = snapshot.childSnapshot(forPath: "gameTime")
                    
                    self.schedules.append(title.value as! String)
                    self.times.append(gameTime.value as! String)
                    self.locations.append(location.value as! String)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM, dd, yyyy"
                    let date = dateFormatter.date(from: gameDate.value as! String)
                    self.dates.append(date!)
                    
                    if(self.schedules[0] != ""){
                        let temp = self.compareDates()
                        let currentDate = NSDate()
                        if(temp > currentDate as Date){
                            let dataFormatter = DateFormatter()
                            dataFormatter.dateFormat = "MM/dd/yyyy"
                            self.NGDate.text = dataFormatter.string(from: temp)
                            let number = self.dates.index(of: temp)!
                            self.NGTitle.text = self.schedules[number]
                            let temp2 = self.locations[number] + " - " + self.times[number]
                            self.NGDetail.text = temp2
                        }
                    }
                }

        })
    }
    
    func compareDates() -> Date{
        var temp: Date = dates[0]
        let currentDate = NSDate()
        for everyDate in dates{
            if(temp > everyDate || temp < currentDate as Date){
                temp = everyDate
            }
        }
        return temp
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
   @IBAction func openSettings(_ sender: UIButton) {
      settingsView.isHidden = false
      
      self.settingsView.frame = CGRect(x: 0, y: -settingsView.frame.height, width: settingsView.frame.width, height: settingsView.frame.height)
      self.view.layoutIfNeeded()
      
      UIView.animate(withDuration: 0.3, animations: {
         self.settingsView.frame = CGRect(x: 0, y: 0, width: self.settingsView.frame.width, height: self.settingsView.frame.height)
         self.view.layoutIfNeeded()
      })
   }
   
   @IBAction func closeSettings(_ sender: UITapGestureRecognizer){

      if (sender.location(in: mainView).y > settingsView.frame.height){
         if(!settingsView.isHidden){
            UIView.animate(withDuration: 0.3, animations: {
               self.settingsView.frame = CGRect(x: 0, y: -self.settingsView.frame.height, width: self.settingsView.frame.width, height: self.settingsView.frame.height)
               self.view.layoutIfNeeded()
            }, completion: {(finished) -> Void in
               self.settingsView.isHidden = true
            })
         }
      }
         
      
   }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "schedule" {
            if let dest = segue.destination as? ScheduleViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "playbook" {
            if let dest = segue.destination as? PlaybookMasterViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "playerManager" {
            if let dest = segue.destination as? PlayerManagerViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "gameView" {
            if let dest = segue.destination as? GameViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "performanceSegue" {
            if let dest = segue.destination as? PerformanceViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "kpiSegue" {
            if let dest = segue.destination as? BoxScoreViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "mainMenu" {
            if let dest = segue.destination as? MiddleViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
    }

}
