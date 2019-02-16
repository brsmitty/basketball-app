//
//  DBApi.swift
//  basketballApp
//
//  Created by Sean O'Donnell on 2/13/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//

import Foundation
import Firebase

enum Statistic: Int {
    case score2 = 0
    case score3 = 1
    case score2Attempt = 2
    case score3Attempt = 4
    case freeThrow = 8
    case freeThrowAttempt = 16
    case assist = 32
    case turnover = 64
    case offRebound = 128
    case defRebound = 256
    case steal = 518
    case block = 1024
    case deflection = 2048
    case personalFoul = 4096
    case techFoul = 8192
    case chargeTaken = 16384
}

class DBApi {
    static let sharedInstance = DBApi()
    let ref = Database.database().reference()
    var currentUserId: String = ""
    var currentGameId: String = "some-game-id"
    
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
    
    func createPlayer(info: [String: Any], completion: @escaping () -> Void) {
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
        completion()
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
    
    func storeStat(type: Statistic, pid: String, seconds: Double) {
        let pathToStats = "\(pathToPlayers)/\(pid)/game-stats/\(currentGameId)/stats"
        let refStatsTable = Database.database().reference(withPath: pathToStats)
        let newStatId = refStatsTable.childByAutoId().key
        
        let statistic: [String: Any] = [
            "type": type.rawValue,
            "game-time": seconds
        ]
        
        let childUpdates = ["/\(newStatId)": statistic]
        refStatsTable.updateChildValues(childUpdates)
    }
}
