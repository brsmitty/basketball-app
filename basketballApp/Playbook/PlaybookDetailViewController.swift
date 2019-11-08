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
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var fileLabel: UILabel!
   
    @IBOutlet weak var addButton: UIButton!
    var playbook : String?
    var fileName : String?
   
    override func viewDidLoad() {
      super.viewDidLoad()
      
      addButton.layer.cornerRadius = 5
      FileName.layer.cornerRadius = 5
      PlaybookName.layer.cornerRadius = 5
      
        let tapGesture = UITapGestureRecognizer(target: self, action:             #selector(ViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        super.prepare(for: segue, sender: sender)
        
        playbook = PlaybookName.text!
        fileName = FileName.text!
    }
   
   @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
      view.endEditing(true)
   }
}
