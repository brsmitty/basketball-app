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

struct FGAttempts {
    var total:Int = 0
    var threePoint:Int = 0
    var twoPoint:Int = 0
}

class Player: NSObject {
   
   // MARK: Properties
   
   var playerId:String
    var teamId: String
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
   var fgAttempts = FGAttempts()
   var fgMade = FGMade()
   var offRebounds:Int
   var ftAttempts:Int
   var ftMade:Int
   var steals:Int
   var defRebounds:Int
   var deflections:Int
   var blocks:Int
   var personalFoul:Int
   var chargesTaken:Int
   var techFoul:Int
   
   // MARK: Initialization
   
    init(firstName: String, lastName: String, photo: UIImage?, position:String, height: String, weight: String, rank: String, playerId: String){
      
      // Fail init without name

      // Initialize stored parameters
      self.playerId = playerId
      self.teamId = "123"
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
      self.fgAttempts.threePoint = 0
      self.fgAttempts.twoPoint = 0
      self.fgAttempts.total = self.fgAttempts.threePoint + self.fgAttempts.twoPoint
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
      self.chargesTaken = 0
      self.techFoul = 0
   }
    
    func updatePoints(points: Int){
        self.points += points
    }
    
    func updateAssists(assits: Int){
        self.assists += assists
    }
    
    func updateTurnovers(turnovers: Int){
        self.turnovers += turnovers
    }
    
    func updateThreePointMade(made: Int){
        self.fgMade.threePoint += made
    }
    
    func updateTwoPointMade(made: Int){
        self.fgMade.twoPoint += made
    }
    
    func updateFreeThrowMade(made: Int){
        self.ftMade += made
    }
    
    func updateThreePointAttempt(attempted: Int){
        self.fgAttempts.threePoint += attempted
    }
    
    func updateTwoPointAttempt(attempted: Int){
        self.fgAttempts.twoPoint += attempted
    }
    
    func updateFreeThrowAttempt(attempted: Int){
        self.ftAttempts += attempted
    }
    
    func updatePersonalFouls(fouls: Int){
        self.personalFoul += fouls
    }
    
    func updateTechFouls(fouls: Int){
        self.techFoul += fouls
    }
    
    func updateChargesTaken(charges: Int){
        self.chargesTaken += charges
    }
    
    func updateDefRebounds(rebounds: Int){
        self.defRebounds += rebounds
    }
    
    func updateOffRebounds(rebounds: Int){
        self.offRebounds += rebounds
    }
    
    func updateDeflections(deflections: Int){
        self.deflections += deflections
    }
    
    func updateBlocks(blocks: Int){
        self.blocks += blocks
    }
    
    func updateSteals(steals: Int){
        self.steals += steals
    }
    
    func firebaseSync(){
        
    }

}
