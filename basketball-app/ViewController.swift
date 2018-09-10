//
//  ViewController.swift
//  basketball-app
//
//  Created by David on 9/5/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

   @IBOutlet weak var playerIconView: UIImageView!
   @IBOutlet weak var playerStatsView: UICollectionView!
   @IBOutlet weak var addPlayerBtn: UIButton!
   @IBOutlet weak var tableView: UITableView!
   // setup an array that holds all the players
   var players:[Player] = [Player]()
   var myIndex = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
      // load all the players from firebase
      self.players = PlayerModel().getPlayers()
      
      // setup the tableView for the different players
      self.tableView.dataSource = self
      self.tableView.delegate = self
      
      // setup the collection view to show player stats
      self.playerStatsView.dataSource = self
      self.playerStatsView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      let playerItemCount = 22
      return playerItemCount
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      // grab a cell from the collection view and cast it to a PlayerCollectionViewCell (for the text field)
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "position", for: indexPath) as! PlayerCollectionViewCell
      
      // grab the selected player from the table view and grab the position string from it
      let playerPosition = players[myIndex].position
      
      // put the player position in the text field of the view
      cell.positionCell.textLabel?.text = playerPosition
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      myIndex = indexPath.row
      updatePlayerFields(playerStatsView, indexPath)
   }
   
   func updatePlayerFields(_ collectionView: UICollectionView, _ indexPath: IndexPath){
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "position", for: indexPath) as! PlayerCollectionViewCell
      
      let playerPosition = players[myIndex].position
      
      cell.positionCell.textLabel?.text = playerPosition
      
      var updatePaths:[IndexPath] = [IndexPath]()
      var path = IndexPath.init()
      let element = IndexPath.Element(0)
      path.append(element)
      
      updatePaths.append(path)
      
      collectionView.reloadItems(at: updatePaths)
      
   }
   @IBAction func addPlayer(_ sender: UIButton) {
      
   }
   
}

