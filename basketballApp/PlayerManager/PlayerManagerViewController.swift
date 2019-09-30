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

class PlayerManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
   // MARK: Properties
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var playerImage: UIImageView!
   
    var playerImageURL: String = ""
   
   @IBOutlet weak var playerPositionText: UITextField!
   @IBOutlet weak var playerFirstNameText: UITextField!
   @IBOutlet weak var playerLastNameText: UITextField!
   @IBOutlet weak var playerHeightText: UITextField!
   @IBOutlet weak var playerWeightText: UITextField!
   @IBOutlet weak var playerClassText: UITextField!
   
   @IBOutlet weak var saveButton: UIButton!
   @IBOutlet weak var editButton: UIButton!
   @IBOutlet weak var addButton: UIButton!
   @IBOutlet weak var cancelButton: UIButton!
   
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
   @IBOutlet weak var backButton: UIButton!
   @IBOutlet var poundsLabel: UILabel!
   
   @IBOutlet var gameTimeButton: UIButton!
   @IBOutlet var mainMenuButton: UIButton!
   @IBOutlet var performanceButton: UIButton!
   @IBOutlet var scheduleButton: UIButton!
   @IBOutlet var playbookButton: UIButton!
   @IBOutlet var kpiButton: UIButton!
   
   
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
   let positionPicker = UIPickerView()
   let heightPicker = UIPickerView()
   let classPicker = UIPickerView()
   let imagePickerController = UIImagePickerController()
   
   //var playerImageURL = NSURL.init()
   
   var count: Int = 0
   var counts: [Int] = [Int]()
   
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
      
      tableView.layer.borderWidth = 2
      tableView.layer.borderColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:0.2).cgColor
      tableView.layer.cornerRadius = 5
      
      playerWeightText.delegate = self
      playerWeightText.tag = 14
      playerClassText.delegate = self
      playerClassText.tag = 4
      playerHeightText.delegate = self
      playerHeightText.tag = 3
      playerPositionText.delegate = self
      playerPositionText.tag = 2
      
      imagePickerController.delegate = self
      
      playerPositionText.layer.cornerRadius = 5
      playerFirstNameText.layer.cornerRadius = 5
      playerLastNameText.layer.cornerRadius = 5
      playerHeightText.layer.cornerRadius = 5
      playerWeightText.layer.cornerRadius = 5
      playerClassText.layer.cornerRadius = 5
      
      let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
      tap.cancelsTouchesInView = false
      self.view.addGestureRecognizer(tap)
      addButton.layer.cornerRadius = 5
      saveButton.layer.cornerRadius = 5
      editButton.layer.cornerRadius = 5
      cancelButton.layer.cornerRadius = 5
      
      playerImage.layer.masksToBounds = false
      playerImage.layer.cornerRadius = playerImage.frame.size.width/2
      playerImage.clipsToBounds = true
      
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
      
      if counts.count > 0{
         self.count = self.counts[self.counts.count - 1] + 1
      }
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
   func getPlayers() {
    DBApi.sharedInstance.getPlayers { [weak self] players in
        guard let s = self else { return }
        s.players = players
        s.tableView.reloadData()
    }
    print("hhhh")
    print(players.count)
//
//      // Set up the references
//      playerRef = Database.database().reference()
//      databaseHandle = playerRef?.child("players").observe(.childAdded, with: { (snapshot) in
//
//         // If the player is one of the users players add it to the table
//         if(self.playerIsUsers(snapshot.key)){
//            // take data from the snapshot and add a player object
//            let fnameSnap = snapshot.childSnapshot(forPath: "fname")
//            let lnameSnap = snapshot.childSnapshot(forPath: "lname")
//            let heightSnap = snapshot.childSnapshot(forPath: "height")
//            let weightSnap = snapshot.childSnapshot(forPath: "weight")
//            let positionSnap = snapshot.childSnapshot(forPath: "position")
//            let rankSnap = snapshot.childSnapshot(forPath: "rank")
//            let pidSnap = snapshot.childSnapshot(forPath: "pid")
//            //let imagePath = snapshot.childSnapshot(forPath: "photo").value as! String
//
//            let fname = (fnameSnap.value as! String).replacingOccurrences(of: "_", with: " ")
//            let lname = (lnameSnap.value as! String).replacingOccurrences(of: "_", with: " ")
//            let imageName = fname + lname + "image"
//            let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
//            let imageURL: URL = URL(fileURLWithPath: imagePath)
//
//
//            guard FileManager.default.fileExists(atPath: imagePath),
//               let imageData: Data = try? Data(contentsOf: imageURL),
//               let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) else {
//                  return
//            }
//
//            let player = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: image, position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String, playerId: pidSnap.value as! String, teamId: self.tid)
//
//            let help = String(snapshot.key.suffix(snapshot.key.count - 29))
//            if(!self.counts.contains(Int(help)!)){
//
//               self.count = Int(help.prefix(help.count))!
//               self.counts.append(self.count)
//               self.count = self.count+1
//
//               self.insertPlayerInTableView(player)
//            }
//
//         }
//      })
   }
   //UNUSED
   func insertPlayerInTableView(_ player: Player){
      
      self.currentPath = IndexPath(row:self.players.count, section: 0)
      
      self.players.append(player)
      
      
      self.tableView.beginUpdates()
      self.tableView.insertRows(at: [self.currentPath], with: .automatic)
      self.tableView.endUpdates()
   }
   
    //UNUSED
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
         saveButton.isHidden = false

      }else{
         saveButton.isEnabled = false
         saveButton.isHidden = true
      }
   }
   
   // Sets cancel button functionality
   func setCancelButton(to on: Bool){
      if(on){
         cancelButton.isEnabled = true
         cancelButton.isHidden = false
      }else {
         cancelButton.isEnabled = false
         cancelButton.isHidden = true
      }
   }
   
   // Sets edit button functionality
   func setEditButton(to on: Bool){
      if(on){
         editButton.isEnabled = true
         editButton.isHidden = false
      }else{
         editButton.isEnabled = false
         editButton.isHidden = true
      }
   }
   
   // Sets add button functionality
   func setAddButton(to on: Bool){
      if(on){
         addButton.isEnabled = true
         addButton.isHidden = false
      }else{
         addButton.isEnabled = false
         addButton.isHidden = true
      }
   }
   
   func setBackButton(to on: Bool){
      if(on){
         backButton.isEnabled = true
         backButton.isHidden = false
      }else{
         backButton.isEnabled = false
         backButton.isHidden = true
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
      setBackButton(to: true)
   }
   
   // Grabs all stats from the player
   func populateStats(with player: Player){
      
      pointsCell.text = String(player.points ?? 0)
      twoPoint.text = String(player.twoPtMade ?? 0)
      threePoint.text = String(player.threePtMade ?? 0)
      oRebound.text = String(player.offRebounds ?? 0)
      pFouls.text = String(player.personalFoul ?? 0)
      assistsCell.text = String(player.assists ?? 0)
      fGoalCell.text = String(player.twoPtAtt ?? 0)
      freeThrowPerc.text = String(player.ftAtt ?? 0)
      freeThrowMade.text = String(player.ftMade ?? 0)
      tFoulCell.text = String(player.techFoul ?? 0)
      stealsCell.text = String(player.steals ?? 0)
      dRebound.text = String(player.defRebounds ?? 0)
      deflectionCell.text = String(player.deflections ?? 0)
      blockCell.text = String(player.blocks ?? 0)
      chargeCell.text = String(player.chargesTaken ?? 0)
      
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
    let ref = Database.database().reference(withPath: "users/\(uid)/players")
    
    let imageName = players[currentPath.row].firstName + players[currentPath.row].lastName + "image"
    let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
    let imageURL: URL = URL(fileURLWithPath: imagePath)
    
    // Store the image
    try? UIImagePNGRepresentation(players[currentPath.row].photo!)?.write(to: imageURL)
    
    let playerRef = ref.child(players[currentPath.row].playerId)
    let playerData : [String: Any] = ["user_id": uid,
                                      "fName": players[currentPath.row].firstName,
                                      "lName": players[currentPath.row].lastName,
                                      "height": players[currentPath.row].height,
                                      "weight": players[currentPath.row].weight,
                                      "rank": players[currentPath.row].rank,
                                      "position": players[currentPath.row].position,
                                      "image_name": imageName]
    playerRef.updateChildValues(playerData)
   }
   
   // Stores a new player's info in firebase
   func createNewPlayer(){
      
      var firstName = playerFirstNameText.text ?? "First"
      var lastName = playerLastNameText.text ?? "Last"
      let height = playerHeightText.text ?? "Height"
      let weight = playerWeightText.text ?? "Weight"
      let rank = playerClassText.text ?? "Class"
      let position = playerPositionText.text ?? "Position"
    
      firstName = firstName.replacingOccurrences(of: " ", with: "_")
      lastName = lastName.replacingOccurrences(of: " ", with: "_")
      let imageName = firstName + lastName + "image"
      let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
      let imageURL: URL = URL(fileURLWithPath: imagePath)
      
      // Store the image
      try? UIImagePNGRepresentation(playerImage.image!)?.write(to: imageURL)
    
//      let pid = uid + "-" + String(count)
//
//
//      let ref = Database.database().reference(withPath: "players")
//
//      let playerRef = ref.child(pid)
      let playerData : [String: Any] = ["fname": firstName,
                                       "lname": lastName,
                                       "height": height,
                                       "weight": weight,
                                       "rank": rank,
                                       "position": position,
                                       "image_name": imageName]
    
    DBApi.sharedInstance.createPlayer(info: playerData) { [weak self] in
        guard let s = self else { return }
        s.getPlayers()
    }
    
//      playerRef.setValue(playerData)
//        addPlayerToTeam(data: playerData, tid: tid)
   }
    //UNUSED, DATACOLLECTION
    func addPlayerToTeam(data: [String:Any], tid: String){
        let firebaseRef = Database.database().reference(withPath: "teams")
        let teamRosterRef = firebaseRef.child(tid).child("roster")
        teamRosterRef.child(data["pid"] as! String).setValue(data)
    }
   
   // Creates the position picker
   func createPositionPicker(){
      positionPicker.delegate = self
      playerPositionText.inputView = positionPicker
      positionPicker.tag = 0
   }
   
   // Creates the height picker
   func createHeightPicker(){
      heightPicker.delegate = self
      playerHeightText.inputView = heightPicker
      heightPicker.tag = 1
   }
   
   // Creates the class picker
   func createClassPicker(){
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
      
      resetButtonState()
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
      print("here")
      print(players.count)
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
            let pid = removePlayer(indexPath, tableView)
            var ref = Database.database().reference(withPath: "users/\(uid)/players")
            ref.child(pid).removeValue()
            resetButtonState()
        }
    }
   
   func removePlayer(_ indexPath:IndexPath, _ tableView:UITableView) -> String{
      let pid = players[indexPath.row].playerId
      players.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      defaultAllFields()
      return pid
   }
   
   // MARK: UIImagePickerDelegate
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion:{
         self.tableView.allowsSelection = true
         self.setEditPlayerFields(to: true)
         self.setAddButton(to: false)
         self.setEditButton(to: false)
         self.setSaveButton(to: true)
         self.setCancelButton(to: true)
         
      })
   }
   
   func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
      
      let cgimage = image.cgImage!
      let contextImage: UIImage = UIImage(cgImage: cgimage)
      let contextSize: CGSize = contextImage.size
      var posX: CGFloat = 0.0
      var posY: CGFloat = 0.0
      var cgwidth: CGFloat = CGFloat(width)
      var cgheight: CGFloat = CGFloat(height)
      
      // See what size is longer and create the center off of that
      if contextSize.width > contextSize.height {
         posX = ((contextSize.width - contextSize.height) / 2)
         posY = 0
         cgwidth = contextSize.height
         cgheight = contextSize.height
      } else {
         posX = 0
         posY = ((contextSize.height - contextSize.width) / 2)
         cgwidth = contextSize.width
         cgheight = contextSize.width
      }
      
      let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
      
      // Create bitmap image from context using the rect
      let imageRef: CGImage = cgimage.cropping(to: rect)!
      
      // Create a new image based on the imageRef and rotate back to the original orientation
      let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
      
      return image
   }
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    

      if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
         playerImage.image = cropToBounds(image: editedImage, width: 180, height: 180)
      }
      else if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
         playerImage.image = cropToBounds(image: selectedImage, width: 180, height: 180)
      }
      
      
      dismiss(animated: true, completion: {
         self.tableView.allowsSelection = false
         self.setEditPlayerFields(to: true)
         self.setAddButton(to: false)
         self.setEditButton(to: false)
         self.setSaveButton(to: true)
         self.setCancelButton(to: true)
      })
      
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
      setEditPlayerFields(to: true)
      setAddButton(to: false)
      setEditButton(to: false)
      setSaveButton(to: true)
      setCancelButton(to: true)
      setBackButton(to: false)
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
      view.endEditing(true)
      
      let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
      
      actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
         if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.allowsEditing = true
            self.present(self.imagePickerController, animated: true)
         }else{
            print("No available camera")
         }
         
      }))
      
      actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
         self.imagePickerController.sourceType = .photoLibrary
         self.imagePickerController.allowsEditing = true
         self.present(self.imagePickerController, animated: true)
      }))
      
      actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
      
      if let popoverController = actionSheet.popoverPresentationController {
         popoverController.sourceView = self.view
         popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
         popoverController.permittedArrowDirections = []
      }
      
      self.present(actionSheet, animated: true, completion: nil)
      
   }
   
   // MARK: TextFieldDelegate
   
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      if(textField.tag == 14){
         let maxLength = 3
         let currentString: NSString = textField.text! as NSString
         let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
         let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789").inverted
         let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
         
         return newString.length <= maxLength && replacementStringIsLegal
      }
      return false
   }

   func textFieldDidBeginEditing(_ textField: UITextField) {
      let text = textField.text
      var pos = 0
      if(textField.tag == 2){
         if(!(text?.isEmpty)!){
            pos = positionNames.firstIndex(of: text!)!
         }
         positionPicker.selectRow(pos, inComponent: 0, animated: false)
         textField.text = positionNames[pos]
         
      }else if(textField.tag == 3){
         if(!(text?.isEmpty)!){
            pos = heights.firstIndex(of: text!)!
         }
         heightPicker.selectRow(pos, inComponent: 0, animated: false)
         textField.text = heights[pos]
      }else if(textField.tag == 4){
         if(!(text?.isEmpty)!){
            pos = ranks.firstIndex(of: text!)!
         }
         classPicker.selectRow(pos, inComponent: 0, animated: false)
         textField.text = ranks[pos]
      }
   }
   
   @IBAction func goBack(_ sender: UIButton) {
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
            if let dest = segue.destination as? kpiViewController {
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

