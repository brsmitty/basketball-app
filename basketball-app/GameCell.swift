//
//  GameCell.swift
//  basketball-app
//
//  Created by Maggie Zhang on 9/24/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell{
    
    @IBOutlet weak var GameDetail: UILabel!
    @IBOutlet weak var Cells: UIView!
    @IBOutlet weak var GameTitle: UILabel!

    func setGame(game: Game){
        GameTitle.text = game.title
        GameDetail.text = game.detail
    }

}
