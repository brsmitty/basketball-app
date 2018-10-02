//
//  Game.swift
//  basketball-app
//
//  Created by Maggie Zhang on 9/27/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class Game: NSObject {
    var title: String
    var detail: String
    
    init(title: String, detail: String){
        self.detail = detail
        self.title = title
    }
}
