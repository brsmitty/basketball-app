//
//  MasterViewController.swift
//  basketball-app
//
//  Created by Maggie Zhang on 9/27/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import EventKit

var gameTitles: [String] = []
var gameDates: [Date] = []
var gameTimes: [Date] = []
var gameLocations: [String] = []
var gameTypes: [String] = []

class MasterViewController: UITableViewController{
    @IBOutlet var GameTableView: UITableView!
    
    var games: [Game] = []
    var titleSender : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameTableView.delegate = self
        GameTableView.dataSource = self
    }
    
    func appendEvents(inputTitle: String, inputDetail: String){
        let tempGame = Game(title: inputTitle, detail: inputDetail)
        games.append(tempGame)
        
        
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
            games.remove(at: indexPath.row)
            gameDates.remove(at: indexPath.row)
            gameTypes.remove(at: indexPath.row)
            gameLocations.remove(at: indexPath.row)
            gameTitles.remove(at: indexPath.row)
            
            GameTableView.beginUpdates()
            GameTableView.deleteRows(at: [indexPath], with: .automatic)
            GameTableView.endUpdates()
        }
    }
    
    @IBAction func unwindToGameList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let game = sourceViewController.game, let date = sourceViewController.gameDate, let title = sourceViewController.gameTitle, let location = sourceViewController.location, let gameType = sourceViewController.gameType {
            
            // Add a new game.
            gameDates.append(date)
            gameTitles.append(title)
            gameLocations.append(location)
            gameTypes.append(gameType)
            
            let newIndexPath = IndexPath(row: games.count, section: 0)
            games.append(game)
            GameTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    
    @IBAction func AddEvent(_ sender: UIButton) {
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                for titles in gameTitles{
                    event.title = titles
                    event.startDate = gameDates[gameTitles.index(of: titles)!]
                    event.endDate = gameDates[gameTitles.index(of: titles)!]
                    event.notes = gameLocations[gameTitles.index(of: titles)!] + ", " + gameTypes[gameTitles.index(of: titles)!]
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    print("Saved Event")
                }
            }
            else{
                print("failed to save event with errorString(describing: error)")
            }
        }
    }
}

