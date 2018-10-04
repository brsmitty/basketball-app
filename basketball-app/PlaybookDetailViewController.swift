//
//  PlaybookDetailViewController.swift
//  basketball-app
//
//  Created by Maggie Zhang on 10/3/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class PlaybookDetailViewController: UIViewController{
    
    @IBOutlet weak var PlaybookName: UITextField!
    @IBOutlet weak var FileName: UITextField!
    
    var playbook : String?
    var fileName : String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        playbook = PlaybookName.text!
        fileName = FileName.text!
    }
}
