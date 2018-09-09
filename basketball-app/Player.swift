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
   
   var firstName:String = ""
   var lastName:String = ""
   var position:String = ""
   var height:String = ""
   var weight:String = ""
   var rank:String = ""
   var points:Int = 0
   var assists:Int = 0
   var turnovers:Int = 0
   var fgAttempts:Int = 0
   var fgMade = FGMade()
   var offRebounds:Int = 0
   var ftAttempts:Int = 0
   var ftMade:Int = 0
   var steals:Int = 0
   var defRebounds:Int = 0
   var deflections:Int = 0
   var blocks:Int = 0
   var personalFoul:Int = 0
   var chagesTaken:Int = 0
   var techFoul:Int = 0

}
