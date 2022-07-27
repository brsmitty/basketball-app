//
//  AdminSettingsViewController.swift
//  basketballApp
//
//  Created by Alex Jacobs on 4/15/20.
//  Copyright © 2020 David Zucco. All rights reserved.
//

import UIKit
/**
 Controls the admin settings view
    - inherits from UIViewController
    - defines back button
 */
class AdminSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**
     for the back button on the admin settings page
     */
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: false, completion: nil)
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
