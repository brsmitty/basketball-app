//
//  PlayerKPITableViewCell.swift
//  basketballApp
//
//  Created by Hesham Hussain on 9/29/19.
//  Representation of a single cell in the box score chart
//

import UIKit

class BoxScoreTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var minutesPlayed: UILabel!
    @IBOutlet weak var twoPointers: UILabel!
    @IBOutlet weak var threePointers: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var fieldGoals: UILabel!
    @IBOutlet weak var freeThrows: UILabel!
    @IBOutlet weak var charges: UILabel!
    @IBOutlet weak var offensiveRebounds: UILabel!
    @IBOutlet weak var defensiveRebounds: UILabel!
    @IBOutlet weak var rebounds: UILabel!
    @IBOutlet weak var steals: UILabel!
    @IBOutlet weak var blocks: UILabel!
    @IBOutlet weak var turnovers: UILabel!
    @IBOutlet weak var plusMinus: UILabel!
    @IBOutlet weak var personalFouls: UILabel!
    @IBOutlet weak var playerEffeciencyRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set default values for box score cells
        minutesPlayed.text = "0"
        fieldGoals.text = "0-0"
        threePointers.text = "0-0"
        freeThrows.text = "0-0"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
