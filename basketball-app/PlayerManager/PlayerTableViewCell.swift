//
//  PlayerTableViewCell.swift
//  basketball-app
//
//  Created by Mike White on 9/11/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
   
   // MARK: Properties
   
   @IBOutlet weak var photoImageView: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
