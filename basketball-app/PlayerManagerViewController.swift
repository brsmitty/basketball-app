//
//  PlayerManagerViewController.swift
//  basketball-app
//
//  Created by Mike White on 9/10/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class PlayerManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

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
   
   var currentPath = IndexPath()
   
   // setup an array that holds all the players
   var players:[Player] = [Player]()
   var myIndex = 0
   
   let positionNames:[String] = [String] (arrayLiteral: "Point-Guard", "Shooting-Guard", "Small-Forward", "Center", "Power-Forward")
   let cellNames:[String] = [String] (arrayLiteral: "points","assists","steals","2pg","fg","drebound","3pg","ft%","deflections","orebound","ftmade","blocks","pfoul","tfoul","charge")
   
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
      // load all the players from firebase
      self.players = PlayerModel().getPlayers()
      setEditPlayerFields(to: false)
      setSaveButton(to: false)
      setCancelButton(to: false)
      setEditButton(to: false)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      // Store the new players in firebase
   }
   
   func setEditPlayerFields(to edit: Bool){
      playerPositionText.isUserInteractionEnabled = edit
      playerFirstNameText.isUserInteractionEnabled = edit
      playerLastNameText.isUserInteractionEnabled = edit
      playerHeightText.isUserInteractionEnabled = edit
      playerWeightText.isUserInteractionEnabled = edit
      playerClassText.isUserInteractionEnabled = edit
   }
   
   func setSaveButton(to on: Bool){
      if (on){
         saveButton.isEnabled = true
         saveButton.tintColor = UIColor.blue
      }else{
         saveButton.isEnabled = false
         saveButton.tintColor = UIColor.clear
      }
   }
   
   func setCancelButton(to on: Bool){
      if(on){
         cancelButton.isEnabled = true
         cancelButton.tintColor = UIColor.blue
      }else {
         cancelButton.isEnabled = false
         cancelButton.tintColor = UIColor.clear
      }
   }
   
   func setEditButton(to on: Bool){
      if(on){
         editButton.isEnabled = true
      }else{
         editButton.isEnabled = false
      }
   }
   
   func setAddButton(to on: Bool){
      if(on){
         addButton.isEnabled = true
      }else{
         addButton.isEnabled = false
      }
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func populateStats(with player: Player){
      
      pointsCell.text = String(player.points)
      twoPoint.text = String(player.fgMade.twoPoint)
      threePoint.text = String(player.fgMade.threePoint)
      oRebound.text = String(player.offRebounds)
      pFouls.text = String(player.personalFoul)
      assistsCell.text = String(player.assists)
      fGoalCell.text = String(player.fgAttempts)
      freeThrowPerc.text = String(player.ftAttempts)
      freeThrowMade.text = String(player.ftMade)
      tFoulCell.text = String(player.techFoul)
      stealsCell.text = String(player.steals)
      dRebound.text = String(player.defRebounds)
      deflectionCell.text = String(player.deflections)
      blockCell.text = String(player.blocks)
      chargeCell.text = String(player.chagesTaken)
      
   }
   
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
   
   func defaultAllFields(){
      playerFirstNameText.text = "First"
      playerLastNameText.text = "Last"
      playerHeightText.text = "Height"
      playerWeightText.text = "Weight"
      playerClassText.text = "Rank"
      playerImage.image = UIImage(named: "Default")
      playerPositionText.text = "Position"
      
      defaultStats()
   }
   
   func grabPlayerFields(){
      playerFirstNameText.text = players[currentPath.row].firstName
      playerLastNameText.text =  players[currentPath.row].lastName
      playerHeightText.text = players[currentPath.row].height
      playerWeightText.text = players[currentPath.row].weight
      playerClassText.text = players[currentPath.row].rank
      playerPositionText.text = players[currentPath.row].position
   }
   
   func setOldPlayerFields(){
      players[currentPath.row].firstName = playerFirstNameText.text ?? "First"
      players[currentPath.row].lastName = playerLastNameText.text ?? "Last"
      players[currentPath.row].height = playerHeightText.text ?? "Height"
      players[currentPath.row].weight = playerWeightText.text ?? "Weight"
      players[currentPath.row].rank = playerClassText.text ?? "Rank"
      players[currentPath.row].rank = playerPositionText.text ?? "Position"
      
      tableView.reloadRows(at: [currentPath], with: .none)
   }
   
   func createNewPlayer(){
      let firstName = playerFirstNameText.text ?? "First"
      let lastName = playerLastNameText.text ?? "Last"
      let height = playerHeightText.text ?? "Height"
      let weight = playerWeightText.text ?? "Weight"
      let rank = playerClassText.text ?? "Rank"
      let photo = UIImage(named: "Default")
      let position = playerPositionText.text ?? "Position"
      
      guard let newPlayer = Player(firstName: firstName, lastName: lastName, photo: photo, position: position, height: height, weight: weight, rank: rank)
         else{
            fatalError("Creating new player Failed")
      }
      
      currentPath = IndexPath(row:players.count, section: 0)
      
      players.append(newPlayer)
      
      tableView.beginUpdates()
      tableView.insertRows(at: [currentPath], with: .automatic)
      tableView.endUpdates()
   }
   
   func createPositionPicker(){
      let positionPicker = UIPickerView()
      positionPicker.delegate = self
      playerPositionText.inputView = positionPicker
   }
   
   // MARK: UIPickerViewDelegate
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return positionNames.count
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return positionNames[row]
   }
   
   // MARK: UITableViewDelegate
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      playerImage.image = players[indexPath.row].photo
      playerFirstNameText.text = players[indexPath.row].firstName
      playerLastNameText.text = players[indexPath.row].lastName
      playerHeightText.text = players[indexPath.row].height
      playerWeightText.text = players[indexPath.row].weight
      playerClassText.text = players[indexPath.row].rank
      //playerPositionText.text = players[indexPath.row].position
      
      populateStats(with: players[indexPath.row])
      
      currentPath = indexPath
      setEditButton(to: true)
      
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
         players.remove(at: indexPath.row)
         tableView.deleteRows(at: [indexPath], with: .fade)
         defaultAllFields()
      }
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
      
      playerFirstNameText.text = "First"
      playerLastNameText.text = "Last"
      playerHeightText.text = "Height"
      playerWeightText.text = "Weight"
      playerClassText.text = "Rank"
      playerImage.image = UIImage(named: "Default")
      playerFirstNameText.becomeFirstResponder()
      
   }
   @IBAction func cancelManage(_ sender: Any) {
      tableView.allowsSelection = true
      setEditPlayerFields(to: false)
      setAddButton(to: true)
      setEditButton(to: true)
      setSaveButton(to: false)
      setCancelButton(to: false)
      
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
      tableView.allowsSelection = true
      setEditPlayerFields(to: false)
      setAddButton(to: true)
      setEditButton(to: true)
      setSaveButton(to: false)
      setCancelButton(to: false)
   }
   
}

