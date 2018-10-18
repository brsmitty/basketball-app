//
//  ShotChartViewController.swift
//  basketball-app
//
//  Created by David on 10/12/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class ShotChartViewController: UIViewController {
    
    var test: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(test)
    }
    
    @IBOutlet weak var chartView: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: chartView)
            saveShotLocation(position: position)
        }
    }
    
    func saveShotLocation(position: CGPoint){
        let popupForShotOutcome = UIAlertController(title: "Shot Outcome", message: "", preferredStyle: .actionSheet)
        let madeShot = UIAlertAction(title: "Made", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print(position.x)
            print(position.y)
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "backToGameViewSegue", sender: nil)
        }
        let missedShot = UIAlertAction(title: "Missed", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print(position.x)
            print(position.y)
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "backToGameViewSegue", sender: nil)
        }
        popupForShotOutcome.addAction(madeShot)
        popupForShotOutcome.addAction(missedShot)
        let popover = popupForShotOutcome.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect.init(origin: position, size: CGSize.init())
        present(popupForShotOutcome, animated: true)
    }
    
    
}
