//
//  Action.swift
//  basketball-app
//
//  Created by David on 11/23/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

/** Defines an action for the given players */
class Action: NSObject {
    var type: String
    var time: TimeInterval
    var primaryPlayer: Player
    var secondaryPlayer: Player?
    
    init(type: String, time: TimeInterval, primaryPlayer: Player, secondaryPlayer: Player?) {
        self.type = type
        self.time = time
        self.primaryPlayer = primaryPlayer
        self.secondaryPlayer = secondaryPlayer ?? nil
    }
    

}
