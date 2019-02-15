//
//  DBApi.swift
//  basketballApp
//
//  Created by Sean O'Donnell on 2/13/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//

import Foundation
import Firebase

enum Statistic: String {
    case score = "score"
    case rebound = "rebound"
    // etc...
}

class DBApi {
    static let sharedInstance = DBApi()
    let ref = Database.database().reference()
    var currentUserId: String = ""
    var currentGameId: String = ""
    
    var pathToPlayers: String {
        return "users/\(currentUserId)/players"
    }
    
    var pathToGames: String {
        return "users/\(currentUserId)/games"
    }
    
    var pathtoCurrentGame: String {
        return "users/\(currentUserId)/games/\(currentGameId)"
    }
    
    var pathToTeam: String {
        return "users/\(currentUserId)/team"
    }
    
    func storeStat(type: Statistic, value: Any?, pid: String, time: Double) {
        let refStatsTable = Database.database().reference(withPath: "\(currentUserId)/statistics")
        let newStatId = refStatsTable.childByAutoId().key
        var statistic: [String: Any] = [
            "type": type.rawValue,
            "game_id": currentGameId,
            "player_id": pid,
            "time": time
        ]
        if type == .score, let points = value as? Int {
            statistic.updateValue(points, forKey: "points")
        }
        
        let childUpdates = ["/\(currentUserId)/statistics/\(newStatId)": statistic]
        refStatsTable.updateChildValues(childUpdates)
    }
    
    func createPlayer(info: [String: Any]) {
        let refPlayersTable = Database.database().reference(withPath: pathToPlayers)
        let newPlayerId = refPlayersTable.childByAutoId().key
        let player: [String: Any] = [
            "user_id": currentUserId,
            "fName": info["fname"] as? String ?? "",
            "lName": info["lname"] as? String ?? "",
            "height": info["height"] as? String ?? "",
            "weight": info["weight"] as? String ?? "",
            "rank": info["rank"] as? String ?? "",
            "position": info["position"] as? String ?? ""
        ]
        let childUpdates = ["/\(newPlayerId)": player]
        refPlayersTable.updateChildValues(childUpdates)
    }
    
    func getPlayers(completion: @escaping ([Player]) -> Void) {
        let refPlayersTable = Database.database().reference(withPath: pathToPlayers)
        refPlayersTable.observeSingleEvent(of: .value) { snapshot in
            if snapshot.value is NSNull {
                print("no players in the database!!!")
            }
            var players = [Player]()
            for player in snapshot.children {
                let playerSnap = player as? DataSnapshot
                let pid = playerSnap?.key ?? ""
                let playerDict = playerSnap?.value as? [String: String?] ?? [:]
                players.append(Player(dictionary: playerDict, id: pid))
            }
            completion(players)
        }
    }
}
