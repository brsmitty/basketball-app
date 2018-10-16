//
//  PlayerManagerViewController.swift
//  basketball-app
//
//  Created by Mike White on 9/10/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PlayerManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   // MARK: Properties
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var playerImage: UIImageView!
   @IBOutlet weak var playerPositionText: UITextField!
   @IBOutlet weak var playerFirstNameText: UITextField!
   @IBOutlet weak var playerLastNameText: UITextField!
   @IBOutlet weak var playerHeightText: UITextField!
   @IBOutlet weak var playerWeightText: UITextField!
   @IBOutlet weak var playerClassText: UITextField!
   @IBOutlet weak var saveButton: UIBarButtonItem!
   @IBOutlet weak var editButton: UIBarButtonItem!
   @IBOutlet weak var addButton: UIBarButtonItem!
   @IBOutlet weak var cancelButton: UIBarButtonItem!
   @IBOutlet weak var pointsCell: UILabel!
   @IBOutlet weak var twoPoint: UILabel!
   @IBOutlet weak var threePoint: UILabel!
   @IBOutlet weak var oRebound: UILabel!
   @IBOutlet weak var pFouls: UILabel!
   @IBOutlet weak var assistsCell: UILabel!
   @IBOutlet weak var fGoalCell: UILabel!
   @IBOutlet weak var freeThrowPerc: UILabel!
   @IBOutlet weak var freeThrowMade: UILabel!
   @IBOutlet weak var tFoulCell: UILabel!
   @IBOutlet weak var stealsCell: UILabel!
   @IBOutlet weak var dRebound: UILabel!
   @IBOutlet weak var deflectionCell: UILabel!
   @IBOutlet weak var blockCell: UILabel!
   @IBOutlet weak var chargeCell: UILabel!
   
   // Holds the path to the current row highlighed in the table view
   var currentPath = IndexPath()
   // setup an array that holds all the players
   var players:[Player] = [Player]()
   // holds the selected position for the pickerWheel
   var selectedPosition: String?
   // holds the selected height for the pickerWheel
   var selectedHeight: String?
   // holds the selected rank for the pickerWheel
   var selectedRank: String?
   // holds the player reference to firebase
   var playerRef:DatabaseReference?
   // holds the database reference to firebase
   var databaseHandle:DatabaseHandle?
   // holds the users unique user ID
   var uid: String = ""
    var tid: String = ""
   // holds the deleted players num
   var deletedPlayerNum: Int = 0
   // holds if a player was recently deleted
   var recentlyDeleted: Bool = false
   
   // Array of all position names for the picker wheel
   let positionNames:[String] = [String] (arrayLiteral: "Point-Guard", "Shooting-Guard", "Small-Forward", "Center", "Power-Forward")
   // Array of all height names for the picker wheel
   let heights:[String] = [String] (arrayLiteral: "5'0\"","5'1\"","5'2\"","5'3\"","5'4\"","5'5\"","5'6\"","5'7\"","5'8\"","5'9\"","5'10\"","5'11\"","6'0\"","6'1\"","6'2\"","6'3\"","6'4\"","6'5\"","6'6\"","6'7\"","6'8\"","6'9\"","6'10\"","6'11\"","7'0\"","7'1\"","7'2\"")
