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
        print("shot recorded at: ")
        print(position.x)
        print(position.y)
        self.performSegue(withIdentifier: "backToGameViewSegue", sender: nil)
    }
    
    
}
