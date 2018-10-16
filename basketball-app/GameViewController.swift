//
//  GameViewController.swift
//  basketball-app
//
//  Created by David on 10/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class GameViewController: UIViewController {
    
    var ballIndex : Int = 1
    var roster : [String: Any] = [:]
//    var lineup : [String: Any] = [:]
    var active = [String?](repeating: nil, count: 5)
    var panStartPoint = CGPoint()
    var panEndPoint = CGPoint()
    let boxHeight : CGFloat = 100.0
    let boxWidth : CGFloat = 100.0
    var boxRects : [CGRect] = [CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init()]
    
    @IBOutlet weak var courtView: UIImageView!
    @IBOutlet weak var imageHoop: UIImageView!
    @IBOutlet weak var imagePlayer1: UIImageView!
    @IBOutlet weak var imagePlayer2: UIImageView!
    @IBOutlet weak var imagePlayer3: UIImageView!
    @IBOutlet weak var imagePlayer4: UIImageView!
    @IBOutlet weak var imagePlayer5: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxRects[0] = CGRect.init(x: imageHoop.frame.origin.x, y: imageHoop.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[1] = CGRect.init(x: imagePlayer1.frame.origin.x, y: imagePlayer1.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[2] = CGRect.init(x: imagePlayer2.frame.origin.x, y: imagePlayer2.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[3] = CGRect.init(x: imagePlayer3.frame.origin.x, y: imagePlayer3.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[4] = CGRect.init(x: imagePlayer4.frame.origin.x, y: imagePlayer4.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[5] = CGRect.init(x: imagePlayer5.frame.origin.x, y: imagePlayer5.frame.origin.y, width: boxWidth, height: boxHeight)
        getRoster()
    }
    
    func getRoster(){
        let defaults = UserDefaults.standard
        let tid = defaults.string(forKey: "tid")!
        let firebaseRef = Database.database().reference()
        firebaseRef.child("teams").child(tid).child("roster").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for v in value! {
                var key = v.key as! String
                var val = v.value as! NSDictionary
                self.roster[key] = val
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        guard recognizer.view != nil else {return}
        let player = recognizer.view!
        let translation = recognizer.translation(in: player.superview)
        
        if recognizer.state == .began {
            self.panStartPoint = player.center
        }
        if recognizer.state == .ended {
            self.panEndPoint = CGPoint(x: panStartPoint.x + translation.x, y: panStartPoint.y + translation.y)
            determineAction(startIndex: determineBoxIndex(point: self.panStartPoint), endingIndex: determineBoxIndex(point: self.panEndPoint))
        }
        if recognizer.state == .cancelled {print("cancel")}
    }
    
    func determineBoxIndex(point: CGPoint) -> Int {
        var i: Int = 0
        for rect in boxRects {
            if rect.contains(point){ return i }
            else{ i += 1 }
        }
        return 999
    }
    
    func determineAction(startIndex: Int, endingIndex: Int){
        if endingIndex == 0 {
            handleLayup(playerIndex: startIndex)
        }
        else if endingIndex != 999 {
            handlePass(passingPlayerIndex: startIndex, receivingPlayerIndex: endingIndex)
        }
    }
    
    func handleLayup(playerIndex: Int){
        //print(self.lineup[playerIndex] + " made a layup!")
        displayLayupChart()
    }
    
    @IBAction func handleShot(_ recognizer: UITapGestureRecognizer) {
        //print(self.lineup[ballIndex] + " shot the ball!")
        displayShotChart()
    }
    
    func handlePass(passingPlayerIndex: Int, receivingPlayerIndex: Int){
        //print(self.lineup[passingPlayerIndex] + " passed to " + self.lineup[receivingPlayerIndex])
        ballIndex = receivingPlayerIndex
    }
    
    func displayShotChart(){
        self.performSegue(withIdentifier: "shotChartSegue", sender: nil)
    }
    
    func displayLayupChart(){
        
    }
    
    func handleTurnover(){
        
    }
    
    func handleJumpBall(){
        
    }
    
    func handleFoul(){
        
    }
    
    func subPlayer(index: Int, point: CGPoint){
        let ac = UIAlertController(title: "Offensive Options", message: "", preferredStyle: .actionSheet)
        var btn: UIAlertAction
        for player in roster{
            let dict = player.value as! NSDictionary
            if (!isActive(pid: dict["pid"] as! String)){
                let fname = dict["fname"] as! String
                let lname = dict["lname"] as! String
                let pid = dict["pid"] as! String
                btn = UIAlertAction(title: "\(fname) \(lname)", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.active[index - 1] = pid
                    
                }
                ac.addAction(btn)
            }
        }
        let popover = ac.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect.init(origin: CGPoint.init(x: point.x, y: point.y + 50), size: CGSize.init())
        present(ac, animated: true)
    }
    
    func isActive(pid: String) -> Bool{
        for player in active {
            if (player == pid){
                return true
            }
        }
        return false
    }
    
    @IBAction func handleLongPress(_ touchHandler: UILongPressGestureRecognizer) {
        let point = touchHandler.location(in: self.courtView)
        let index = determineBoxIndex(point: point)
        //let player = self.lineup[index]
        if touchHandler.state == .began {
            presentOffensiveOptions(point: point, index: index)
        }
    }
    
    func presentOffensiveOptions(point: CGPoint, index: Int){
        let ac = UIAlertController(title: "Offensive Options", message: "", preferredStyle: .actionSheet)
        let turnoverBtn = UIAlertAction(title: "Turnover", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.handleTurnover()
        }
        let foulBtn = UIAlertAction(title: "Foul", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.handleFoul()
        }
        let jumpBallBtn = UIAlertAction(title: "Jump Ball", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.handleJumpBall()
        }
        let subPlayerBtn = UIAlertAction(title: "Sub", style: UIAlertActionStyle.default) {
            UIAlertAction in
            //print(self.imagePlayer1.image.)
            self.subPlayer(index: index, point: point)
        }
        if (active[index - 1] != nil){
            ac.addAction(turnoverBtn)
            ac.addAction(foulBtn)
            ac.addAction(jumpBallBtn)
        }
        ac.addAction(subPlayerBtn)
        let popover = ac.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect.init(origin: CGPoint.init(x: point.x, y: point.y + 50), size: CGSize.init())
        present(ac, animated: true)
    }
    
}
