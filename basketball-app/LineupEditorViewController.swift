//
//  LineupEditorViewController.swift
//  basketball-app
//
//  Created by Mike White on 9/23/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LineupEditorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

   // MARK: Properties
   @IBOutlet weak var lineupName: UITextField!
   @IBOutlet weak var positionOne: UITextField!
   @IBOutlet weak var positionTwo: UITextField!
   @IBOutlet weak var positionThree: UITextField!
   @IBOutlet weak var positionFour: UITextField!
   @IBOutlet weak var positionFive: UITextField!
   @IBOutlet weak var playerOneImage: UIImageView!
   @IBOutlet weak var playerTwoImage: UIImageView!
   @IBOutlet weak var playerThreeImage: UIImageView!
   @IBOutlet weak var playerFourImage: UIImageView!
   @IBOutlet weak var playerFiveImage: UIImageView!
   @IBOutlet weak var playerOneName: UILabel!
   @IBOutlet weak var playerTwoName: UILabel!
   @IBOutlet weak var playerThreeName: UILabel!
   @IBOutlet weak var playerFourName: UILabel!
   @IBOutlet weak var playerFiveName: UILabel!
   @IBOutlet weak var playerOnePos: UILabel!
   @IBOutlet weak var playerTwoPos: UILabel!
   @IBOutlet weak var playerThreePos: UILabel!
   @IBOutlet weak var playerFourPos: UILabel!
   @IBOutlet weak var playerFivePos: UILabel!
   @IBOutlet weak var saveButton: UIBarButtonItem!
   
   @IBOutlet weak var tableDropDownOne: UITableView!
   @IBOutlet weak var tableDropDownOneHC: NSLayoutConstraint!
   
   @IBOutlet weak var tableDropDownTwo: UITableView!
   @IBOutlet weak var tableDropDownTwoHC: NSLayoutConstraint!
   
   @IBOutlet weak var tableDropDownThree: UITableView!
   @IBOutlet weak var tableDropDownThreeHC: NSLayoutConstraint!
   
   @IBOutlet weak var tableDropDownFour: UITableView!
   @IBOutlet weak var tableDropDownFourHC: NSLayoutConstraint!
   
   @IBOutlet weak var tableDropDownFive: UITableView!
   @IBOutlet weak var tableDropDownFiveHC: NSLayoutConstraint!
   
   var tableIsVisible = false
   
   var nameForLineup: String?
   var players: [Player] = [Player]()
   // holds the player reference to firebase
   var playerRef:DatabaseReference?
   // holds the database reference to firebase
   var databaseHandle:DatabaseHandle?
   // holds the users unique user ID
   var uid: String = ""
   // Array of all position names for the picker wheel
   let positionNames:[String] = [String] (arrayLiteral: "","Point-Guard", "Shooting-Guard", "Small-Forward", "Center", "Power-Forward")
   // holds the selected position for the pickerWheel
   var selectedPositionOne: String?
   var selectedPositionTwo: String?
   var selectedPositionThree: String?
   var selectedPositionFour: String?
   var selectedPositionFive: String?
   
   var lineup: [Player]?
   
   var playerOne: Player?
   var playerTwo: Player?
   var playerThree: Player?
   var playerFour: Player?
   var playerFive: Player?
   
   override func viewDidLoad() {
      super.viewDidLoad()

      self.getPlayers()
    }
   
   override func viewWillAppear(_ animated: Bool) {
      // Get the user id and set it to the user id global variable
      Auth.auth().addStateDidChangeListener() { auth, user in
         if user != nil {
            guard let uId = user?.uid else {return}
            self.uid = uId
         }
      }
      createPositionPicker()
      createToolbar()
      self.tableDropDownOne.delegate = self
      self.tableDropDownOne.dataSource = self
      self.tableDropDownTwo.delegate = self
      self.tableDropDownTwo.dataSource = self
      self.tableDropDownThree.delegate = self
      self.tableDropDownThree.dataSource = self
      self.tableDropDownFour.delegate = self
      self.tableDropDownFour.dataSource = self
      self.tableDropDownFive.delegate = self
      self.tableDropDownFive.dataSource = self
      self.tableDropDownOneHC.constant = 0
      self.tableDropDownTwoHC.constant = 0
      self.tableDropDownThreeHC.constant = 0
      self.tableDropDownFourHC.constant = 0
      self.tableDropDownFiveHC.constant = 0
      self.lineupName.becomeFirstResponder()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      // Store the new players in firebase
      playerRef?.removeObserver(withHandle: databaseHandle!)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
      
      // Configure the desitination view controller only when the save button is pressed.
      guard let button = sender as? UIBarButtonItem, button == saveButton else {
         os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
         return
      }
      
      
      lineup = [Player](arrayLiteral: playerOne!, playerTwo!, playerThree!, playerFour!, playerFive!)
      nameForLineup = lineupName.text
    }
   
   
   // MARK: Private Methods
   func getPlayers(){
      // Set up the references
      playerRef = Database.database().reference()
      databaseHandle = playerRef?.child("players").observe(.childAdded, with: { (snapshot) in
         
         // If the player is one of the users players add it to the table
         //if(self.playerIsUsers(snapshot.key)){
            // take data from the snapshot and add a player object
            let fnameSnap = snapshot.childSnapshot(forPath: "fname")
            let lnameSnap = snapshot.childSnapshot(forPath: "lname")
            let heightSnap = snapshot.childSnapshot(forPath: "height")
            let weightSnap = snapshot.childSnapshot(forPath: "weight")
            let positionSnap = snapshot.childSnapshot(forPath: "position")
            let rankSnap = snapshot.childSnapshot(forPath: "rank")
            let pidSnap = snapshot.childSnapshot(forPath: "pid")
            
            guard let player = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: UIImage(named: "Default"), position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String, playerId: pidSnap.value as! String)
               else {
                  fatalError("Counld not instantiate player")
            }
            self.players.append(player)
         //}
      }
   )}
   
   // Checks the player is one of the users
   func playerIsUsers(_ pid:String) -> Bool{
      var isUsers = false
      
      let playerId = pid.prefix(28)
      isUsers = playerId == uid
      
      return isUsers
   }
   
   // Creates the position picker
   func createPositionPicker(){
      let positionPickerOne = UIPickerView()
      positionPickerOne.delegate = self
      let positionPickerTwo = UIPickerView()
      positionPickerTwo.delegate = self
      let positionPickerThree = UIPickerView()
      positionPickerThree.delegate = self
      let positionPickerFour = UIPickerView()
      positionPickerFour.delegate = self
      let positionPickerFive = UIPickerView()
      positionPickerFive.delegate = self
      positionOne.inputView = positionPickerOne
      positionTwo.inputView = positionPickerTwo
      positionThree.inputView = positionPickerThree
      positionFour.inputView = positionPickerFour
      positionFive.inputView = positionPickerFive
      positionPickerOne.tag = 0
      positionPickerTwo.tag = 1
      positionPickerThree.tag = 2
      positionPickerFour.tag = 3
      positionPickerFive.tag = 4
   }
   
   // Creates the toolbar for the pickers
   func createToolbar(){
      let toolbar = UIToolbar()
      toolbar.sizeToFit()
      let doneButton = UIBarButtonItem(title:"Done", style: .done, target: self, action: #selector(PlayerManagerViewController.dismissKeyboard))
      
      toolbar.setItems([doneButton], animated: false)
      toolbar.isUserInteractionEnabled = true
      
      positionOne.inputAccessoryView = toolbar
      positionTwo.inputAccessoryView = toolbar
      positionThree.inputAccessoryView = toolbar
      positionFour.inputAccessoryView = toolbar
      positionFive.inputAccessoryView = toolbar
      
   }
   // Dismisses keyboard
   @objc func dismissKeyboard(){
      view.endEditing(true)
   }
   
   // MARK: PickerViewDelegate
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return positionNames.count
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return positionNames[row]
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch pickerView.tag {
      case 0:
         selectedPositionOne = positionNames[row]
         positionOne.text = selectedPositionOne
         break
      case 1:
         selectedPositionTwo = positionNames[row]
         positionTwo.text = selectedPositionTwo
         break
      case 2:
         selectedPositionThree = positionNames[row]
         positionThree.text = selectedPositionThree
         break
      case 3:
         selectedPositionFour = positionNames[row]
         positionFour.text = selectedPositionFour
         break
      case 4:
         selectedPositionFive = positionNames[row]
         positionFive.text = selectedPositionFive
      default:
         break
      }
      
   }
   
   // MARK: TableViewDelegate
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 4
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let playerCell = "PlayerCell"
      // grab the cell from the table view
      guard let cell = tableView.dequeueReusableCell(withIdentifier: playerCell, for: indexPath)as? DropDownTableViewCell
         else{
            fatalError("Dequeued cell was not of type DropDownTableViewCell")
      }
      
      // get the player name from the array
      cell.playerName.text = players[indexPath.row].firstName + " " + players[indexPath.row].lastName
      cell.playerImage.image = players[indexPath.row].photo
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      switch tableView.tag {
      case 0:
         playerOneName.text = players[indexPath.row].firstName + " " + players[indexPath.row].lastName
         playerOneImage.image = players[indexPath.row].photo
         playerOnePos.text = players[indexPath.row].position
         UIView.animate(withDuration: 0.1){
            self.tableDropDownOneHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         playerOne = players[indexPath.row]
         break
      case 1:
         playerTwoName.text = players[indexPath.row].firstName + " " + players[indexPath.row].lastName
         playerTwoImage.image = players[indexPath.row].photo
         playerTwoPos.text = players[indexPath.row].position
         UIView.animate(withDuration: 0.1){
            self.tableDropDownTwoHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         playerTwo = players[indexPath.row]
         break
      case 2:
         playerThreeName.text = players[indexPath.row].firstName + " " + players[indexPath.row].lastName
         playerThreeImage.image = players[indexPath.row].photo
         playerThreePos.text = players[indexPath.row].position
         UIView.animate(withDuration: 0.1){
            self.tableDropDownThreeHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         playerThree = players[indexPath.row]
         break
      case 3:
         playerFourName.text = players[indexPath.row].firstName + " " + players[indexPath.row].lastName
         playerFourImage.image = players[indexPath.row].photo
         playerFourPos.text = players[indexPath.row].position
         UIView.animate(withDuration: 0.1){
            self.tableDropDownFourHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         playerFour = players[indexPath.row]
         break
      case 4:
         playerFiveName.text = players[indexPath.row].firstName + " " + players[indexPath.row].lastName
         playerFiveImage.image = players[indexPath.row].photo
         playerFivePos.text = players[indexPath.row].position
         UIView.animate(withDuration: 0.1){
            self.tableDropDownFiveHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         playerFive = players[indexPath.row]
         break
      default:
         break
      }

   }
   
   @IBAction func selectPlayerOne(_ sender: UITapGestureRecognizer) {
      UIView.animate(withDuration: 0.5){
         if(!self.tableIsVisible){
            self.tableDropDownOneHC.constant = 44.0 * 5.0
            self.tableIsVisible = true
         }else{
            self.tableDropDownOneHC.constant = 0
            self.tableIsVisible = false
         }
         
         self.view.layoutIfNeeded()
      }
   }
   
   @IBAction func selectPlayerTwo(_ sender: UITapGestureRecognizer) {
      UIView.animate(withDuration: 0.5){
         if(!self.tableIsVisible){
            self.tableDropDownTwoHC.constant = 44.0 * 5.0
            self.tableIsVisible = true
         }else{
            self.tableDropDownTwoHC.constant = 0
            self.tableIsVisible = false
         }
         
         self.view.layoutIfNeeded()
      }
   }
   @IBAction func selectPlayerThree(_ sender: UITapGestureRecognizer) {
      UIView.animate(withDuration: 0.5){
         if(!self.tableIsVisible){
            self.tableDropDownThreeHC.constant = 44.0 * 5.0
            self.tableIsVisible = true
         }else{
            self.tableDropDownThreeHC.constant = 0
            self.tableIsVisible = false
         }
         
         self.view.layoutIfNeeded()
      }
   }
   
   @IBAction func selectPlayerFour(_ sender: UITapGestureRecognizer) {
      UIView.animate(withDuration: 0.5){
         if(!self.tableIsVisible){
            self.tableDropDownFourHC.constant = 44.0 * 5.0
            self.tableIsVisible = true
         }else{
            self.tableDropDownFourHC.constant = 0
            self.tableIsVisible = false
         }
         
         self.view.layoutIfNeeded()
      }
   }
   
   @IBAction func selectPlayerFive(_ sender: UITapGestureRecognizer) {
      UIView.animate(withDuration: 0.5){
         if(!self.tableIsVisible){
            self.tableDropDownFiveHC.constant = 44.0 * 5.0
            self.tableIsVisible = true
         }else{
            self.tableDropDownFiveHC.constant = 0
            self.tableIsVisible = false
         }
         
         self.view.layoutIfNeeded()
      }
   }
}


