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
    let uid: String = ""
    var currentGameId: String = ""
    
    func storeStat(type: Statistic, value: Any?, pid: String, time: Double) {
        let refStatsTable = Database.database().reference(withPath: "\(uid)/statistics")
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
        
        let childUpdates = ["/\(uid)/statistics/\(newStatId)": statistic]
        refStatsTable.updateChildValues(childUpdates)
    }
    
    func createPlayer(info: [String: Any]) {
        let refPlayersTable = Database.database().reference(withPath: "\(uid)/players")
        let newPlayerId = refPlayersTable.childByAutoId().key
        let player: [String: Any] = [
            "user_id": uid,
            "firstName": info["first_name"] as? String ?? "",
            "lastName": info["last_name"] as? String ?? "",
            "height": info["height"] as? Int ?? 0,
            "weight": info["weight"] as? Int ?? 0,
            "jersey": info["jersey"] as? Int ?? -1,
            "player_id": newPlayerId
        ]
        let childUpdates = ["/\(uid)/players/\(newPlayerId)": player]
        refPlayersTable.updateChildValues(childUpdates)
    }
}
