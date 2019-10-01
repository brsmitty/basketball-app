//
//  PlayerKPITableViewCell.swift
//  basketballApp
//
//  Created by Hesham Hussain on 9/29/19.
//  Representation of a single cell in the box score chart
//

import UIKit

class PlayerKPITableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var player: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var fieldGoals: UILabel!
    
    @IBOutlet weak var playerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set default values for box score cells
        //minutes.text = "0"
        //fieldGoals.text = "0-0"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
