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
      
      let player1 = Player(firstName: "Michael",lastName: "White", photo: nil, position: "point-guard", height: "5'11", weight: "180", rank: "senior")
      
      players.append(player1!)
      
      let player2 = Player(firstName: "David",lastName: "Zucco", photo: nil, position: "small-forward", height: "?", weight: "?", rank: "senior")
      
      players.append(player2!)
      
      let player3 = Player(firstName: "Yiwei",lastName: "Zhang", photo: nil, position: "shooting-guard", height: "?", weight: "?", rank: "senior")
      
      players.append(player3!)
      
      return players
   }
}
