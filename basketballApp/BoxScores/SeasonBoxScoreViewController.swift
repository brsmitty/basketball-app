//
//  SeasonBoxScoreViewController.swift
//  basketballApp
//
//  Created by Hesham Hussain on 11/18/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//

import UIKit

class SeasonBoxScoreViewController: UIViewController , UITableViewDataSource, UITableViewDelegate  {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var players = [Player]()
    var opponentTeam: String = "Team2"
    @IBOutlet weak var boxScoreTitle: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonBoxScoreCell", for: indexPath) as? SeasonBoxScoreTableViewCell else {
            fatalError("The deqeued cell is not an instance of Player SeasonBoxScoreCell")
        }
        print("Boxscore CELL: \(cell)")
        let player = players[indexPath.row]
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = BoxScoreViewController.LightGrayBackground
        }
        cell.playerName.text = player.lastName + ", " + player.firstName.prefix(1) + "."
        DBApi.sharedInstance.listenToPlayerSeasonStat(pid: player.playerId){ snapshot in
            let statsDict = snapshot.dictionaryWithValues(forKeys: ["pid"])
            //Incomplete
            cell.totalPoints.text = (statsDict[KPIKeys.points.rawValue] as? NSNumber)?.stringValue
            cell.charges.text = (statsDict[KPIKeys.charges.rawValue] as? NSNumber)?.stringValue
            cell.threePointers.text = ((statsDict[KPIKeys.threePointerstMade.rawValue] as? NSNumber)?.stringValue ?? "0") + "-" + ((statsDict[KPIKeys.threePointersAttempted.rawValue] as? NSNumber)?.stringValue ?? "0")
            cell.defensiveRebounds.text = (statsDict[KPIKeys.defensiveRebounds.rawValue] as? NSNumber)?.stringValue
            cell.blocks.text = (statsDict[KPIKeys.blocks.rawValue] as? NSNumber)?.stringValue
            cell.fieldGoals.text = (statsDict[KPIKeys.points.rawValue] as? NSNumber)?.stringValue
            cell.freeThrows.text = (statsDict[KPIKeys.foulShotsMade.rawValue] as? NSNumber)?.stringValue
            cell.offensiveRebounds.text = (statsDict[KPIKeys.offensiveRebounds.rawValue] as? NSNumber)?.stringValue
            cell.personalFouls.text = (statsDict[KPIKeys.personalFouls.rawValue] as? NSNumber)?.stringValue
            cell.steals.text = (statsDict[KPIKeys.steals.rawValue] as? NSNumber)?.stringValue
            cell.twoPointers.text = ((statsDict[KPIKeys.twoPointersMade.rawValue] as? NSNumber)?.stringValue ?? "0") + "-" + ((statsDict[KPIKeys.twoPointersAttempted.rawValue] as? NSNumber)?.stringValue ?? "0")
        }
        return cell
    }
    
    //number of groupings in the table that show up
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: Load Players
    private func loadPlayers() {
        DBApi.sharedInstance.getPlayers{ [weak self] players in
            //print("Load Players")
            guard let s = self else { return }
            s.players = players
            s.tableView.reloadData()
        }
    }
    
    //MARK: Actions
    @IBAction func share(_ sender: Any) {
        let firstActivityItem = "Text you want"
        let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
        // If you want to put an image
        //let image : UIImage = UIImage(named: "image.jpg")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.excludedActivityTypes = [
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.copyToPasteboard
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
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
        self.boxScoreTitle.text = UserDefaults.standard.string(forKey: "tid")! + " vs " + self.opponentTeam
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
        dismiss(animated: true, completion: nil)
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
            if let dest = segue.destination as? BoxScoreViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "mainMenu" {
            if let dest = segue.destination as? TeamSummaryViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
    }

}
