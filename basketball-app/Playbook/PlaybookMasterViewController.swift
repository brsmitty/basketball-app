//
//  PlaybookMasterViewController.swift
//  basketball-app
//
//  Created by Mike White on 10/30/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class PlaybookMasterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      // Listen for keyboard events
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
   
   deinit {
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
   }
   
   @objc func keyboardWillChange(notification: Notification){
      
      if notification.name == Notification.Name.UIKeyboardWillChangeFrame || notification.name == Notification.Name.UIKeyboardWillShow{
         
         view.frame.origin.y = -180
      }else {
         view.frame.origin.y = 0
      }
   }



}
