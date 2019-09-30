//
//  PlayerKPITableViewCell.swift
//  basketballApp
//
//  Created by Hesham Hussain on 9/29/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//

import UIKit

class PlayerKPITableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var player: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
