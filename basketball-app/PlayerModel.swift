//
//  PlayerModel.swift
//  basketball-app
//
//  Created by Mike White on 9/8/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class PlayerModel: NSObject {

   func getPlayers() -> [Player] {
      
      // Will get player data from firebase
      
      var players = [Player]()
      
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
