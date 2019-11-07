//
//  LineupManagerViewController.swift
//  
//
//  Created by Mike White on 9/21/18.
//
// What in the world?
// MARK: WHOLE CLASS NEVER USED

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import os.log

class LineupManagerViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

   // MARK: Properties
   @IBOutlet weak var tableView: UITableView!
   
   var lineups = [[Player]]()
   var names = [String]()
   // holds the lineupe reference to firebase
   var lineupRef:DatabaseReference?
   // holds the player reference to firebase
   var playerRef: DatabaseReference?
   // holds the database reference to firebase
   var databaseHandlePlayer:DatabaseHandle?
   // holds the database reference to firebase
   var databaseHandleLineup:DatabaseHandle?
   // holds the users unique user ID
    var uid: String = ""
    var tid: String = ""
   // Holds the path to the current row highlighed in the table view
   var currentPath = IndexPath()
   var lineup: [Player] = [Player]()
   var positionSlot:[String] = [String]()
   var allSlots = [[String]]()
   var count: Int = 0
   var counts: [Int] = [Int]()
   
   var playerOneID: String?
   var playerTwoID: String?
   var playerThreeID: String?
   var playerFourID: String?
   var playerFiveID: String?
   
   var playerOne: Player?
   var playerTwo: Player?
   var playerThree: Player?
   var playerFour: Player?
   var playerFive: Player?
   
   @IBOutlet weak var addLineupButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.tableView.delegate = self
      self.tableView.dataSource = self
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
      self.navigationController?.setNavigationBarHidden(false, animated: false)
      getLineups()
      
      addLineupButton.layer.cornerRadius = 5
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      playerRef?.removeObserver(withHandle: databaseHandlePlayer!)
      lineupRef?.removeObserver(withHandle: databaseHandleLineup!)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - TableViewDelegate
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return lineups.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cellIdentifier = "LineupViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LineupTableViewCell else{
         fatalError("The Dequeued cell was not of instance LineupTableViewCell")
      }
      let lineup = lineups[indexPath.row]
      
    print("print tableView")
      cell.playerOneName.text = lineup[0].firstName + " " + lineup[0].lastName
      cell.playerOneImage.image = lineup[0].photo
      cell.playerTwoName.text = lineup[1].firstName + " " + lineup[1].lastName
      cell.playerTwoImage.image = lineup[1].photo
      cell.playerThreeName.text = lineup[2].firstName + " " + lineup[2].lastName
      cell.playerThreeImage.image = lineup[2].photo
      cell.playerFourName.text = lineup[3].firstName + " " + lineup[3].lastName
      cell.playerFourImage.image = lineup[3].photo
      cell.playerFiveName.text = lineup[4].firstName + " " + lineup[4].lastName
      cell.playerFiveImage.image = lineup[4].photo
      cell.lineupName.text = names[indexPath.row]
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete{
         let lid = uid + "-" + String(counts[indexPath.row]) + names[indexPath.row]
         counts.remove(at: indexPath.row)
         lineups.remove(at: indexPath.row)
         names.remove(at: indexPath.row)
         tableView.deleteRows(at: [indexPath], with: .fade)
         let ref = Database.database().reference(withPath: "lineups")
         ref.child(lid).removeValue()
      }
    print("print tableView2")
   }
   
   // MARK: Private Methods
   
   // Creates a new lineup and stores their info in firebase
   func getLineups(){
      // Set up the references
        print("LINEUP HERe")
      lineupRef = Database.database().reference()
      databaseHandleLineup = lineupRef?.child("lineups").observe(.childAdded, with: { (snapshot) in
         // If the player is one of the users players add it to the table
         if(self.lineupIsUsers(snapshot.key)){
            let name = String(snapshot.key.suffix(snapshot.key.count - 30))
            let help = String(snapshot.key.suffix(snapshot.key.count - 29))
            self.count = Int(help.prefix(help.count - 1))!
            self.counts.append(self.count)
            self.count = self.count+1
            if(!self.names.contains(name)){
               self.names.append(name)
               // take data from the snapshot and add a player object
               self.playerOneID = (snapshot.childSnapshot(forPath: "playerOne").value as! String)
               self.playerTwoID = (snapshot.childSnapshot(forPath: "playerTwo").value as! String)
               self.playerThreeID = (snapshot.childSnapshot(forPath: "playerThree").value as! String)
               self.playerFourID = (snapshot.childSnapshot(forPath: "playerFour").value as! String)
               self.playerFiveID = (snapshot.childSnapshot(forPath: "playerFive").value as! String)
               let posOne = snapshot.childSnapshot(forPath: self.playerOneID!).value as! String
               self.positionSlot.append(posOne)
               let posTwo = snapshot.childSnapshot(forPath: self.playerTwoID!).value as! String
               self.positionSlot.append(posTwo)
               let posThree = snapshot.childSnapshot(forPath: self.playerThreeID!).value as! String
               self.positionSlot.append(posThree)
               let posFour = snapshot.childSnapshot(forPath: self.playerFourID!).value as! String
               self.positionSlot.append(posFour)
               let posFive = snapshot.childSnapshot(forPath: self.playerFiveID!).value as! String
               self.positionSlot.append(posFive)
               self.allSlots.append(self.positionSlot)
               self.getPlayer()
            }
            print("print lineup")
         }
      })
   }
   
   func getPlayer(){
      playerRef = Database.database().reference()
      databaseHandlePlayer = lineupRef?.child("players").observe(.childAdded, with: {(snapshot) in
         print("getPlayer")
         if(self.playerOneID == snapshot.key){
            let fnameSnap = snapshot.childSnapshot(forPath: "fname")
            let lnameSnap = snapshot.childSnapshot(forPath: "lname")
            let heightSnap = snapshot.childSnapshot(forPath: "height")
            let weightSnap = snapshot.childSnapshot(forPath: "weight")
            let positionSnap = snapshot.childSnapshot(forPath: "position")
            let rankSnap = snapshot.childSnapshot(forPath: "rank")
            let pidSnap = snapshot.childSnapshot(forPath: "pid")
            self.playerOne = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: UIImage(named: "Default"), position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String, playerId: pidSnap.value as! String, teamId: self.tid)
            self.lineup.append(self.playerOne!)
         }
         
         if(self.playerTwoID == snapshot.key){
            let fnameSnap = snapshot.childSnapshot(forPath: "fname")
            let lnameSnap = snapshot.childSnapshot(forPath: "lname")
            let heightSnap = snapshot.childSnapshot(forPath: "height")
            let weightSnap = snapshot.childSnapshot(forPath: "weight")
            let positionSnap = snapshot.childSnapshot(forPath: "position")
            let rankSnap = snapshot.childSnapshot(forPath: "rank")
            let pidSnap = snapshot.childSnapshot(forPath: "pid")
            self.playerTwo = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: UIImage(named: "Default"), position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String, playerId: pidSnap.value as! String, teamId: self.tid)
            self.lineup.append(self.playerTwo!)
         }
         
         if(self.playerThreeID == snapshot.key){
            let fnameSnap = snapshot.childSnapshot(forPath: "fname")
            let lnameSnap = snapshot.childSnapshot(forPath: "lname")
            let heightSnap = snapshot.childSnapshot(forPath: "height")
            let weightSnap = snapshot.childSnapshot(forPath: "weight")
            let positionSnap = snapshot.childSnapshot(forPath: "position")
            let rankSnap = snapshot.childSnapshot(forPath: "rank")
            let pidSnap = snapshot.childSnapshot(forPath: "pid")
            self.playerThree = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: UIImage(named: "Default"), position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String, playerId: pidSnap.value as! String, teamId: self.tid)
            self.lineup.append(self.playerThree!)
         }
         
         if(self.playerFourID == snapshot.key){
            let fnameSnap = snapshot.childSnapshot(forPath: "fname")
            let lnameSnap = snapshot.childSnapshot(forPath: "lname")
            let heightSnap = snapshot.childSnapshot(forPath: "height")
            let weightSnap = snapshot.childSnapshot(forPath: "weight")
            let positionSnap = snapshot.childSnapshot(forPath: "position")
            let rankSnap = snapshot.childSnapshot(forPath: "rank")
            let pidSnap = snapshot.childSnapshot(forPath: "pid")
            self.playerFour = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: UIImage(named: "Default"), position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String, playerId: pidSnap.value as! String, teamId: self.tid)
            self.lineup.append(self.playerFour!)
         }
         
         if(self.playerFiveID == snapshot.key){
            let fnameSnap = snapshot.childSnapshot(forPath: "fname")
            let lnameSnap = snapshot.childSnapshot(forPath: "lname")
            let heightSnap = snapshot.childSnapshot(forPath: "height")
            let weightSnap = snapshot.childSnapshot(forPath: "weight")
            let positionSnap = snapshot.childSnapshot(forPath: "position")
            let rankSnap = snapshot.childSnapshot(forPath: "rank")
            let pidSnap = snapshot.childSnapshot(forPath: "pid")
            self.playerFive = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: UIImage(named: "Default"), position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String, playerId: pidSnap.value as! String, teamId: self.tid)
            self.lineup.append(self.playerFive!)
         }
         if self.lineup.count == 5{
            self.currentPath = IndexPath(row:self.lineups.count, section: 0)
            self.lineups.append(self.lineup)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [self.currentPath], with: .automatic)
            self.tableView.endUpdates()
            self.lineup = [Player]()
         }
      })
   }
   
   func lineupIsUsers(_ lid:String)-> Bool{
      var isUsers = false
      
      let lineupId = lid.prefix(28)
      isUsers = lineupId == uid
      
      return isUsers
   }
   
   // MARK: Actions
   @IBAction func unwindToLineupManager(sender: UIStoryboardSegue){
      if let sourceViewController = sender.source as? LineupEditorViewController, let lineup = sourceViewController.lineup{
         
         if let selectedIndexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: selectedIndexPath, animated: true)
            lineups[selectedIndexPath.row] = lineup
            let lineupName = sourceViewController.nameForLineup
            
            let oldLid = uid + "-" + String(counts[selectedIndexPath.row]) + names[selectedIndexPath.row]
            names[selectedIndexPath.row] = lineupName!
            let positions = sourceViewController.positions
            allSlots[selectedIndexPath.row] = positions!
            let lid = uid + "-" + String(counts[names.firstIndex(of: lineupName!)!]) + lineupName!
            let ref = Database.database().reference(withPath: "lineups")
            ref.child(oldLid).removeValue()
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
            let playerRef = ref.child(lid)
            let playerData : [String: Any] = ["playerOne": lineup[0].playerId,
                                              "playerTwo": lineup[1].playerId,
                                              "playerThree": lineup[2].playerId,
                                              "playerFour": lineup[3].playerId,
                                              "playerFive": lineup[4].playerId,
                                              lineup[0].playerId: positions![0],
                                              lineup[1].playerId: positions![1],
                                              lineup[2].playerId: positions![2],
                                              lineup[3].playerId: positions![3],
                                              lineup[4].playerId: positions![4]]
            playerRef.setValue(playerData)
         }else{
            let lineupName = sourceViewController.nameForLineup
            //names.append(lineupName!)
            //let newIndexPath = IndexPath(row: lineups.count, section: 0)
            //lineups.append(lineup)
            //tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            let positions = sourceViewController.positions
            let lid = uid + "-" + String(count) + lineupName!
            self.count = self.count + 1
            let ref = Database.database().reference(withPath: "lineups")
            
            let playerRef = ref.child(lid)
            let playerData : [String: Any] = ["playerOne": lineup[0].playerId,
                                              "playerTwo": lineup[1].playerId,
                                              "playerThree": lineup[2].playerId,
                                              "playerFour": lineup[3].playerId,
                                              "playerFive": lineup[4].playerId,
                                              lineup[0].playerId: positions![0],
                                              lineup[1].playerId: positions![1],
                                              lineup[2].playerId: positions![2],
                                              lineup[3].playerId: positions![3],
                                              lineup[4].playerId: positions![4]]
            playerRef.setValue(playerData)
         }
        print(" print unwind")
      }
   }
   
   //MARK: - Navigation
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      super.prepare(for: segue, sender: sender)
      
      switch (segue.identifier ?? "") {
      case "AddLineup":
         if let selectedIndexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: selectedIndexPath, animated: true)
         }
         guard let lineupDetailViewController = segue.destination as? LineupEditorViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
         }
         lineupDetailViewController.names = names
         os_log("Adding a lineup.", log: OSLog.default, type: .debug)
      case "ShowDetail":
         guard let lineupDetailViewController = segue.destination as? LineupEditorViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
         }
         
         guard let selectedLineupCell = sender as? LineupTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
         }
         
         guard let indexPath = tableView.indexPath(for: selectedLineupCell) else {
            fatalError("The selected cell is not being displayed by the table")
         }
         
         let selectedLineup = lineups[indexPath.row]
         let positions = allSlots[indexPath.row]
         lineupDetailViewController.positions = positions
         lineupDetailViewController.names = names
         lineupDetailViewController.lineup = selectedLineup
         lineupDetailViewController.nameForLineup = names[indexPath.row]
      default:
         fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
      }
   }

//   @IBAction func cancel(_ sender: UIBarButtonItem) {
//      dismiss(animated: true, completion: nil)
//   }
   
   @IBAction func cancel(_ sender: UIButton) {
      dismiss(animated: false, completion: nil)
   }
   
}
