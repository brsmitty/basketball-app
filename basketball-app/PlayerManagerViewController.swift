//
//  PlayerManagerViewController.swift
//  basketball-app
//
//  Created by Mike White on 9/10/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class PlayerManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   // MARK: Properties
   @IBOutlet weak var tableView: UITableView!
   // setup an array that holds all the players
   var players:[Player] = [Player]()
   var myIndex = 0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // setup the tableView for the different players
      self.tableView.dataSource = self
      self.tableView.delegate = self

   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   override func viewWillAppear(_ animated: Bool) {
      // load all the players from firebase
      self.players = PlayerModel().getPlayers()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      // Store the new players in firebase
   }
   
   // MARK: UITableViewDelegate
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return players.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // grab the cell from the table view
      let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell")!
      
      // get the player name from the array
      let playerName = players[indexPath.row].firstName + " " + players[indexPath.row].lastName
      
      // put the player name in the text field of the view
      cell.textLabel?.text = playerName
      
      return cell
   }
   
   
}

