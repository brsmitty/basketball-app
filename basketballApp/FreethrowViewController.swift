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
    var shootingPlayer: Player?
    var isOpponent = false
    var shots = 0
    var playSequence: String?
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
        print("FREE THROW VIEW")
        shots = gameState["foulShots"] as? Int ?? 0
        isOpponent = gameState["oppFreeThrow"] as? Bool ?? false
        if !isOpponent,
            let player = gameState["fouledPlayer"] as? Player {
            print("not opponent free throw")
            playerImage.image = player.photo
            shootingPlayer = player
        } else if !isOpponent {
            print("opponent free throw")
            let playersAlert = UIAlertController(title: "Shooting", message: "", preferredStyle: .alert)
            var activePlayer: UIAlertAction
            for player in gameState["active"] as? [Player] ?? [] {
                
                activePlayer = UIAlertAction(title: "\(player.firstName) \(player.lastName)", style: UIAlertActionStyle.default) { UIAlertAction in
                    self.shootingPlayer = player
                    self.playerImage.image = player.photo
                }
                playersAlert.addAction(activePlayer)
            }
            playersAlert.popoverPresentationController?.sourceView = view
            present(playersAlert, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("free throw prepare segue")
        if segue.identifier == "gameviewSegue2" {
            if let gameView = segue.destination as? GameViewController {
                self.gameState["transitionState"] = "freethrow"
                gameView.gameState = self.gameState
            }
        }
    }
    
    func goBack(){
        gameState["transitionState"] = "freethrow"
        let parent = self.presentingViewController as! GameViewController
        parent.gameState = gameState
        if let message = playSequence {
            parent.pushPlaySequence(event: message)
        }
        dismiss(animated: false)
    }
    
    @IBAction func madeShots(_ sender: UIButton) {
        
        if let player = shootingPlayer {
            
            var score = gameState["homeScore"] as! Int
            score += sender.tag
            
            playSequence = "\(player.firstName) hit \(sender.tag) out of \(shots) free throws"
            gameState["homeScore"] = score
            for _ in 0..<shots {
                _ = DBApi.sharedInstance.storeStat(type: .freeThrowAttempt, pid: player.playerId, seconds: gameState["timeSeconds"] as? Double ?? 0)
            }
            for _ in 0..<sender.tag {
                _ = DBApi.sharedInstance.storeStat(type: .freeThrow, pid: player.playerId, seconds: gameState["timeSeconds"] as? Double ?? 0)
            }
        } else if isOpponent {
            var oppScore = gameState["oppScore"] as! Int
            oppScore += sender.tag
            gameState["oppScore"] = oppScore
            
            // not recording who on the opposing team took the free throws
        }
//        self.performSegue(withIdentifier: "gameviewSegue2", sender: nil)
        goBack()
    }
    
}
