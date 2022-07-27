//
//  ShotChartViewController.swift
//  basketball-app
//
//  Created by David on 10/12/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

/** Handles logic for freethrow view */
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
    @IBOutlet weak var missedFinalButton: UIButton! //will press if last foul shot was missed
    @IBOutlet weak var madeFinalButton: UIButton! //will press if last foul shot was made
    @IBOutlet weak var benchView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        
        //hide the Finalbuttons for now
        missedFinalButton.isHidden = true
        madeFinalButton.isHidden = true
        missedFinalButton.tag = -1
        
        made0Button.tag = 0
        made1Button.tag = 1
        //only display 2 and 3 point buttons if not and1
        if (gameState["and1Display"] as! Bool){
            made2Button.isHidden = true
            made3Button.isHidden = true
        }
        gameState["and1Display"] = false
        made2Button.tag = 2
        made3Button.tag = 3
        playerImage.layer.masksToBounds = false
        playerImage.layer.cornerRadius = playerImage.frame.size.width/2
        playerImage.clipsToBounds = true
        
        super.viewDidLoad()
        UIView.setAnimationsEnabled(false)
        
        shots = gameState["foulShots"] as? Int ?? 0
        isOpponent = gameState["oppFreeThrow"] as? Bool ?? false
        if !isOpponent,
            let player = gameState["fouledPlayer"] as? Player {
            playerImage.image = player.photo
            shootingPlayer = player
        } else if !isOpponent {
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
        if segue.identifier == "gameviewSegue2" {
            if let gameView = segue.destination as? GameViewController {
                self.gameState["transitionState"] = "freethrow"
                gameView.gameState = self.gameState
            }
        }
    }
    
    /** go back to previous state*/
    func goBack(){
        gameState["transitionState"] = "freethrow"
        let parent = self.presentingViewController as! GameViewController
        parent.gameState = gameState
        if let message = playSequence {
            parent.pushPlaySequence(event: message)
        }
        dismiss(animated: false)
    }
    /** handles logic for the final shot*/
    @IBAction func finalShot(_ sender: UIButton){
        
        if sender.tag == -1 {
            //missed final shot
            gameState["missedFinalFT"] = true
        }
        
        //put the buttons back to normal display
        made0Button.isHidden = true
        made1Button.isHidden = true
        made2Button.isHidden = true
        made3Button.isHidden = true
        missedFinalButton.isHidden = true
        madeFinalButton.isHidden = true

        goBack()
    }
    /**
        handles logic for shots made, interacts with database
     */
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
        
        //if the made2 button is hidden then we know its And1 and dont need to prompt,
        //if made0 or made3 button was pressed we dont need to prompt for final shot outcome
        if made2Button.isHidden || sender.tag == 0 || sender.tag == 3{
            if sender.tag == 0 {
                gameState["missedFinalFT"] = true
            }
            goBack()
        }else{
            //display the final buttons, hide the others
            missedFinalButton.isHidden = false
            madeFinalButton.isHidden = false
            
            made0Button.isHidden = true
            made1Button.isHidden = true
            made2Button.isHidden = true
            made3Button.isHidden = true
        }
        
    }
    
}
