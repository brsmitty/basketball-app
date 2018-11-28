//
//  ShotChartViewController.swift
//  basketball-app
//
//  Created by David on 10/12/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class ShotChartViewController: UIViewController {
    
    var gameState: [String: Any] = [:]
    @IBOutlet weak var chartView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //displayShots()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            saveShot(location: touch.location(in: self.view))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameviewSegue" {
            if let gameView = segue.destination as? GameViewController {
                gameView.gameState = self.gameState
            }
        }
    }
    
    
    func saveShot(location: CGPoint){
        let index = gameState["ballIndex"] as! Int
        var active = gameState["active"] as! [Player]
        let shooter = active[index]
        let shotAlert = UIAlertController(title: "Shot Outcome", message: "", preferredStyle: .alert)
        UIView.setAnimationsEnabled(false)
        let made = UIAlertAction(title: "Made", style: UIAlertActionStyle.default) { UIAlertAction in
            shooter.updatePoints(points: 2)
            shooter.updateTwoPointMade(made: 1)
            shooter.updateTwoPointAttempt(attempted: 1)
            let assistIndex = self.gameState["assistingPlayerIndex"] as! Int
            if assistIndex != 999 {
                let assister = active[assistIndex]
                assister.updateAssists(assists: 1)
                self.pushPlaySequence(event: "\(active[assistIndex].firstName) got the assist")
            }
            print(location.x)
            print(location.y)
            if(self.determineThreePoint(location: location)){
                let temp = self.gameState["homeScore"] as! Int
                self.gameState["homeScore"] = temp + 3
            }
            else{
                let temp = self.gameState["homeScore"] as! Int
                self.gameState["homeScore"] = temp + 2
            }
            let shot = (location.x, location.y, true)
            var shots = self.gameState["shots"] as! [(x: CGFloat, y: CGFloat, made: Bool)]
            shots.append(shot)
            self.gameState["shots"] = shots
            self.gameState["transitionState"] = "madeShot"
            let index = self.gameState["ballIndex"] as! Int
            var active = self.gameState["active"] as! [Player]
            self.pushPlaySequence(event: "\(active[index].firstName) made the shot")
            self.performSegue(withIdentifier: "gameviewSegue", sender: nil)
        }
        let missed = UIAlertAction(title: "Missed", style: UIAlertActionStyle.destructive) { UIAlertAction in
            shooter.updateTwoPointAttempt(attempted: 1)
            let shot = (location.x, location.y, false)
            var shots = self.gameState["shots"] as! [(x: CGFloat, y: CGFloat, made: Bool)]
            shots.append(shot)
            self.gameState["shots"] = shots
            self.gameState["transitionState"] = "missedShot"
            let index = self.gameState["ballIndex"] as! Int
            var active = self.gameState["active"] as! [Player]
            self.pushPlaySequence(event: "\(active[index].firstName) missed the shot")
            self.performSegue(withIdentifier: "gameviewSegue", sender: nil)
        }
        shotAlert.addAction(made)
        shotAlert.addAction(missed)
        shotAlert.popoverPresentationController?.sourceView = view
        shotAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: location, size: CGSize.init())
        present(shotAlert, animated: false)
    }
    
    func displayShots() {
        let shots = gameState["shots"] as! [(x: CGFloat, y: CGFloat, made: Bool)]
        for shot in shots {
            let label = UILabel(frame: CGRect.init(origin: CGPoint.init(x: shot.x, y: shot.y), size: CGSize.init()))
            if shot.made { label.text = "o" }
            else { label.text = "x" }
            label.layer.zPosition = 10
            chartView.addSubview(label)
        }
    }
    
    func pushPlaySequence(event: String) {
        var playSequence = gameState["playSequence"] as! [String]
        playSequence.append(event)
        gameState["playSequence"] = playSequence
    }
    
    func determineThreePoint(location: CGPoint) -> Bool{
        var value = false
        if(location.y > 594.5){
            value = true
        }
        else{
            if(location.x < 101.5 || location.x > 927.5){
                value = true
            }
            else{
                if(location.x < 521){
                    let temp = 1.47 * location.x + 151.58
                    if(temp < location.y){
                        value = true
                    }
                }
                else{
                    let temp = -1.64 * location.x + 1794.67
                    if(temp < location.y){
                        value = true
                    }
                }
            }
        }
        return value
    }
    
}
