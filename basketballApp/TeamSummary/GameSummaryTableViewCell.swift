//
//  GameSummaryTableViewCell.swift
//  basketballApp
//
//  Created by Hesham Hussain on 11/15/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//

import UIKit

/** Handles labels for game summary table */

class GameSummaryTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var minutesPlayed: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var twoPointers: UILabel!
    @IBOutlet weak var threePointers: UILabel!
    @IBOutlet weak var plusMinus: UILabel!
    
    @IBOutlet weak var turnoverPercent: UILabel!
    @IBOutlet weak var effectiveFGPercent: UILabel!
    @IBOutlet weak var offensiveReboundPercent: UILabel!
    @IBOutlet weak var freeThrow: UILabel!
    
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var player3: UILabel!
    @IBOutlet weak var player4: UILabel!
    @IBOutlet weak var player5: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
