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
    var shootingPlayer: Player = Player(firstName: "", lastName: "", photo: nil, position: "", height: "", weight: "", rank: "", playerId: "", teamId: "")
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var made0Button: UIButton!
    @IBOutlet weak var made1Button: UIButton!
    @IBOutlet weak var made2Button: UIButton!
    @IBOutlet weak var made3Button: UIButton!
    @IBOutlet weak var benchView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        made0Button.tag = 0
        made1Button.tag = 1
        made2Button.tag = 2
        made3Button.tag = 3
        playerImage.layer.masksToBounds = false
        playerImage.layer.cornerRadius = playerImage.frame.size.width/2
        playerImage.clipsToBounds = true
        
        super.viewDidLoad()
        UIView.setAnimationsEnabled(false)
        let i = gameState["fouledPlayerIndex"] as! Int
        if (i == 999) {
            let playersAlert = UIAlertController(title: "Shooting", message: "", preferredStyle: .alert)
            var activePlayer: UIAlertAction
            for player in gameState["active"] as! [Player] {
                activePlayer = UIAlertAction(title: "\(player.firstName) \(player.lastName)", style: UIAlertActionStyle.default) { UIAlertAction in
                    self.shootingPlayer = player
                    self.playerImage.image = self.shootingPlayer.photo
                }
                playersAlert.addAction(activePlayer)
            }
            playersAlert.popoverPresentationController?.sourceView = view
            present(playersAlert, animated: false)
        }
        else {
            let players = gameState["active"] as! [Player]
            shootingPlayer = players[i]
            playerImage.image = shootingPlayer.photo
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameviewSegue2" {
            if let gameView = segue.destination as? GameViewController {
                self.gameState["transitionState"] = "freethrow"
                gameView.gameState = self.gameState
            }
        }
    }
    
    @IBAction func madeShots(_ sender: UIButton) {
        let offense = gameState["possession"] as! String == "offense"
        if (offense) {
            var score = gameState["score"] as! Int
            score += sender.tag
            gameState["score"] = score
        }
        else {
            var oppScore = gameState["oppScore"] as! Int
            oppScore += sender.tag
            gameState["oppScore"] = oppScore
        }
        self.performSegue(withIdentifier: "gameviewSegue2", sender: nil)
    }
    
}
