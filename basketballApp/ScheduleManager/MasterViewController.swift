//
//  MasterViewController.swift
//  basketball-app
//
//  Created by Maggie Zhang on 9/27/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import EventKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

/** Handles all interactions with scheduling games*/

class MasterViewController: UITableViewController{
    @IBOutlet var GameTableView: UITableView!
    
   @IBOutlet weak var barNav: UINavigationItem!
   @IBOutlet var addButton: UIBarButtonItem!
   var games: [Game] = []
    var titleSender : String?
    // holds the player reference to firebase
    var playRef:DatabaseReference?
    // holds the database reference to firebase
    var databaseHandle:DatabaseHandle?
    // holds the users unique user ID
    var uid: String = ""
    var tid: String = ""
   
   var gameTitles: [String] = []
   var gameDates: [Date] = []
   var gameTimes: [String] = []
   var gameLocations: [String] = []
   var gameTypes: [String] = []
   var gameDetails : [String] = []
   var synced : [Bool] = []
   
   let eventStore : EKEventStore = EKEventStore()
 
   @IBOutlet weak var syncButton: UIBarButtonItem!
   
    override func viewWillAppear(_ animated: Bool) {
        // Get the user id and set it to the user id global variable
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let uId = user?.uid else {return}
                self.uid = uId
            }
        }
      
      syncButton.setTitleTextAttributes([
         NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 18.0)!,
         NSAttributedStringKey.foregroundColor: UIColor.blue],
                                        for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Store the new players in firebase
        playRef?.removeObserver(withHandle: databaseHandle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameTableView.delegate = self
        GameTableView.dataSource = self
    }
    
    func appendEvents(inputTitle: String, inputDetail: String){
        let tempGame = Game(title: inputTitle, detail: inputDetail)
        games.append(tempGame)
        
        
    }
    
    func gameIsUsers(_ gid:String)-> Bool{
        var isUsers = false
        
        let gameId = gid.prefix(28)
        isUsers = gameId == uid
        
        return isUsers
    }
    
   
   func insertGameInTableView(_ temp: Game){
      let currentPath = IndexPath(row:self.games.count, section: 0)
      self.games.append(temp)
      self.tableView.beginUpdates()
      self.tableView.insertRows(at: [currentPath], with: .automatic)
      self.tableView.endUpdates()
   }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameCell
        cell.setGame(game: game)
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "MM/dd/yyyy"
            let stringDate = dataFormatter.string(from: gameDates[indexPath.row])
            let pid = uid + "-" + stringDate
            let ref = Database.database().reference(withPath: "games")
            ref.child(pid).removeValue()
            //FireRoot.root.
            games.remove(at: indexPath.row)
            gameDates.remove(at: indexPath.row)
            gameTypes.remove(at: indexPath.row)
            gameLocations.remove(at: indexPath.row)
            gameTitles.remove(at: indexPath.row)
            gameTimes.remove(at: indexPath.row)
            gameDetails.remove(at: indexPath.row)
            synced.remove(at: indexPath.row)
            
            GameTableView.beginUpdates()
            GameTableView.deleteRows(at: [indexPath], with: .automatic)
            GameTableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        VC?.getTitle = gameTitles[indexPath.row]
        VC?.getTypes = gameTypes[indexPath.row]
        VC?.getLocations = gameLocations[indexPath.row]
        VC?.getDate = gameDates[indexPath.row]
        VC?.getDetail = gameDetails[indexPath.row]
        VC?.getTime = gameTimes[indexPath.row]
        
        self.showDetailViewController(VC!, sender: Any?.self)
    }
    
    //MARK: CREATING A GAME USEFUL!!
    @IBAction func unwindToGameList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let game = sourceViewController.game, let date = sourceViewController.gameDate, let title = sourceViewController.gameTitle, let location = sourceViewController.location, let gameType = sourceViewController.gameType, let gameTime = sourceViewController.gameTime, let gameDetail = sourceViewController.gameDetail {
            
            print("Masterrr")
            // Add a new game.
            gameDates.append(date)
            gameTitles.append(title)
            gameLocations.append(location)
            gameTypes.append(gameType)
            gameDetails.append(gameDetail)
            gameTimes.append(gameTime)
            synced.append(false)
            
            let newIndexPath = IndexPath(row: games.count, section: 0)
            games.append(game)
            GameTableView.insertRows(at: [newIndexPath], with: .automatic)
            
            
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "MM/dd/yyyy"
            let stringDate = dataFormatter.string(from: date)
            
            let playData : [String: Any] = ["title": title,
                                              "location": location,
                                              "gameType": gameType,
                                              "gameDate": stringDate,
                                              "gameTime": gameTime,
                                              "gameDetail": gameDetail]
           // DBApi.sharedInstance.createGames(info: playData)
        }
    
    }
    
    @IBAction func AddEvent(_ sender: UIButton) {
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                
               let event:EKEvent = EKEvent(eventStore: self.eventStore)
                
               for titles in self.gameTitles{
                  if(self.synced[self.gameTitles.index(of: titles)!] == false){
                    event.title = titles
                     event.location = self.gameLocations[self.gameTitles.index(of: titles)!]
                     event.startDate = self.gameDates[self.gameTitles.index(of: titles)!]
                     event.endDate = self.gameDates[self.gameTitles.index(of: titles)!]
                     event.notes = self.gameTypes[self.gameTitles.index(of: titles)!] + "\n" + self.gameDetails[self.gameTitles.index(of: titles)!]
                     event.calendar = self.eventStore.defaultCalendarForNewEvents
                    do {
                     try self.eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                     self.synced[self.gameTitles.index(of: titles)!] = true
                    print("Saved Event")
                }
                }
            }
            else{
                print("failed to save event with errorString(describing: error)")
            }
        }
    }
}

