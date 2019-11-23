//
//  SeasonSummaryViewController.swift
//  basketballApp
//
//  Created by Hesham Hussain on 10/16/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//

import UIKit

class SeasonSummaryViewController: UIViewController , UITableViewDataSource, UITableViewDelegate  {
    
    //MARK:Properties
    var players = [Player]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usVsOppsView: UIView!
    @IBOutlet weak var lineChartView: UIView!
    
    
    @IBOutlet weak var left3ptImage: UIImageView!
    
    @IBOutlet weak var left2ptImage: UIImageView!
    @IBOutlet weak var freeThrowImage: UIImageView!
    @IBOutlet weak var pastFreeThrowImage: UIImageView!
    @IBOutlet weak var right2ptImage: UIImageView!
    @IBOutlet weak var right3ptImage: UIImageView!
    
    
    
    
    @IBOutlet weak var tableViewWrapper: UIView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonPlayerMetricsCell", for: indexPath) as? SeasonPlayerMetricsTableViewCell else {
            fatalError("The deqeued cell is not an instance of Player KPITableViewCell")
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = BoxScoreViewController.LightGrayBackground
        }
        let player = players[indexPath.row]
        print("Player \(player.playerId)")
        cell.playerName.text = "-" + player.lastName + ", " + player.firstName.prefix(1) + "."
        DBApi.sharedInstance.listenToPlayerSeasonStat(pid: player.playerId){ snapshot in
            let statsDict = snapshot.data() ?? [:]
            //Needs minutesPlayed and plusminus
            cell.totalPoints.text = (statsDict[KPIKeys.points.rawValue] as? NSNumber)?.stringValue
            cell.threePointers.text = ((statsDict[KPIKeys.threePointerstMade.rawValue] as? NSNumber)?.stringValue ?? "0") + "-" + ((statsDict[KPIKeys.threePointersAttempted.rawValue] as? NSNumber)?.stringValue ?? "0")
            cell.twoPointers.text = ((statsDict[KPIKeys.twoPointersMade.rawValue] as? NSNumber)?.stringValue ?? "0") + "-" + ((statsDict[KPIKeys.twoPointersAttempted.rawValue] as? NSNumber)?.stringValue ?? "0")
        }
        return cell
    }
    

    var shotChartBounds: CGRect = CGRect()
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup the tableView for the different players
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadPlayers()
        
        setDefaultViewStyle(view: tableViewWrapper)
        setDefaultViewStyle(view: usVsOppsView)
        setDefaultViewStyle(view: lineChartView)
        
        setHeatMapTintColors(view: left3ptImage)
        setHeatMapTintColors(view: right3ptImage)
        setHeatMapTintColors(view: left2ptImage)
        setHeatMapTintColors(view: right2ptImage)
        setHeatMapTintColors(view: freeThrowImage)
        setHeatMapTintColors(view: pastFreeThrowImage)
        

        
    }
    private func setDefaultViewStyle(view: UIView){
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 10.0
        view.layer.borderColor = TeamSummaryViewController.borderColor
    }
    
    private func setHeatMapTintColors(view: UIImageView){
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.image = view.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        view.tintColor = UIColor(red: 0, green: 0, blue: 0.2, alpha: 1)
    }
    

    
    //number of groupings in the table that show up
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func loadPlayers() {
        DBApi.sharedInstance.getPlayers{ [weak self] players in
            guard let s = self else { return }
            s.players = players
            s.tableView.reloadData()
        }
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

}
