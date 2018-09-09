//
//  ViewController.swift
//  basketball-app
//
//  Created by David on 9/5/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


   @IBOutlet weak var tableView: UITableView!
   var players:[Player] = [Player]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
      self.players = PlayerModel().getPlayers()
      
      self.tableView.dataSource = self
      self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return players.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell")!
      
      let playerName = players[indexPath.row].firstName + " " + players[indexPath.row].lastName
      
      cell.textLabel?.text = playerName
      
      return cell
   }
   
}