//   let cellNames:[String] = [String] (arrayLiteral: "points","assists","steals","2pg","fg","drebound","3pg","ft%","deflections","orebound","ftmade","blocks","pfoul","tfoul","charge")
   // Array of all class rank names for the picker wheel
   let ranks:[String] = [String] (arrayLiteral: "Freshmen","Sophomore","Junior","Senior")
   
   // MARK: Functions
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // setup the tableView for the different players
      self.tableView.dataSource = self
      self.tableView.delegate = self
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   override func viewWillAppear(_ animated: Bool) {
    
        let defaults = UserDefaults.standard
        uid = defaults.string(forKey: "uid")!
        tid = defaults.string(forKey: "tid")!
      // Get the user id and set it to the user id global variable
      Auth.auth().addStateDidChangeListener() { auth, user in
         if user != nil {
            guard let uId = user?.uid else {return}
            self.uid = uId
         }
      }
      getPlayers()
      setEditPlayerFields(to: false)
      setSaveButton(to: false)
      setCancelButton(to: false)
      setEditButton(to: false)
      createPositionPicker()
      createHeightPicker()
      createClassPicker()
      createToolbar()
      self.navigationController?.setNavigationBarHidden(false, animated: false)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      // Store the new players in firebase
      playerRef?.removeObserver(withHandle: databaseHandle!)
   }
   
   // Set user interaction with the fields
   func setEditPlayerFields(to edit: Bool){
      playerPositionText.isUserInteractionEnabled = edit
      playerFirstNameText.isUserInteractionEnabled = edit
      playerLastNameText.isUserInteractionEnabled = edit
      playerHeightText.isUserInteractionEnabled = edit
      playerWeightText.isUserInteractionEnabled = edit
      playerClassText.isUserInteractionEnabled = edit
      playerImage.isUserInteractionEnabled = edit
   }
   
   // Will get player data from firebase
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
            
            let player = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: UIImage(named: "Default"), position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String, playerId: pidSnap.value as! String, teamId: self.tid)
            
            
            self.currentPath = IndexPath(row:self.players.count, section: 0)
            
            self.players.append(player)
            
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [self.currentPath], with: .automatic)
            self.tableView.endUpdates()
            
         }
      })
   }
   
   // Checks the player is one of the users
   func playerIsUsers(_ pid:String) -> Bool{
      var isUsers = false
      
      let playerId = pid.prefix(28)
      isUsers = playerId == uid
      
      return isUsers
   }
   
   // MARK: Button States
   
   // Sets save button functionality
   func setSaveButton(to on: Bool){
      if (on){
         saveButton.isEnabled = true
         saveButton.tintColor = UIColor.blue
      }else{
         saveButton.isEnabled = false
         saveButton.tintColor = UIColor.clear
      }
   }
   
   // Sets cancel button functionality
   func setCancelButton(to on: Bool){
      if(on){
         cancelButton.isEnabled = true
         cancelButton.tintColor = UIColor.blue
      }else {
         cancelButton.isEnabled = false
         cancelButton.tintColor = UIColor.clear
      }
   }
   
   // Sets edit button functionality
   func setEditButton(to on: Bool){
      if(on){
         editButton.isEnabled = true
      }else{
         editButton.isEnabled = false
      }
   }
   
   // Sets add button functionality
   func setAddButton(to on: Bool){
      if(on){
         addButton.isEnabled = true
      }else{
         addButton.isEnabled = false
      }
   }
   
   // Sets reset button functionality
   func resetButtonState(){
      tableView.allowsSelection = true
      setEditPlayerFields(to: false)
      setAddButton(to: true)
      setEditButton(to: false)
      setSaveButton(to: false)
      setCancelButton(to: false)
   }
   
   // Grabs all stats from the player
   func populateStats(with player: Player){
      
      pointsCell.text = String(player.points)
      twoPoint.text = String(player.fgMade.twoPoint)
      threePoint.text = String(player.fgMade.threePoint)
      oRebound.text = String(player.offRebounds)
      pFouls.text = String(player.personalFoul)
      assistsCell.text = String(player.assists)
      fGoalCell.text = String(player.fgAttempts.twoPoint)
      freeThrowPerc.text = String(player.ftAttempts)
      freeThrowMade.text = String(player.ftMade)
      tFoulCell.text = String(player.techFoul)
      stealsCell.text = String(player.steals)
      dRebound.text = String(player.defRebounds)
      deflectionCell.text = String(player.deflections)
      blockCell.text = String(player.blocks)
      chargeCell.text = String(player.chargesTaken)
      
   }
   
   // MARK: Default fields
   
   // Sets all player stats to 0
   func defaultStats(){
      
      pointsCell.text = String(0)
      twoPoint.text = String(0)
      threePoint.text = String(0)
      oRebound.text = String(0)
      pFouls.text = String(0)
      assistsCell.text = String(0)
      fGoalCell.text = String(0)
      freeThrowPerc.text = String(0)
      freeThrowMade.text = String(0)
      tFoulCell.text = String(0)
      stealsCell.text = String(0)
      dRebound.text = String(0)
      deflectionCell.text = String(0)
      blockCell.text = String(0)
      chargeCell.text = String(0)
      
   }
   
   // Sets all player fields to default
   func defaultAllFields(){
      playerFirstNameText.text = nil
      playerLastNameText.text = nil
      playerHeightText.text = nil
      playerWeightText.text = nil
      playerClassText.text = nil
      playerImage.image = UIImage(named: "Default")
      playerPositionText.text = nil
      
      defaultStats()
   }
   
   // Display players info
   func grabPlayerFields(){
      playerFirstNameText.text = players[currentPath.row].firstName
      playerLastNameText.text =  players[currentPath.row].lastName
      playerHeightText.text = players[currentPath.row].height
      playerWeightText.text = players[currentPath.row].weight
      playerClassText.text = players[currentPath.row].rank
      playerPositionText.text = players[currentPath.row].position
   }
   
   // Set an edited players fields
   func setOldPlayerFields(){
      players[currentPath.row].firstName = playerFirstNameText.text ?? "First"
      players[currentPath.row].lastName = playerLastNameText.text ?? "Last"
      players[currentPath.row].height = playerHeightText.text ?? "Height"
      players[currentPath.row].weight = playerWeightText.text ?? "Weight"
      players[currentPath.row].rank = playerClassText.text ?? "Class"
      players[currentPath.row].position = playerPositionText.text ?? "Position"
      players[currentPath.row].photo = playerImage.image ?? UIImage(named: "Default")
      
      tableView.reloadRows(at: [currentPath], with: .none)
      let ref = Database.database().reference(withPath: "players")
      
      let playerRef = ref.child(players[currentPath.row].playerId)
      let playerData : [String: Any] = ["fname": players[currentPath.row].firstName,
                                        "lname": players[currentPath.row].lastName,
                                        "height": players[currentPath.row].height,
                                        "weight": players[currentPath.row].weight,
                                        "rank": players[currentPath.row].rank,
                                        "position": players[currentPath.row].position]
      playerRef.updateChildValues(playerData)
   }
   
   // Creates a new player and stores their info in firebase
   func createNewPlayer(){
      
      var firstName = playerFirstNameText.text ?? "First"
      firstName = firstName == "" ? "First":firstName
      var lastName = playerLastNameText.text ?? "Last"
      lastName = lastName == "" ? "Last":lastName
      var height = playerHeightText.text ?? "Height"
      height = height == "" ? "Height":height
      var weight = playerWeightText.text ?? "Weight"
      weight = weight == "" ? "Weight":weight
      var rank = playerClassText.text ?? "Class"
      rank = rank == "" ? "Class":rank
      //let photo = UIImage(named: "Default")
      var position = playerPositionText.text ?? "Position"
      position = position == "" ? "Position":position
      var pid = ""
      if(recentlyDeleted){
         pid = uid + "-" + String(deletedPlayerNum)
         recentlyDeleted = false
      }else{
         pid = uid + "-" + String(players.count)
      }
    
    let p = Player(firstName: firstName, lastName: lastName, photo: nil, position: position, height: height, weight: weight, rank: rank, playerId: pid, teamId: tid)
    
      let ref = Database.database().reference(withPath: "players")

      let playerRef = ref.child(pid)
      let playerData : [String: Any] = ["pid":  pid,
                                        "tid": tid,
                                       "fname": firstName,
                                       "lname": lastName,
                                       "photo": "",
                                       "height": height,
                                       "weight": weight,
                                       "rank": rank,
                                       "position": position,
                                       "points": 0,
                                       "assists": 0,
                                       "turnovers": 0,
                                       "fgAttempts": ["threePoint": 0, "twoPoint": 0, "total": 0],
                                       "fgMade": ["threePoint": 0, "twoPoint": 0, "total": 0],
                                       "offRebounds": 0,
                                       "defRebounds": 0,
                                       "ftAttempts": 0,
                                       "ftMade": 0,
                                       "steals": 0,
                                       "deflections": 0,
                                       "blocks": 0,
                                       "personalFoul": 0,
                                       "chargesTaken": 0,
                                       "techFoul": 0]
      playerRef.setValue(playerData)
        addPlayerToTeam(data: playerData, tid: tid)
   }
    
    func addPlayerToTeam(data: [String:Any], tid: String){
        let firebaseRef = Database.database().reference(withPath: "teams")
        let teamRosterRef = firebaseRef.child(tid).child("roster")
        teamRosterRef.child(data["pid"] as! String).setValue(data)
    }
   
   // Creates the position picker
   func createPositionPicker(){
      let positionPicker = UIPickerView()
      positionPicker.delegate = self
      playerPositionText.inputView = positionPicker
      positionPicker.tag = 0
   }
   
   // Creates the height picker
   func createHeightPicker(){
      let heightPicker = UIPickerView()
      heightPicker.delegate = self
      playerHeightText.inputView = heightPicker
      heightPicker.tag = 1
   }
   
   // Creates the class picker
   func createClassPicker(){
      let classPicker = UIPickerView()
      classPicker.delegate = self
      playerClassText.inputView = classPicker
      classPicker.tag = 2
   }
   
   // Creates the toolbar for the pickers
   func createToolbar(){
      let toolbar = UIToolbar()
      toolbar.sizeToFit()
      let doneButton = UIBarButtonItem(title:"Done", style: .done, target: self, action: #selector(PlayerManagerViewController.dismissKeyboard))

      toolbar.setItems([doneButton], animated: false)
      toolbar.isUserInteractionEnabled = true
      
      playerPositionText.inputAccessoryView = toolbar
      playerHeightText.inputAccessoryView = toolbar
      playerClassText.inputAccessoryView = toolbar
   }
   
   // Dismisses keyboard
   @objc func dismissKeyboard(){
      view.endEditing(true)
   }
   
   @IBAction func setKPI(_ sender: Any) {
      //create alert controller which will display KPI inputs
      let alertController = UIAlertController(title: "Set Player KPI", message: "", preferredStyle: .alert)
      //add 4 text fields to the alert controller, each to take input of a specific KPI
      
      let ref = Database.database().reference(withPath: "kpis")
      let pid = self.uid + "-\(self.tableView.indexPathForSelectedRow![1])"
      let id = "\(pid)-kpi"
      let kpiRef = ref.child(id)
      var fg = ""
      var ft = ""
      var rb = ""
      var to = ""
      kpiRef.observeSingleEvent(of: .value, with: { (snapshot) in
         let kpi = snapshot.value as? NSDictionary
         fg = kpi?["targetFG"] as? String ?? ""
         ft = kpi?["targetFT"] as? String ?? ""
         rb = kpi?["targetRB"] as? String ?? ""
         to = kpi?["targetTO"] as? String ?? ""
      }) { (error) in
         print(error.localizedDescription)
      }
      
      alertController.addTextField{ (textFieldFT : UITextField!) -> Void in
         textFieldFT.placeholder = "Target FT%"
         textFieldFT.text = ft
      }
      alertController.addTextField{ (textFieldFG : UITextField!) -> Void in
         textFieldFG.placeholder = "Target FG%"
         textFieldFG.text = fg
      }
      alertController.addTextField{ (textFieldRB : UITextField!) -> Void in
         textFieldRB.placeholder = "Target No. RB"
         textFieldRB.text = rb
      }
      alertController.addTextField{ (textFieldTO : UITextField!) -> Void in
         textFieldTO.placeholder = "Target Max No. TO"
         textFieldTO.text = to
      }
      //create save action and add the button to the alert controller
      let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
         //get pointers to all 4 text fields in the alert controller window
         let textFT = alertController.textFields![0] as UITextField
         let textFG = alertController.textFields![1] as UITextField
         let textRB = alertController.textFields![2] as UITextField
         let textTO = alertController.textFields![3] as UITextField
         //create a dictionary of all 4 fields and their values (values are pulled from the text properties of the text field pointers
         let kpiData : [String: Any] = ["targetFT":  textFT.text!,
                                        "targetFG":  textFG.text!,
                                        "targetRB":  textRB.text!,
                                        "targetTO":  textTO.text!]
         kpiRef.setValue(kpiData)
         
         //TODO: change text color of fields according to new KPI values
         
      })
      alertController.addAction(saveAction)
      //create cancel action and add the button to the alert controller
      let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
      alertController.addAction(cancelAction)
      //present the alert controller
      self.present(alertController, animated: true, completion: nil)
   }
   
   // MARK: UIPickerViewDelegate
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      var nameCount = 0
      switch pickerView.tag {
      case 0:
         nameCount = positionNames.count
         break
      case 1:
         nameCount = heights.count
         break
      case 2:
         nameCount = ranks.count
         break
      default:
         break
      }
      return nameCount
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      var rowName = ""
      
      switch pickerView.tag {
      case 0:
         rowName = positionNames[row]
         break
      case 1:
         rowName = heights[row]
         break
      case 2:
         rowName = ranks[row]
         break
      default:
         break
      }
      
      return rowName
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch pickerView.tag {
      case 0:
         selectedPosition = positionNames[row]
         playerPositionText.text = selectedPosition
         break
      case 1:
         selectedHeight = heights[row]
         playerHeightText.text = selectedHeight
         break
      case 2:
         selectedRank = ranks[row]
         playerClassText.text = selectedRank
         break
      default:
         break
      }

   }
   
   // MARK: UITableViewDelegate
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      playerImage.image = players[indexPath.row].photo
      playerFirstNameText.text = players[indexPath.row].firstName
      playerLastNameText.text = players[indexPath.row].lastName
      playerHeightText.text = players[indexPath.row].height
      playerWeightText.text = players[indexPath.row].weight
      playerClassText.text = players[indexPath.row].rank
      playerPositionText.text = players[indexPath.row].position
      
      populateStats(with: players[indexPath.row])
      
      currentPath = indexPath
      setEditButton(to: true)
      
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return players.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let playerCell = "PlayerCell"
      // grab the cell from the table view
      guard let cell = tableView.dequeueReusableCell(withIdentifier: playerCell, for: indexPath)as? PlayerTableViewCell
         else{
            fatalError("Dequeued cell was not of type PlayerTableViewCell")
      }
      
      // get the player name from the array
      cell.nameLabel.text = players[indexPath.row].firstName + " " + players[indexPath.row].lastName
      cell.photoImageView.image = players[indexPath.row].photo
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete{
         let pid = players[indexPath.row].playerId
         deletedPlayerNum = indexPath.row
         players.remove(at: indexPath.row)
         tableView.deleteRows(at: [indexPath], with: .fade)
         defaultAllFields()
         let ref = Database.database().reference(withPath: "players")
         ref.child(pid).removeValue()
         recentlyDeleted = true
      }
   }
   
   // MARK: UIImagePickerDelegate
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
      resetButtonState()
   }
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
      guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
         fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
      }
      
      playerImage.image = selectedImage
      
      dismiss(animated: true, completion: nil)
      
      tableView.allowsSelection = false
      setEditPlayerFields(to: true)
      setAddButton(to: false)
      setEditButton(to: false)
      setSaveButton(to: true)
      setCancelButton(to: true)
      
   }
   
   // MARK: ButtonActions
   
   @IBAction func editPlayerInfo(_ sender: Any) {
      
      setEditPlayerFields(to: true)
      setSaveButton(to: true)
      setCancelButton(to: true)
      setAddButton(to: false)
      setEditButton(to: false)
      tableView.allowsSelection = false
      
      
      playerFirstNameText.becomeFirstResponder()
      
      
   }
   
   @IBAction func addPlayer(_ sender: Any) {
      
      // disable all other functions of the user until save or cancel button is clicked
      tableView.allowsSelection = false
      setEditPlayerFields(to: true)
      setAddButton(to: false)
      setEditButton(to: false)
      setSaveButton(to: true)
      setCancelButton(to: true)
      tableView.deselectRow(at: currentPath, animated: false)
      
      // reset current index path
      currentPath = IndexPath()
      
      playerFirstNameText.text = nil
      playerLastNameText.text = nil
      playerHeightText.text = nil
      playerWeightText.text = nil
      playerClassText.text = nil
      playerPositionText.text = nil
      playerImage.image = UIImage(named: "Default")
      playerFirstNameText.becomeFirstResponder()
      
   }
   @IBAction func cancelManage(_ sender: Any) {
      resetButtonState()
      
      if(currentPath.isEmpty){
         defaultAllFields()
      }else{
         grabPlayerFields()
      }
   }
   
   @IBAction func savePlayer(_ sender: Any) {
      
      if(currentPath.isEmpty){
         createNewPlayer()
      }else{
         setOldPlayerFields()
      }
      resetButtonState()
   }

   @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
      playerPositionText.resignFirstResponder()
      
      let imagePickerController = UIImagePickerController()
      
      imagePickerController.delegate = self
      
      let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
      
      actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
         if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true)
         }else{
            print("No available camera")
         }
         
      }))
      
      actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
         imagePickerController.sourceType = .photoLibrary
         imagePickerController.allowsEditing = false
         self.present(imagePickerController, animated: true)
      }))
      
      actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
      
      if let popoverController = actionSheet.popoverPresentationController {
         popoverController.sourceView = self.view
         popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
         popoverController.permittedArrowDirections = []
      }
      
      self.present(actionSheet, animated: true, completion: nil)
      
      
      
   }
   
   @IBAction func cancel(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}

