//
//  DropDownTableViewCell.swift
//  basketball-app
//
//  Created by Mike White on 9/23/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {
   @IBOutlet weak var playerName: UILabel!
   @IBOutlet weak var playerImage: UIImageView!
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
