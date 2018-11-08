//
//  BenchViewController.swift
//  basketball-app
//
//  Created by Mike White on 11/7/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

protocol SlideBenchDelegate{
   func slideBenchSelectedAtIndex(_ index: Int32)
}

class BenchViewController: UIViewController {
   
   var benchButton: UIButton!
   var delegate: SlideBenchDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
