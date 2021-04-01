//
//  kpiViewController.swift
//  basketball-app
//
//  Created by Mike White on 11/7/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class BoxScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: Properties
    static let LightGrayBackground = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
    @IBOutlet weak var tableView: UITableView!
    
    var players = [Player]()
    var opponentTeam: String = "Team2"
    @IBOutlet weak var boxScoreTitle: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerKPITableViewCell", for: indexPath) as? BoxScoreTableViewCell else {
            fatalError("The deqeued cell is not an instance of Player KPITableViewCell")
        }
        //boxScoreTitle.textColor = UIColor.white
        cell.textLabel?.textColor = UIColor.white

        print("Boxscore CELL: \(cell)")
        let player = players[indexPath.row]
//        if indexPath.row % 2 == 0 {
            cell.backgroundColor = BoxScoreViewController.LightGrayBackground
//        }
        cell.playerName.text = player.lastName + ", " + player.firstName.prefix(1) + "."
        cell.playerName.textColor = UIColor.white
        cell.totalPoints.textColor = UIColor.white
        cell.charges.textColor = UIColor.white
        cell.threePointers.textColor = UIColor.white
        cell.defensiveRebounds.textColor = UIColor.white
        cell.blocks.textColor = UIColor.white
        cell.fieldGoals.textColor = UIColor.white
        cell.freeThrows.textColor = UIColor.white
        cell.offensiveRebounds.textColor = UIColor.white
        cell.personalFouls.textColor = UIColor.white
        cell.steals.textColor = UIColor.white
        cell.twoPointers.textColor = UIColor.white
        cell.minutesPlayed.textColor = UIColor.white
        cell.rebounds.textColor = UIColor.white
        cell.turnovers.textColor = UIColor.white
        cell.plusMinus.textColor = UIColor.white
        cell.playerEffeciencyRating.textColor = UIColor.white

        DBApi.sharedInstance.listenToPlayerStat(pid: player.playerId){ snapshot in
            let statsDict = snapshot.data() ?? [:]
            //Incomplete
            cell.totalPoints.text = (statsDict[KPIKeys.points.rawValue] as? NSNumber)?.stringValue ?? "0"
            cell.charges.text = (statsDict[KPIKeys.charges.rawValue] as? NSNumber)?.stringValue ?? "0"
            cell.threePointers.text = ((statsDict[KPIKeys.threePointerstMade.rawValue] as? NSNumber)?.stringValue ?? "0") + "-" + ((statsDict[KPIKeys.threePointersAttempted.rawValue] as? NSNumber)?.stringValue ?? "0")
            cell.defensiveRebounds.text = (statsDict[KPIKeys.defensiveRebounds.rawValue] as? NSNumber)?.stringValue ?? "0"
            cell.blocks.text = (statsDict[KPIKeys.blocks.rawValue] as? NSNumber)?.stringValue ?? "0"
            cell.fieldGoals.text = (statsDict[KPIKeys.points.rawValue] as? NSNumber)?.stringValue ?? "0"
            cell.freeThrows.text = (statsDict[KPIKeys.foulShotsMade.rawValue] as? NSNumber)?.stringValue ?? "0"
            cell.offensiveRebounds.text = (statsDict[KPIKeys.offensiveRebounds.rawValue] as? NSNumber)?.stringValue ?? "0"
            cell.personalFouls.text = (statsDict[KPIKeys.personalFouls.rawValue] as? NSNumber)?.stringValue ?? "0"
            cell.steals.text = (statsDict[KPIKeys.steals.rawValue] as? NSNumber)?.stringValue ?? "0"
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
        self.view.backgroundColor = UIColor.black
        tableView.backgroundColor = UIColor.clear

        UILabel.appearance().textColor = UIColor.white

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
