//
//  ShotChartViewController.swift
//  basketball-app
//
//  Created by David on 10/12/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class ShotChartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Success: loaded regular shot chart")
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
            print("Success: recorded made shot at x, y coordinates below")
            print(position.x)
            print(position.y)
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "backToGameViewSegue", sender: nil)
        }
        let missedShot = UIAlertAction(title: "Missed", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("Success: recorded missed shot at x, y coordinates below")
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
