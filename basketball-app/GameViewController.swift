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
    
    var lineup : [String] = ["", "Kyrie", "JR", "LeBron", "Tristan", "Kevin"]
    var panStartPoint = CGPoint() //coordinates of pan start
    var panEndPoint = CGPoint() //coordinates of pan end
    var boxHeight : CGFloat = 100.0
    var boxWidth : CGFloat = 100.0
    var boxRects : [CGRect] = [CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init()] //[0] = hoop, [1] = PG, [2] = SG, [3] = SF, [4] = PF, [5] = C
    
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
            handleShot(playerIndex: startIndex)
        }
        else if endingIndex != 999 {
            handlePass(passingPlayerIndex: startIndex, receivingPlayerIndex: endingIndex)
        }
    }
    
    func handleShot(playerIndex: Int){
        print(self.lineup[playerIndex] + " shot the ball!")
        displayShotChart()
        
    }
    
    func handlePass(passingPlayerIndex: Int, receivingPlayerIndex: Int){
        print(self.lineup[passingPlayerIndex] + " passed to " + self.lineup[receivingPlayerIndex])
        
    }
    
    func displayShotChart(){
        
        let ac = UIAlertController(title: "Shot Result?", message: "", preferredStyle: .actionSheet)
        let madeBtn = UIAlertAction(title: "Made", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("made")
            self.performSegue(withIdentifier: "shotChartSegue", sender: nil)
        }
        let missedBtn = UIAlertAction(title: "Missed", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("missed")
            self.performSegue(withIdentifier: "shotChartSegue", sender: nil)
        }
        ac.addAction(madeBtn)
        ac.addAction(missedBtn)
        let popover = ac.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = self.boxRects[0]
        present(ac, animated: true)
    }
}
