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
        cell.playerName.text = "-" + player.lastName + ", " + player.firstName.prefix(1) + "."
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup the tableView for the different players
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadPlayers()

        // Do any additional setup after loading the view.
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
