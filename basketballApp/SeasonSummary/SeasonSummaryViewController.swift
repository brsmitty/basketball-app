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
    @IBOutlet weak var left3ptLabel: UILabel!
    
    @IBOutlet weak var left2ptLabel: UILabel!
    @IBOutlet weak var left2ptImage: UIImageView!
    
    
    @IBOutlet weak var freeThrowImage: UIImageView!
    @IBOutlet weak var freeThrowLabel: UILabel!
    
    
    @IBOutlet weak var pastFreeThrowImage: UIImageView!
    @IBOutlet weak var pastFreeThrowLabel: UILabel!
    
    
    @IBOutlet weak var right2ptImage: UIImageView!
    @IBOutlet weak var right2ptLabel: UILabel!
    
    @IBOutlet weak var right3ptImage: UIImageView!
    @IBOutlet weak var right3ptLabel: UILabel!
    
    
    @IBOutlet weak var one: UIView!
    @IBOutlet weak var two: UIView!
    @IBOutlet weak var three: UIView!
    @IBOutlet weak var four: UIView!
    @IBOutlet weak var five: UIView!
    @IBOutlet weak var six: UIView!
    @IBOutlet weak var seven: UIView!
    @IBOutlet weak var eight: UIView!
    @IBOutlet weak var tableViewWrapper: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonPlayerMetricsCell", for: indexPath) as? SeasonPlayerMetricsTableViewCell else {
            fatalError("The deqeued cell is not an instance of Player KPITableViewCell")
        }
//        if indexPath.row % 2 == 0 {
//            cell.backgroundColor = BoxScoreViewController.LightGrayBackground
//        }
        let player = players[indexPath.row]
        print("Player \(player.playerId)")
        cell.playerName.text = player.lastName + ", " + player.firstName.prefix(1) + "."
        let OREB = Int.random(in: 2...15)
        let OREBgoal = 10
        
        let TOP = Int.random(in: 2...15)
        let TOPgoal = 10
        
        let EFG = Int.random(in: 54...78)
        let EFGgoal = 60
        
        let FTP = Int.random(in: 50...100)
        let FTPgoal = 75
        
        if(EFG<EFGgoal - 3)
        {
            cell.totalPoints.textColor = UIColor.red
        }
        if(EFG>EFGgoal + 5)
        {
            cell.totalPoints.textColor = UIColor.green
        }
        cell.totalPoints.text = String(EFG) + "%"
        
        if(FTP<FTPgoal - 5)
        {
            cell.threePointers.textColor = UIColor.red
        }
        if(FTP>FTPgoal + 5)
        {
            cell.threePointers.textColor = UIColor.green
        }
        cell.threePointers.text = String(FTP) + "%"
        
        if(OREB<OREBgoal - 1)
        {
            cell.twoPointers.textColor = UIColor.red
        }
        if(OREB>OREBgoal + 2)
        {
            cell.twoPointers.textColor = UIColor.green
        }
        cell.twoPointers.text = String(OREB) + "%"
        
        if(TOP<TOPgoal - 1)
        {
            cell.minutesPlayed.textColor = UIColor.red
        }
        if(TOP>TOPgoal + 2)
        {
            cell.minutesPlayed.textColor = UIColor.green
        }
        cell.minutesPlayed.text = String(TOP) + "%"
        
        DBApi.sharedInstance.listenToPlayerSeasonStat(pid: player.playerId){ snapshot in
            let statsDict = snapshot.data() ?? [:]
            //Needs minutesPlayed and plusminus
            //cell.totalPoints.text = (statsDict[KPIKeys.points.rawValue] as? NSNumber)?.stringValue
            //cell.threePointers.text = ((statsDict[KPIKeys.threePointerstMade.rawValue] as? NSNumber)?.stringValue ?? "1") + "-" + ((statsDict[KPIKeys.threePointersAttempted.rawValue] as? NSNumber)?.stringValue ?? "0")
            //cell.twoPointers.text = ((statsDict[KPIKeys.twoPointersMade.rawValue] as? NSNumber)?.stringValue ?? "0") + "-" + ((statsDict[KPIKeys.twoPointersAttempted.rawValue] as? NSNumber)?.stringValue ?? "0")
        }
        return cell
    }
    

    var shotChartBounds: CGRect = CGRect()
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black
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
        
        setHeatMapView(view: one)
        setHeatMapView(view: two)
        setHeatMapView(view: three)
        setHeatMapView(view: four)
        setHeatMapView(view: five)
        setHeatMapView(view: six)
        setHeatMapView(view: seven)
        setHeatMapView(view: eight)
        setAccuracyLabels()

        
    }
    private func setDefaultViewStyle(view: UIView){
        view.layer.borderWidth = 0.0
        view.layer.cornerRadius = 10.0
        view.layer.borderColor = TeamSummaryViewController.borderColor
        //view.layer.borderColor = CGColor
        view.backgroundColor = UIColor.clear
    }
    
    private func setHeatMapTintColors(view: UIImageView){
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.image = view.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        view.tintColor = UIColor(red: 255, green: 0, blue: 0.2, alpha: 1)
    }
    
    private func setAccuracyLabels(){
        
        setLabel(view: one, set: randomPercent())
        setLabel(view: two, set: randomPercent())
        setLabel(view: three, set: randomPercent())
        setLabel(view: four, set: randomPercent())
        setLabel(view: five, set: randomPercent())
        setLabel(view: six, set: randomPercent())
        setLabel(view: seven, set: randomPercent())
        setLabel(view: eight, set: randomPercent())
        
        setLabelForImage(image: left3ptImage, label: left3ptLabel)
        setLabelForImage(image: left2ptImage, label: left2ptLabel)
        setLabelForImage(image: freeThrowImage, label: freeThrowLabel)
        setLabelForImage(image: pastFreeThrowImage, label: pastFreeThrowLabel)
        setLabelForImage(image: right2ptImage, label: right2ptLabel)
        setLabelForImage(image: right3ptImage, label: right3ptLabel)
        
    }
    
    private func setLabelForImage(image: UIImageView, label: UILabel){
        let random = randomPercent()
        let asFloat = CGFloat(random)
        label.text = String(random) + "%"
        image.tintColor = UIColor(red: 0, green: 0, blue: 0.2, alpha: asFloat/100)
    }
    
    private func setLabel(view: UIView, set: Int){
        for subview in view.subviews{
            if let label = subview as? UILabel{
                label.text = String(set) + "%"
            }
        }
        let asFloat = CGFloat(set)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0.2, alpha: asFloat/100)
    }
    
    private func randomPercent() -> Int{
        return Int.random(in: 30...100)
    }
    
    private func setHeatMapView(view: UIView){
        view.backgroundColor = UIColor(red: 120, green: 0, blue: 0.2, alpha: 1)
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
    
    @IBAction func demoShading(_ sender: Any) {
        setAccuracyLabels()
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
