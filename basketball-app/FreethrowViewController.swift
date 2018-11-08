//
//  ShotChartViewController.swift
//  basketball-app
//
//  Created by David on 10/12/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class FreethrowViewController: UIViewController {
    
    var gameState: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.performSegue(withIdentifier: "gameviewSegue2", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameviewSegue2" {
            if let gameView = segue.destination as? GameViewController {
                gameView.gameState = self.gameState
            }
        }
    }
    
}
