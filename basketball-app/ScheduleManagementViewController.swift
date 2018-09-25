//
//  ScheduleManagementViewController.swift
//  basketball-app
//
//  Created by Maggie Zhang on 9/24/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import EventKit

var gameTitle: [String] = []

class ScheduleManagementViewController: UITableViewController{
    @IBOutlet var GameTableView: UITableView!
    
    var games: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameTableView.delegate = self
        GameTableView.dataSource = self
    }
    
    func appendEvents(inputTitle: String, inputDetail: String){
        let tempGame = Game(title: inputTitle, detail: inputDetail)
        games.append(tempGame)
        
        //let currentPath = IndexPath(row:self.games.count, section: 0)
        //GameTableView.beginUpdates()
        //GameTableView.insertRows(at: [currentPath], with: .automatic)
        //GameTableView.endUpdates()
        
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
    
    @IBAction func AddEvent(_ sender: UIButton) {
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                for titles in gameTitle{
                event.title = titles
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "Basketball game"
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
