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
      
      let player1 = Player()
      
      player1.firstName = "Michael"
      player1.lastName = "White"
      player1.rank = "Senior"
      player1.position = "point-guard"
      
      players.append(player1)
      
      let player2 = Player()
      
      player2.firstName = "David"
      player2.lastName = "Zucco"
      player2.rank = "Senior"
      player2.position = "small-forward"
      
      players.append(player2)
      
      let player3 = Player()
      
      player3.firstName = "Yiwei"
      player3.lastName = "zhang"
      player3.rank = "Senior"
      player3.position = "shooting-guard"
      
      players.append(player3)
      
      return players
   }
}
