//
//  BenchTableViewCell.swift
//  basketball-app
//
//  Created by Mike White on 11/17/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

/**organizes layout of bench table**/
class BenchTableViewCell: UITableViewCell {

   // MARK: Properties
   
   @IBOutlet weak var photoImageView: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
      photoImageView.layer.masksToBounds = false
      photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2
      photoImageView.clipsToBounds = true
      photoImageView.contentMode = .scaleAspectFill
      
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }

}
