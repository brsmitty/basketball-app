//
//  Player.swift
//  basketball-app
//
//  Created by Mike White on 9/8/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

struct FGMade {
   var total:Int = 0
   var threePoint:Int = 0
   var twoPoint:Int = 0
}

class Player: NSObject {
   
   // MARK: Properties
   
   var playerId:String
   var firstName:String
   var lastName:String
   var photo: UIImage?
   var position:String
   var height:String
   var weight:String
   var rank:String
   var points:Int
   var assists:Int
   var turnovers:Int
   var fgAttempts:Int
   var fgMade = FGMade()
   var offRebounds:Int
   var ftAttempts:Int
   var ftMade:Int
   var steals:Int
   var defRebounds:Int
   var deflections:Int
   var blocks:Int
   var personalFoul:Int
   var chagesTaken:Int
   var techFoul:Int
   
   // MARK: Initialization
   
   init?(firstName: String, lastName: String, photo: UIImage?, position:String, height: String, weight: String, rank: String, playerId: String){
      
      // Fail init without name
      guard !firstName.isEmpty else{
         return nil
      }
      guard !lastName.isEmpty else{
         return nil
      }

      // Initialize stored parameters
      self.playerId = playerId
      self.firstName = firstName
      self.lastName = lastName
      self.photo = photo
      self.height = height
      self.weight = weight
      self.rank = rank
      self.position = position
      self.points = 0
      self.assists = 0
      self.turnovers = 0
      self.fgAttempts = 0
      self.fgMade.threePoint = 0
      self.fgMade.twoPoint = 0
      self.fgMade.total = self.fgMade.threePoint + self.fgMade.twoPoint
      self.offRebounds = 0
      self.ftAttempts = 0
      self.ftMade = 0
      self.steals = 0
      self.defRebounds = 0
      self.deflections = 0
      self.blocks = 0
      self.personalFoul = 0
      self.chagesTaken = 0
      self.techFoul = 0
   }

}
