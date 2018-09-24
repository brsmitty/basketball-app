//
//  LineupManagerViewController.swift
//  
//
//  Created by Mike White on 9/21/18.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

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
   // Holds the path to the current row highlighed in the table view
   var currentPath = IndexPath()
   
   var playerOneID: String?
   var playerTwoID: String?
   var playerThreeID: String?
   var playerFourID: String?
   var playerFiveID: String?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.tableView.delegate = self
      self.tableView.dataSource = self
   }
   
   override func viewWillAppear(_ animated: Bool) {
      // Get the user id and set it to the user id global variable
      Auth.auth().addStateDidChangeListener() { auth, user in
         if user != nil {
            guard let uId = user?.uid else {return}
            self.uid = uId
         }
      }
      self.navigationController?.setNavigationBarHidden(false, animated: false)
      getLineups()
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
   
   // MARK: Private Methods
   
   // Creates a new lineup and stores their info in firebase
   func getLineups(){
      // Set up the references
      lineupRef = Database.database().reference()
      databaseHandleLineup = lineupRef?.child("lineups").observe(.childAdded, with: { (snapshot) in
         // If the player is one of the users players add it to the table
         if(self.lineupIsUsers(snapshot.key)){
            self.names.append(String(snapshot.key.suffix(snapshot.key.count - 29)))
            // take data from the snapshot and add a player object
            self.playerOneID = (snapshot.childSnapshot(forPath: "playerOne").value as! String)
            self.playerTwoID = (snapshot.childSnapshot(forPath: "playerTwo").value as! String)
            self.playerThreeID = (snapshot.childSnapshot(forPath: "playerThree").value as! String)
            self.playerFourID = (snapshot.childSnapshot(forPath: "playerFour").value as! String)
            self.playerFiveID = (snapshot.childSnapshot(forPath: "playerFive").value as! String)
         }
      })
      
      let playerOne = self.findPlayer(self.playerOneID!)
      let playerTwo = self.findPlayer(self.playerTwoID!)
      let playerThree = self.findPlayer(self.playerThreeID!)
      let playerFour = self.findPlayer(self.playerFourID!)
      let playerFive = self.findPlayer(self.playerFiveID!)
      
      let lineup: [Player] = [Player](arrayLiteral: playerOne,playerTwo,playerThree,playerFour,playerFive)
      
      self.currentPath = IndexPath(row:self.lineups.count, section: 0)
      
      self.lineups.append(lineup)
      
      
      self.tableView.beginUpdates()
      self.tableView.insertRows(at: [self.currentPath], with: .automatic)
      self.tableView.endUpdates()
      
   }
   
   func findPlayer(_ pid: String) -> Player{
      var player:Player?
      playerRef = Database.database().reference()
      playerRef?.child("players").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
         
         // If the player is the one we are looking for
         if(snapshot.key == pid){
            // take data from the snapshot and add a player object
            let fnameSnap = snapshot.childSnapshot(forPath: "fname")
            let lnameSnap = snapshot.childSnapshot(forPath: "lname")
            let heightSnap = snapshot.childSnapshot(forPath: "height")
            let weightSnap = snapshot.childSnapshot(forPath: "weight")
            let positionSnap = snapshot.childSnapshot(forPath: "position")
            let rankSnap = snapshot.childSnapshot(forPath: "rank")
            let pidSnap = snapshot.childSnapshot(forPath: "pid")
            
            player = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: UIImage(named: "Default"), position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String, playerId: pidSnap.value as! String)
         }
      }) { (error) in
         print(error.localizedDescription)
      }
      return player!
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
         let lineupName = sourceViewController.nameForLineup
         names.append(lineupName!)
         let newIndexPath = IndexPath(row: lineups.count, section: 0)
         lineups.append(lineup)
         tableView.insertRows(at: [newIndexPath], with: .automatic)
         
         let lid = uid + "-" + lineupName!
         let ref = Database.database().reference(withPath: "lineups")
         
         let playerRef = ref.child(lid)
         let playerData : [String: Any] = ["playerOne": lineup[0].playerId,
                                           "playerTwo": lineup[1].playerId,
                                           "playerThree": lineup[2].playerId,
                                           "playerFour": lineup[3].playerId,
                                           "playerFive": lineup[4].playerId]
         playerRef.setValue(playerData)

      }
   }

}
