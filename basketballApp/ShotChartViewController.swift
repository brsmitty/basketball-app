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
    var shotLocation: CGPoint = CGPoint.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
   override func viewWillAppear(_ animated: Bool) {
      displayShots()
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            shotLocation = touch.location(in: self.view)
            shotSelect(location: shotLocation)
        }
    }
    
    @IBAction func shotSelect (location: CGPoint) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "shotPopover") as! ShotChartViewController
        resultVC.modalPresentationStyle = .popover
        resultVC.popoverPresentationController?.sourceView = view
        resultVC.popoverPresentationController?.sourceRect = CGRect.init(origin: location, size: CGSize.init())
        resultVC.gameState = gameState
        resultVC.shotLocation = shotLocation
        self.present(resultVC, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameviewSegue" || segue.identifier == "gameviewSeg" {
            if let gameView = segue.destination as? GameViewController {
                gameView.gameState = self.gameState
                dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func madeShot(_ sender: UIButton) {
        let temp = gameState["homeScore"] as! Int
        if(determineThreePoint(location: shotLocation)){
            gameState["homeScore"] = temp + 3
        }
        else{
            gameState["homeScore"] = temp + 2
        }
        let index = gameState["ballIndex"] as! Int
        var active = gameState["active"] as! [Player]
        let shooter = active[index]
        shooter.updatePoints(points: 2)
        shooter.updateTwoPointMade(made: 1)
        shooter.updateTwoPointAttempt(attempted: 1)
        let assistIndex = self.gameState["assistingPlayerIndex"] as! Int
        if assistIndex != 999 {
            let assister = active[assistIndex]
            assister.updateAssists(assists: 1)
            self.pushPlaySequence(event: "\(active[assistIndex].firstName) got the assist")
        }
        let shot = (shotLocation.x, shotLocation.y, true)
        var shots = self.gameState["shots"] as! [(x: CGFloat, y: CGFloat, made: Bool)]
        shots.append(shot)
        self.gameState["shots"] = shots
        self.gameState["transitionState"] = "madeShot"
        self.pushPlaySequence(event: "\(shooter.firstName) made the shot")
//        self.performSegue(withIdentifier: "gameviewSeg", sender: nil)
        dismiss(animated: true)
    }
    
    @IBAction func missedShot(_ sender: UIButton) {
        let index = gameState["ballIndex"] as! Int
        var active = gameState["active"] as! [Player]
        let shooter = active[index]
        shooter.updateTwoPointAttempt(attempted: 1)
        let shot = (shotLocation.x, shotLocation.y, false)
        var shots = self.gameState["shots"] as! [(x: CGFloat, y: CGFloat, made: Bool)]
        shots.append(shot)
        self.gameState["shots"] = shots
        self.gameState["transitionState"] = "missedShot"
        self.pushPlaySequence(event: "\(shooter.firstName) missed the shot")
//        self.performSegue(withIdentifier: "gameviewSeg", sender: nil)
        dismiss(animated: true)
    }
    
    func displayShots() {
        let shots = gameState["shots"] as! [(x: CGFloat, y: CGFloat, made: Bool)]
        for shot in shots {
            let label = UILabel()
            var container = UIView()
            container = UIView(frame: CGRect(x: shot.x, y: shot.y, width: 20, height: 20))
            if shot.made {
                label.text = "o"
                label.textColor = .green
            }
            else {
                label.text = "x"
                label.textColor = .red
            }
            label.frame = container.frame
            container.addSubview(label)
            self.view.addSubview(container)
            self.view.bringSubview(toFront: container)
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
