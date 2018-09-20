//
//  PlaybookManageViewController.swift
//  basketball-app
//
//  Created by Maggie Zhang on 9/20/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import Foundation
import UIKit

class PlaybookManageViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OpenPdfButton(_ sender: UIButton) {
        let url = Bundle.main.url(forResource: "Playbook", withExtension: "pdf")
        let webView = UIWebView(frame: self.view.frame)
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest as URLRequest)
        self.view.addSubview(webView)
        
        
    }
    
}
