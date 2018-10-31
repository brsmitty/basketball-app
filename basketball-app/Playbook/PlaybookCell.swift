//
//  PlaybookCell.swift
//  basketball-app
//
//  Created by Maggie Zhang on 10/3/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

protocol PlaybookCellDelegate{
    func viewPdf(titleText: String)
}
class PlaybookCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    var delegate: PlaybookCellDelegate?
    
    func setGame(playbook: Playbook){
       title.text = playbook.title
    }
    
    @IBAction func viewButtonClick(_ sender: Any) {
        delegate?.viewPdf(titleText: title.text!)
    }
}
