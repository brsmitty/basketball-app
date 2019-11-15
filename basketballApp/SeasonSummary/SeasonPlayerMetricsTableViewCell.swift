//
//  SeasonPlayerMetricsTableViewCell.swift
//  basketballApp
//
//  Created by Hesham Hussain on 10/17/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//

import UIKit

class SeasonPlayerMetricsTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var minutesPlayed: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var twoPointers: UILabel!
    @IBOutlet weak var threePointers: UILabel!
    @IBOutlet weak var plusMinus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
