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

class LineupEditorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

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
   
   
   @IBOutlet weak var playerOneClear: UIButton!
   @IBOutlet weak var playerTwoClear: UIButton!
   @IBOutlet weak var playerThreeClear: UIButton!
   @IBOutlet weak var playerFourClear: UIButton!
   @IBOutlet weak var playerFiveClear: UIButton!
   
   var tableIsVisible = false
   
   var nameForLineup: String?
   var players: [Player] = [Player]()
   var playersLeft: [Player] = [Player]()
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
   
   // Holds the path to the current row highlighed in the table view
   var currentPath = IndexPath()
   
   var lineup: [Player]?
   
   var playerOne: Player?
   var playerTwo: Player?
   var playerThree: Player?
   var playerFour: Player?
   var playerFive: Player?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      if let lineup = lineup {
         playerOne = lineup[0]
         playerTwo = lineup[1]
         playerThree = lineup[2]
         playerFour = lineup[3]
         playerFive = lineup[4]
         playerOneName.text = (playerOne?.firstName)! + " " + (playerOne?.lastName)!
         playerOnePos.text = playerOne?.position
         playerTwoName.text = (playerTwo?.firstName)! + " " + (playerTwo?.lastName)!
         playerTwoPos.text = playerTwo?.position
         playerThreeName.text = (playerThree?.firstName)! + " " + (playerThree?.lastName)!
         playerThreePos.text = playerThree?.position
         playerFourName.text = (playerFour?.firstName)! + " " + (playerFour?.lastName)!
         playerFourPos.text = playerFour?.position
         playerFiveName.text = (playerFive?.firstName)! + " " + (playerFive?.lastName)!
         playerFivePos.text = playerFive?.position
         lineupName.text = nameForLineup
         lineupName.resignFirstResponder()
      }
      updateSaveButtonState()
    }
   
   override func viewWillAppear(_ animated: Bool) {
      // Get the user id and set it to the user id global variable
      Auth.auth().addStateDidChangeListener() { auth, user in
         if user != nil {
            guard let uId = user?.uid else {return}
            self.uid = uId
         }
      }
      self.getPlayers()
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
      self.lineupName.delegate = self
      self.lineupName.becomeFirstResponder()
      playerOneClear.isEnabled = false;
      playerTwoClear.isEnabled = false;
      playerThreeClear.isEnabled = false;
      playerFourClear.isEnabled = false;
      playerFiveClear.isEnabled = false;
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
         if(self.playerIsUsers(snapshot.key)){
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
            self.currentPath = IndexPath(row:self.players.count, section: 0)
            self.players.append(player)
            self.playersLeft.append(player)
            
            self.tableDropDownOne.beginUpdates()
            self.tableDropDownTwo.beginUpdates()
            self.tableDropDownThree.beginUpdates()
            self.tableDropDownFour.beginUpdates()
            self.tableDropDownFive.beginUpdates()
            
            self.tableDropDownOne.insertRows(at: [self.currentPath], with: .automatic)
            self.tableDropDownTwo.insertRows(at: [self.currentPath], with: .automatic)
            self.tableDropDownThree.insertRows(at: [self.currentPath], with: .automatic)
            self.tableDropDownFour.insertRows(at: [self.currentPath], with: .automatic)
            self.tableDropDownFive.insertRows(at: [self.currentPath], with: .automatic)
            
            self.tableDropDownOne.endUpdates()
            self.tableDropDownTwo.endUpdates()
            self.tableDropDownThree.endUpdates()
            self.tableDropDownFour.endUpdates()
            self.tableDropDownFive.endUpdates()
         }
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
      return playersLeft.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let playerCell = "PlayerCell"
      // grab the cell from the table view
      guard let cell = tableView.dequeueReusableCell(withIdentifier: playerCell, for: indexPath)as? DropDownTableViewCell
         else{
            fatalError("Dequeued cell was not of type DropDownTableViewCell")
      }
      
      // get the player name from the array
      cell.playerName.text = playersLeft[indexPath.row].firstName + " " + playersLeft[indexPath.row].lastName
      cell.playerImage.image = playersLeft[indexPath.row].photo
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      switch tableView.tag {
      case 0:
         playerOneName.text = playersLeft[indexPath.row].firstName + " " + playersLeft[indexPath.row].lastName
         playerOneImage.image = playersLeft[indexPath.row].photo
         playerOnePos.text = playersLeft[indexPath.row].position
         UIView.animate(withDuration: 0.5){
            self.tableDropDownOneHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         if(playerOne != nil){
            playersLeft.append(players[players.firstIndex(of: playerOne!)!])
            insertRows(indexPath)
         }
         playerOne = playersLeft[indexPath.row]
         playerOneClear.isEnabled = true
         playersLeft.remove(at: indexPath.row)
         reloadTableViews(indexPath)
         break
      case 1:
         playerTwoName.text = playersLeft[indexPath.row].firstName + " " + playersLeft[indexPath.row].lastName
         playerTwoImage.image = playersLeft[indexPath.row].photo
         playerTwoPos.text = playersLeft[indexPath.row].position
         UIView.animate(withDuration: 0.5){
            self.tableDropDownTwoHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         if(playerTwo != nil){
            playersLeft.append(players[players.firstIndex(of: playerTwo!)!])
            insertRows(indexPath)
         }
         playerTwo = playersLeft[indexPath.row]
         playerTwoClear.isEnabled = true
         playersLeft.remove(at: indexPath.row)
         reloadTableViews(indexPath)
         break
      case 2:
         playerThreeName.text = playersLeft[indexPath.row].firstName + " " + playersLeft[indexPath.row].lastName
         playerThreeImage.image = playersLeft[indexPath.row].photo
         playerThreePos.text = playersLeft[indexPath.row].position
         UIView.animate(withDuration: 0.5){
            self.tableDropDownThreeHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         if(playerThree != nil){
            playersLeft.append(players[players.firstIndex(of: playerThree!)!])
            insertRows(indexPath)
         }
         playerThree = playersLeft[indexPath.row]
         playerThreeClear.isEnabled = true
         playersLeft.remove(at: indexPath.row)
         reloadTableViews(indexPath)
         break
      case 3:
         playerFourName.text = playersLeft[indexPath.row].firstName + " " + playersLeft[indexPath.row].lastName
         playerFourImage.image = playersLeft[indexPath.row].photo
         playerFourPos.text = playersLeft[indexPath.row].position
         UIView.animate(withDuration: 0.5){
            self.tableDropDownFourHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         if(playerFour != nil){
            playersLeft.append(players[players.firstIndex(of: playerFour!)!])
            insertRows(indexPath)
         }
         playerFour = playersLeft[indexPath.row]
         playersLeft.remove(at: indexPath.row)
         reloadTableViews(indexPath)
         playerFourClear.isEnabled = true
         break
      case 4:
         playerFiveName.text = playersLeft[indexPath.row].firstName + " " + playersLeft[indexPath.row].lastName
         playerFiveImage.image = playersLeft[indexPath.row].photo
         playerFivePos.text = playersLeft[indexPath.row].position
         UIView.animate(withDuration: 0.5){
            self.tableDropDownFiveHC.constant = 0
            self.tableIsVisible = false
            self.view.layoutIfNeeded()
         }
         if(playerFive != nil){
            playersLeft.append(players[players.firstIndex(of: playerFive!)!])
            insertRows(indexPath)
         }
         playerFive = playersLeft[indexPath.row]
         playerFiveClear.isEnabled = true
         playersLeft.remove(at: indexPath.row)
         reloadTableViews(indexPath)
         break
      default:
         break
      }
      updateSaveButtonState()

   }
   
   
   @IBAction func cancel(_ sender: UIBarButtonItem) {
      let isPresentingInAddMealMode = presentingViewController is UINavigationController
      
      if isPresentingInAddMealMode {
         dismiss(animated: true, completion: nil)
      }
      else if let owningNavigationController = navigationController{
         owningNavigationController.popViewController(animated: true)
      }
      else {
         fatalError("The MealViewController is not inside a navigation controller.")
      }
   }
   
   @IBAction func selectPlayerOne(_ sender: UITapGestureRecognizer) {
      lineupName.resignFirstResponder()
      closeAllTables()
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
      lineupName.resignFirstResponder()
      closeAllTables()
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
      lineupName.resignFirstResponder()
      closeAllTables()
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
      lineupName.resignFirstResponder()
      closeAllTables()
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
      lineupName.resignFirstResponder()
      closeAllTables()
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
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      if let text = textField.text{
         if(text.isEmpty) {saveButton.isEnabled = false}
         else {saveButton.isEnabled = true}
      }else{
         saveButton.isEnabled = true
      }
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      updateSaveButtonState()
      navigationItem.title = textField.text
   }
   
   private func updateSaveButtonState() {
      // Disable the Save button if the text field is empty.
      let text = lineupName.text ?? ""
      let player1 = playerOne ?? nil
      let player2 = playerTwo ?? nil
      let player3 = playerThree ?? nil
      let player4 = playerFour ?? nil
      let player5 = playerFive ?? nil
      if((player1 != nil) && (player2 != nil) && (player3 != nil) && (player4 != nil) && (player5 != nil) && (!text.isEmpty)){
         saveButton.isEnabled = true
      }else{
         saveButton.isEnabled = false
      }
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   @IBAction func clearPlayerOne(_ sender: UIButton) {
      let indexPath = IndexPath(item: playersLeft.count, section: 0)
      playersLeft.append(players[players.firstIndex(of: playerOne!)!])
      insertRows(indexPath)
      playerOne = nil
      playerOnePos.text = "Position"
      playerOneName.text = "Name"
      playerOneImage.image = UIImage(named:"Default")
      updateSaveButtonState()
      playerOneClear.isEnabled = false
   }
   @IBAction func clearPlayerTwo(_ sender: UIButton) {
      let indexPath = IndexPath(item: playersLeft.count, section: 0)
      playersLeft.append(players[players.firstIndex(of: playerTwo!)!])
      insertRows(indexPath)
      playerTwo = nil
      playerTwoPos.text = "Position"
      playerTwoName.text = "Name"
      playerTwoImage.image = UIImage(named:"Default")
      updateSaveButtonState()
      playerTwoClear.isEnabled = false
   }
   
   @IBAction func clearPlayerThree(_ sender: UIButton) {
      let indexPath = IndexPath(item: playersLeft.count, section: 0)
      playersLeft.append(players[players.firstIndex(of: playerThree!)!])
      insertRows(indexPath)
      playerThree = nil
      playerThreePos.text = "Position"
      playerThreeName.text = "Name"
      playerThreeImage.image = UIImage(named:"Default")
      updateSaveButtonState()
      playerThreeClear.isEnabled = false
   }
   
   @IBAction func clearPlayerFour(_ sender: UIButton) {
      let indexPath = IndexPath(item: playersLeft.count, section: 0)
      playersLeft.append(players[players.firstIndex(of: playerFour!)!])
      insertRows(indexPath)
      playerFour = nil
      playerFourPos.text = "Position"
      playerFourName.text = "Name"
      playerFourImage.image = UIImage(named:"Default")
      updateSaveButtonState()
      playerFourClear.isEnabled = false
   }
   
   @IBAction func clearPlayerFive(_ sender: UIButton) {
      let indexPath = IndexPath(item: playersLeft.count, section: 0)
      playersLeft.append(players[players.firstIndex(of: playerFive!)!])
      insertRows(indexPath)
      playerFive = nil
      playerFivePos.text = "Position"
      playerFiveName.text = "Name"
      playerFiveImage.image = UIImage(named:"Default")
      updateSaveButtonState()
      playerFiveClear.isEnabled = false
   }
   
   func insertRows(_ indexPath:IndexPath){
      tableDropDownOne.insertRows(at: [indexPath], with: .none)
      tableDropDownTwo.insertRows(at: [indexPath], with: .none)
      tableDropDownThree.insertRows(at: [indexPath], with: .none)
      tableDropDownFour.insertRows(at: [indexPath], with: .none)
      tableDropDownFive.insertRows(at: [indexPath], with: .none)
   }
   
   func reloadTableViews(_ indexPath:IndexPath){
      tableDropDownOne.deleteRows(at: [indexPath], with: .none)
      tableDropDownTwo.deleteRows(at: [indexPath], with: .none)
      tableDropDownThree.deleteRows(at: [indexPath], with: .none)
      tableDropDownFour.deleteRows(at: [indexPath], with: .none)
      tableDropDownFive.deleteRows(at: [indexPath], with: .none)
   }
   
   func closeAllTables(){
      UIView.animate(withDuration: 0.5){
         self.tableDropDownFiveHC.constant = 0
         self.tableIsVisible = false
         self.view.layoutIfNeeded()
      }
      UIView.animate(withDuration: 0.5){
         self.tableDropDownOneHC.constant = 0
         self.tableIsVisible = false
         self.view.layoutIfNeeded()
      }
      UIView.animate(withDuration: 0.5){
         self.tableDropDownThreeHC.constant = 0
         self.tableIsVisible = false
         self.view.layoutIfNeeded()
      }
      UIView.animate(withDuration: 0.5){
         self.tableDropDownTwoHC.constant = 0
         self.tableIsVisible = false
         self.view.layoutIfNeeded()
      }
      UIView.animate(withDuration: 0.5){
         self.tableDropDownFourHC.constant = 0
         self.tableIsVisible = false
         self.view.layoutIfNeeded()
      }
   }
   @IBAction func unselectAll(_ sender: UITapGestureRecognizer) {
      closeAllTables()
      lineupName.resignFirstResponder()
   }
}


