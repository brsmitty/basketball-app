//
//  Player.swift
//  basketball-app
//
//  Created by Mike White on 9/8/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class Player: NSObject {
   
   // MARK: Properties
   
    var playerId:String
    var teamId: String
    
    var firstName:String
    var lastName:String
    var height:String
    var weight:String
    var position:String
    var rank:String
    var photo: UIImage?
    
    var points:Int?
    var assists:Int?
    var turnovers:Int?
    var threePtAtt: Int?
    var twoPtAtt: Int?
    var threePtMade: Int?
    var twoPtMade: Int?
    var ftAtt:Int?
    var ftMade:Int?
    var offRebounds:Int?
    var defRebounds:Int?
    var steals:Int?
    var blocks:Int?
    var deflections:Int?
    var personalFoul:Int?
    var techFoul:Int?
    var chargesTaken:Int?
    
    var active: Bool = false
    var hasBall: Bool = false
    var numberOfDribbles: Int = 0
    var numberOfPasses: Int = 0
   
   // MARK: Initialization
    
    init(dictionary: [String: Any], id: String) {
        playerId = id
        teamId = ""
        
        firstName = dictionary["fName"] as? String ?? ""
        lastName = dictionary["lName"] as? String ?? ""
        height = dictionary["height"] as? String ?? ""
        weight = dictionary["weight"] as? String ?? ""
        position = dictionary["position"] as? String ?? ""
        rank = dictionary["rank"] as? String ?? ""
        let imageName = dictionary["image_name"] as? String ?? ""
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
        photo = UIImage(contentsOfFile: imagePath) ?? UIImage(named: "Default")
    }
   
    init(firstName: String, lastName: String, photo: UIImage?, position:String, height: String, weight: String, rank: String, playerId: String, teamId: String){
        self.playerId = playerId
        self.teamId =  teamId

        self.firstName = firstName
        self.lastName = lastName
        self.height = height
        self.weight = weight
        self.position = position
        self.rank = rank
        self.photo = photo

        self.points = 0
        self.assists = 0
        self.turnovers = 0
        self.threePtAtt = 0
        self.twoPtAtt = 0
        self.threePtMade = 0
        self.twoPtMade = 0
        self.ftAtt = 0
        self.ftMade = 0
        self.offRebounds = 0
        self.defRebounds = 0
        self.steals = 0
        self.blocks = 0
        self.deflections = 0
        self.personalFoul = 0
        self.techFoul = 0
        self.chargesTaken = 0
   }
    
    init(firstName: String, lastName: String, photo: UIImage?, position:String, height: String, weight: String, rank: String, playerId: String, teamId: String, points: Int, assists: Int, turnovers: Int, threePtAtt: Int, twoPtAtt: Int, threePtMade: Int, twoPtMade: Int, ftAtt: Int, ftMade: Int, offRebounds: Int, defRebounds: Int, steals: Int, blocks: Int, deflections: Int, personalFoul: Int, techFoul: Int, chargesTaken: Int){
        self.playerId = playerId
        self.teamId =  teamId

        self.firstName = firstName
        self.lastName = lastName
        self.height = height
        self.weight = weight
        self.position = position
        self.rank = rank
        self.photo = photo

        self.points = points
        self.assists = assists
        self.turnovers = turnovers
        self.threePtAtt = threePtAtt
        self.twoPtAtt = twoPtAtt
        self.threePtMade = threePtMade
        self.twoPtMade = twoPtMade
        self.ftAtt = ftAtt
        self.ftMade = ftMade
        self.offRebounds = offRebounds
        self.defRebounds = defRebounds
        self.steals = steals
        self.blocks = blocks
        self.deflections = deflections
        self.personalFoul = personalFoul
        self.techFoul = techFoul
        self.chargesTaken = chargesTaken
    }
    
    func updatePoints(points: Int){
        self.points? += points
    }

    func updateAssists(assists: Int){
        self.assists? += assists
    }

    func updateTurnovers(turnovers: Int){
        self.turnovers? += turnovers
    }

    func updateThreePointMade(made: Int){
        self.threePtMade? += made
    }

    func updateTwoPointMade(made: Int){
        self.twoPtMade? += made
    }

    func updateFreeThrowMade(made: Int){
        self.ftMade? += made
    }

    func updateThreePointAttempt(attempted: Int){
        self.threePtAtt? += attempted
    }

    func updateTwoPointAttempt(attempted: Int){
        self.twoPtAtt? += attempted
    }

    func updateFreeThrowAttempt(attempted: Int){
        self.ftAtt? += attempted
    }

    func updatePersonalFouls(fouls: Int){
        self.personalFoul? += fouls
    }

    func updateTechFouls(fouls: Int){
        self.techFoul? += fouls
    }

    func updateChargesTaken(charges: Int){
        self.chargesTaken? += charges
    }

    func updateDefRebounds(rebounds: Int){
        self.defRebounds? += rebounds
    }

    func updateOffRebounds(rebounds: Int){
        self.offRebounds? += rebounds
    }

    func updateDeflections(deflections: Int){
        self.deflections? += deflections
    }

    func updateBlocks(blocks: Int){
        self.blocks? += blocks
    }

    func updateSteals(steals: Int){
        self.steals? += steals
    }
    
    func dribble(){
        self.numberOfDribbles += 1
    }

    func pass(){
        self.numberOfPasses += 1
    }
}
