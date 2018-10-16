//
//  ShotChartViewController.swift
//  basketball-app
//
//  Created by David on 10/12/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class LayupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded shot chart")
    }
    
    @IBOutlet weak var chartView: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: chartView)
            saveShotLocation(position: position)
        }
    }
    
    func saveShotLocation(position: CGPoint){
        let ac = UIAlertController(title: "Shot Result?", message: "", preferredStyle: .actionSheet)
        let madeBtn = UIAlertAction(title: "Made", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("made shot recorded at: ")
            print(position.x)
            print(position.y)
            self.performSegue(withIdentifier: "backToGameViewSegue", sender: nil)
        }
        let missedBtn = UIAlertAction(title: "Missed", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("missed shot recorded at: ")
            print(position.x)
            print(position.y)
            self.performSegue(withIdentifier: "backToGameViewSegue", sender: nil)
        }
        ac.addAction(madeBtn)
        ac.addAction(missedBtn)
        let popover = ac.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect.init(origin: position, size: CGSize.init())
        present(ac, animated: true)
    }
    
    
}
