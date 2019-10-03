//
//  kpiViewController.swift
//  basketball-app
//
//  Created by Mike White on 11/7/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class kpiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var players = [Player]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerKPITableViewCell", for: indexPath) as? PlayerKPITableViewCell else {
            fatalError("The deqeued cell is not an instance of Player KPITableViewCell")
        }
        let player = players[indexPath.row]
        
        //cell.player.text = player.lastName + ", " + player.firstName
        DBApi.sharedInstance.listenToPlayerStat(pid: player.playerId){ snapshot in
            let playerDict = snapshot.value as? [String: Any] ?? [:]
            print("this is a player")
            print(player.firstName)
            cell.playerName.text = playerDict["fName"] as? String
            print(playerDict["fName"] )
            print(player.firstName)
        }
        
        return cell
    }
    
    //number of groupings in the table that show up
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func loadPlayers() {
        DBApi.sharedInstance.getPlayers{ [weak self] players in
            guard let s = self else { return }
            s.players = players
            for player in players{
                DBApi.sharedInstance.setDefaultPlayerStats(pid: player.playerId)
            }
            s.tableView.reloadData()
        }
    }
    

    var uid: String = ""
    var tid: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup the tableView for the different players
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Do any additional setup after loading the view.
        loadPlayers()
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

   @IBAction func goBack(_ sender: UIButton) {
      dismiss(animated: false, completion: nil)
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "schedule" {
            if let dest = segue.destination as? ScheduleViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "playbook" {
            if let dest = segue.destination as? PlaybookMasterViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "playerManager" {
            if let dest = segue.destination as? PlayerManagerViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "gameView" {
            if let dest = segue.destination as? GameViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "performanceSegue" {
            if let dest = segue.destination as? PerformanceViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "kpiSegue" {
            if let dest = segue.destination as? kpiViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "mainMenu" {
            if let dest = segue.destination as? MiddleViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
    }
}
