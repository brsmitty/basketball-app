//
//  PlayerModel.swift
//  basketball-app
//
//  Created by Mike White on 9/8/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PlayerModel: NSObject {
   
   var ref:DatabaseReference?
   var databaseHandle:DatabaseHandle?
   var players = [Player]()

   func getPlayers() -> [Player] {
      
      // Will get player data from firebase
      
      ref = Database.database().reference()
      
      databaseHandle = ref?.child("players").observe(.childAdded, with: { (snapshot) in
         
         // take data from the snapshot and add a player object
         let fnameSnap = snapshot.childSnapshot(forPath: "fname")
         let lnameSnap = snapshot.childSnapshot(forPath: "lname")
         let heightSnap = snapshot.childSnapshot(forPath: "height")
         let weightSnap = snapshot.childSnapshot(forPath: "weight")
         let positionSnap = snapshot.childSnapshot(forPath: "position")
         let rankSnap = snapshot.childSnapshot(forPath: "rank")
         let pidSnap = snapshot.childSnapshot(forPath: "pid")
         
         let playerData = pidSnap.key as? String
         if let actualData = playerData {
            guard let player = Player(firstName: fnameSnap.value as! String, lastName: lnameSnap.value as! String, photo: UIImage(named: "Default"), position: positionSnap.value as! String, height: heightSnap.value as! String, weight: weightSnap.value as! String, rank: rankSnap.value as! String)
               else {
                  fatalError("Counld not instantiate player")
            }
            self.players.append(player)
            print(self.players.count)
         }
         
      })
      
      print(players.count)
      ///////////////
      
      guard let player1 = Player(firstName: "Michael",lastName: "White", photo: UIImage(named:"Kyrie"), position: "Point-Guard", height: "5'11", weight: "180", rank: "senior")
         else {
            fatalError("Could not instantiate player1")
      }
      players.append(player1)
      
      guard let player2 = Player(firstName: "David",lastName: "Zucco", photo: UIImage(named:"Lebron"), position: "Small-Forward", height: "?", weight: "?", rank: "senior")
         else{
            fatalError("Could not instantiate player2")
      }
      players.append(player2)
      
      guard let player3 = Player(firstName: "Yiwei",lastName: "Zhang", photo: UIImage(named:"J.R."), position: "Shooting-Guard", height: "?", weight: "?", rank: "senior")
         else {
            fatalError("Could not instantiate player3")
      }
      
      players.append(player3)
      
      
      return players
   }
}
