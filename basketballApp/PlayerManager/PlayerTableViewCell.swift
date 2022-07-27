//
//  PlayerTableViewCell.swift
//  basketball-app
//
//  Created by Mike White on 9/11/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

/** organizes items in player table*/
class PlayerTableViewCell: UITableViewCell {
   
   // MARK: Properties
   
   @IBOutlet weak var photoImageView: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      photoImageView.layer.masksToBounds = false
      photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2
      photoImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
