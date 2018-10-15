//
//  PlaybookViewController.swift
//  basketball-app
//
//  Created by Maggie Zhang on 10/3/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

var storedPlaybooks : [String] = []
var fileNames : [String] = []


class PlaybookViewController: UITableViewController, PlaybookCellDelegate{
    func viewPdf(titleText: String) {
        let temp = fileNames[storedPlaybooks.index(of: titleText)!]
        if let url = Bundle.main.url(forResource: temp, withExtension: "pdf"){
            let webview = UIWebView(frame: self.view.frame)
            let urlRequest = URLRequest(url: url)
            webview.loadRequest(urlRequest as URLRequest)
            
            let pdfVC = UIViewController()
            pdfVC.view.addSubview(webview)
            pdfVC.title = temp
            self.navigationController?.pushViewController(pdfVC, animated: true)
        }
    }
    
    
    @IBOutlet var PlaybookTableView: UITableView!
    var playbooks: [Playbook] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlaybookTableView.delegate = self
        PlaybookTableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playbooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playbook = playbooks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaybookCell") as! PlaybookCell
        cell.setGame(playbook: playbook)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            playbooks.remove(at: indexPath.row)
            storedPlaybooks.remove(at: indexPath.row)
            fileNames.remove(at: indexPath.row)
            PlaybookTableView.beginUpdates()
            PlaybookTableView.deleteRows(at: [indexPath], with: .automatic)
            PlaybookTableView.endUpdates()
        }
        
    }
    
    @IBAction func unwindToPlaybookList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PlaybookDetailViewController, let fileName = sourceViewController.fileName, let playbook = sourceViewController.playbook{
                storedPlaybooks.append(playbook)
                fileNames.append(fileName)
            
            let newIndexPath = IndexPath(row: playbooks.count, section: 0)
            let temp = Playbook(title: playbook)
            playbooks.append(temp)
            PlaybookTableView.insertRows(at: [newIndexPath], with: .automatic)
            
        }
        
    }
    
}
