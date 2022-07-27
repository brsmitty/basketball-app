//
//  LineupTableViewCell.swift
//  basketball-app
//
//  Created by Mike White on 9/23/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

/** organizes items in lineup table*/
class LineupTableViewCell: UITableViewCell {
   
   // MARK: Properties
   
   @IBOutlet weak var playerOneImage: UIImageView!
   @IBOutlet weak var playerOneName: UILabel!
   @IBOutlet weak var playerTwoImage: UIImageView!
   @IBOutlet weak var playerTwoName: UILabel!
   @IBOutlet weak var playerThreeImage: UIImageView!
   @IBOutlet weak var playerThreeName: UILabel!
   @IBOutlet weak var playerFourImage: UIImageView!
   @IBOutlet weak var playerFourName: UILabel!
   @IBOutlet weak var playerFiveImage: UIImageView!
   @IBOutlet weak var playerFiveName: UILabel!
   @IBOutlet weak var lineupName: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
