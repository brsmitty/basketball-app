//
//  ShotChartViewController.swift
//  basketball-app
//
//  Created by David on 10/12/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//
import UIKit
import CircleAnimatedMenu
import Device

/**
 controls view of shot chart
    - handles fouls
    - handles shots made
    - handles cancelling a shot
    - handles missed shots
    - controls other ui functionality
 */
class ShotChartViewController: UIViewController {
    
    var gameState: [String: Any] = [:]
    @IBOutlet weak var chartView: UIImageView!
    var shotLocation: CGPoint = CGPoint.init()
    var displayedSelection: Bool = false
    var shotMenu :  CircleAnimatedMenu? = nil
    
    var defenseCourtTransform: CGAffineTransform?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayedSelection = false
        defenseCourtTransform = chartView.transform.rotated(by: .pi)
    }
   
   override func viewWillAppear(_ animated: Bool) {
    displayShots()
    //if possession is defense flip the view to the opponent side
    if (self.gameState["possession"] as! String == "defense") {
        chartView.transform = defenseCourtTransform!
    }
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            shotLocation = touch.location(in: self.view)
            shotSelect(location: shotLocation)
            print("x: \(shotLocation.x)")
            print("y: \(shotLocation.y)")
        }
    }
    
    /** conrtols functionality for selecting a shot*/
    @IBAction func shotSelect (location: CGPoint) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "shotPopover") as! ShotChartViewController
        resultVC.modalPresentationStyle = .popover
        resultVC.popoverPresentationController?.sourceView = view
        resultVC.popoverPresentationController?.sourceRect = CGRect.init(origin: location, size: CGSize.init())
        resultVC.gameState = gameState
        resultVC.shotLocation = shotLocation
        if(self.displayedSelection){
            self.shotMenu?.removeFromSuperview()
        }
        let shotFrame = CGRect(x:location.x-110, y:location.y-110, width:220, height:220)
        self.shotMenu = CircleAnimatedMenu(menuFrame: shotFrame, dataArray:[
            ("cancel","cancel"),("foul","foul"), ("made","made"), ("missed","missed"), ("and 1", "and 1")
            ])
        self.shotMenu?.innerCircleColor = UIColor.clear
        self.shotMenu?.highlightedColor = UIColor.orange
        self.shotMenu?.animated = false
        self.shotMenu?.delegate = self
        self.displayedSelection = true
        self.view.addSubview(self.shotMenu!)
    }
    
    /** logic for going back to the previous state*/
    func goBack(){
        let parent = self.presentingViewController as! GameViewController
        parent.gameState = gameState
        self.dismiss(animated: false, completion: nil)
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameviewSegue" || segue.identifier == "gameviewSeg" {
            if let gameView = segue.destination as? GameViewController {
                gameView.gameState = self.gameState
                //dismiss(animated: false, completion: nil)
            }
        }
    }
    
    /** handles logic for a foul*/
    func handleFoul(){
        if self.gameState["possession"] as! String == "offense" {
            let index = gameState["ballIndex"] as! Int
            var active = gameState["active"] as! [Player]
            let shooter = active[index]
            
            if(determineThreePoint(location: shotLocation)){
                gameState["foulShots"] = 3
                _ = DBApi.sharedInstance.storeStat(type: Statistic.score3Attempt, pid: shooter.playerId, seconds: gameState["timeSeconds"] as! Double)
            }
            else{
                gameState["foulShots"] = 2
                _ = DBApi.sharedInstance.storeStat(type: Statistic.score2Attempt, pid: shooter.playerId, seconds: gameState["timeSeconds"] as! Double)
            }
        }
        self.gameState["transitionState"] = "shotFoul"
        self.goBack()
    }
    
    /**
     handles logic for a shot that has been made
        - param marks if shot is foul
     */
    func madeShot(foul: Bool) {
        if (self.gameState["possession"] as! String == "offense") {

            let temp = gameState["homeScore"] as! Int
            
            let index = gameState["ballIndex"] as! Int
            var active = gameState["active"] as! [Player]
            let shooter = active[index]
            
            if(determineThreePoint(location: shotLocation)){
                gameState["homeScore"] = temp + 3
                _ = DBApi.sharedInstance.storeStat(type: Statistic.score3Attempt, pid: shooter.playerId, seconds: gameState["timeSeconds"] as! Double)
                _ = DBApi.sharedInstance.storeStat(type: Statistic.score3, pid: shooter.playerId, seconds: gameState["timeSeconds"] as! Double)
            }
            else{
                gameState["homeScore"] = temp + 2
                _ = DBApi.sharedInstance.storeStat(type: Statistic.score2Attempt, pid: shooter.playerId, seconds: gameState["timeSeconds"] as! Double)
                _ = DBApi.sharedInstance.storeStat(type: Statistic.score2, pid: shooter.playerId, seconds: gameState["timeSeconds"] as! Double)
            }
            shooter.updatePoints(points: 2)
            shooter.updateTwoPointMade(made: 1)
            shooter.updateTwoPointAttempt(attempted: 1)
            
            let assistIndex = self.gameState["assistingPlayerIndex"] as! Int
            if assistIndex != 999 {
                let assister = active[assistIndex]
                assister.updateAssists(assists: 1)
                _ = DBApi.sharedInstance.storeStat(type: Statistic.assist, pid: assister.playerId, seconds: gameState["timeSeconds"] as! Double)
                self.pushPlaySequence(event: "\(active[assistIndex].firstName) got the assist")
            }
            let shot = (shotLocation.x, shotLocation.y, true)
            var shots = self.gameState["shots"] as! [(x: CGFloat, y: CGFloat, made: Bool)]
            shots.append(shot)
            self.gameState["shots"] = shots
            self.gameState["transitionState"] = foul ? "shotMadeFoul" : "madeShot"
            self.gameState["foulShots"] = foul ? 1 : nil
            self.pushPlaySequence(event: "\(shooter.firstName) made the shot")
        }
        else {
            let temp = gameState["oppScore"] as! Int
            self.gameState["transitionState"] = foul ? "shotMadeFoul" : "madeShot"
            self.gameState["foulShots"] = foul ? 1 : nil
            
            if(determineThreePoint(location: shotLocation)){
                gameState["oppScore"] = temp + 3
                self.gameState["opponentScored"] = 3
            }
            else{
                gameState["oppScore"] = temp + 2
                self.gameState["opponentScored"] = 2
            }
        }

        self.goBack()
        // self.performSegue(withIdentifier: "gameviewSeg", sender: self)
    }
    
    /** handles logic for cancelling a shot*/
    func cancelShot() {
        self.goBack()
    }
    
    /** handles logic for a missed shot*/
     func missedShot() {
        if (self.gameState["possession"] as! String == "offense") {
            let index = gameState["ballIndex"] as! Int
            var active = gameState["active"] as! [Player]
            let shooter = active[index]
            shooter.updateTwoPointAttempt(attempted: 1)
            if(determineThreePoint(location: shotLocation)){
                _ = DBApi.sharedInstance.storeStat(type: Statistic.score3Attempt, pid: shooter.playerId, seconds: gameState["timeSeconds"] as! Double)
            } else {
                _ = DBApi.sharedInstance.storeStat(type: Statistic.score2Attempt, pid: shooter.playerId, seconds: gameState["timeSeconds"] as! Double)
            }
            let shot = (shotLocation.x, shotLocation.y, false)
            var shots = self.gameState["shots"] as! [(x: CGFloat, y: CGFloat, made: Bool)]
            shots.append(shot)
            self.gameState["shots"] = shots
            self.gameState["transitionState"] = "missedShot"
            self.pushPlaySequence(event: "\(shooter.firstName) missed the shot")
        } else {
            self.pushPlaySequence(event: "Opponent missed the shot")
            self.gameState["transitionState"] = "missedShot"
        }
        self.goBack()
    }
    
    // TODO: These locations are off because of using absolute distances
    /**Displays the old shots taken on the shot chart. made shots are an o and missed are x**/
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
    
    /**handles logic for playing a sequence**/
    func pushPlaySequence(event: String) {
        var playSequence = gameState["playSequence"] as! [String]
        playSequence.append(event)
        gameState["playSequence"] = playSequence
    }
    // TODO: These distances should be relative
    /** Determines if a shot taken was a 3 pointer.*/
    func determineThreePoint(location: CGPoint) -> Bool {
        var isThreePoint = false
        
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        
        let locationWidthPercentage = Double(location.x) / screenWidth
        let locationHeightPercentage = Double(location.y) / screenHeight
        
        // If below bottom of curve, automatic three point
        if(locationHeightPercentage > 0.7) { isThreePoint = true }
        // If left or right of curve
        else if locationWidthPercentage < 0.1 || locationWidthPercentage > 0.9 { isThreePoint = true }
        else {
            if(locationWidthPercentage < 0.5) {
                let temp = 1.47 * location.x + 151.58
                if(temp < location.y) { isThreePoint = true }
            }
            else{
                let temp = -1.64 * location.x + 1794.67
                if(temp < location.y) { isThreePoint = true }
            }
        }
        return isThreePoint
    }
}


extension ShotChartViewController : CircleAnimatedMenuDelegate {
    func sectionSelected(text: String, index: Int){
        print(text)
        if (text=="made") {
            madeShot(foul: false)
        } else if (text=="missed") {
            missedShot()
           // missedShot(<#T##sender: UIButton##UIButton#>)
        } else if (text=="cancel") {
            cancelShot()
        } else if (text=="foul") {
            handleFoul()
        } else if (text=="and 1") {
            madeShot(foul: true)
        }
    }
}
