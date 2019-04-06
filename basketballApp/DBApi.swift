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
    case substitutionIn = 69
    case substitutionOut = 70
    case jumpBallWon = 72
    case jumpBallLost = 73
    case pass = 74
}

extension DBApi {
    static func lineupId(from playerIds: [String]) -> String? {
        guard playerIds.count == 5 else { return nil }
        let sorted = playerIds.sorted()
        return sorted.joined(separator: "&")
    }
}

class DBApi {
    static let sharedInstance = DBApi()
    let ref = Database.database().reference()
    var currentUserId: String = ""
    var currentGameId: String? = "some-game-id"
    var currentLineup: (id: String, key: String, time: Int)?
    var currentGameLineupIds: [String]?
    var currentGameScore: Int = 0
    
    var pathToPlayers: String {
        return "users/\(currentUserId)/players"
    }
    
    var pathToGames: String {
        return "users/\(currentUserId)/games"
    }
    
    var pathtoCurrentGame: String? {
        guard let gameId = currentGameId else { return nil }
        return "users/\(currentUserId)/games/\(gameId)"
    }
    
    var pathToCurrentGameLineups: String? {
        guard let gameId = currentGameId else { return nil }
        return "users/\(currentUserId)/games/\(gameId)/lineups"
    }
    
    var pathToCurrentLineup: String? {
        guard let gameId = currentGameId else { return nil }
        guard let lineupId = currentLineup?.id else { return nil }
        return "users/\(currentUserId)/games/\(gameId)/lineups/\(lineupId)"
    }
    
    var pathToTeam: String {
        return "users/\(currentUserId)/team"
    }
    
    func pathToStats(for pid: String) -> String? {
        guard let gameId = currentGameId else { return nil }
        return "\(pathToPlayers)/\(pid)/game-stats/\(gameId)/stats"
    }
    
    func createPlayer(info: [String: Any], completion: @escaping () -> Void) -> String {
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
        
        return newPlayerId ?? ""
    }
    
    func createGames(info: [String: Any]) -> String {
        let refGameTable = Database.database().reference(withPath: pathToGames)
        let newGameId = refGameTable.childByAutoId().key
        let game: [String: Any] = [
            "user_id": currentUserId,
            "title": info["title"] as? String ?? "",
            "location": info["location"] as? String ?? "",
            "gameType": info["gameType"] as? String ?? "",
            "gameDate": info["gameDate"] as? String ?? "",
            "gameTime": info["gameTime"] as? String ?? "",
            "score": 0,
            "opponent-score": 0,
            "gameDetail": info["gameDetail"] as? String ?? ""
        ]
        let childUpdates = ["/\(newGameId)": game]
        refGameTable.updateChildValues(childUpdates)
        
        return newGameId ?? ""
    }
    
    func getGames(completion: @escaping ([[String: Any]]) -> Void) {
        let refGameTable = Database.database().reference(withPath: pathToGames)
        refGameTable.observeSingleEvent(of: .value) { snapshot in
            if snapshot.value is NSNull {
                print("no games in the database")
            }
            var games = [[String: Any]]()
            for game in snapshot.children {
                let gameSnap = game as? DataSnapshot
                var gameDict = gameSnap?.value as? [String: Any] ?? [:]
                gameDict["game-id"] = gameSnap?.key ?? ""
                games.append(gameDict)
            }
            completion(games)
        }
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
                let playerDict = playerSnap?.value as? [String: Any] ?? [:]
                players.append(Player(dictionary: playerDict, id: pid))
            }
            completion(players)
        }
    }
    
    func storeStat(type: Statistic, pid: String, seconds: Double) -> String? {
        guard let statsPath = pathToStats(for: pid) else { return nil }
        let refStatsTable = Database.database().reference(withPath: statsPath)
        let newStatId = refStatsTable.childByAutoId().key
        
        let statistic: [String: Any] = [
            "type": type.rawValue,
            "game-time": seconds
        ]
        
        let childUpdates = ["/\(newStatId)": statistic]
        refStatsTable.updateChildValues(childUpdates)
        
        adjustScore(type: type)
        
        return newStatId
    }
    
    func adjustScore(type: Statistic) {
        guard let gamePath = pathtoCurrentGame else { return }
        
        var points: Int
        switch type {
        case .freeThrow:
            points = 1
        case .score2:
            points = 2
        case .score3:
            points = 3
        default: return
        }
        currentGameScore += points
        let refGameTable = Database.database().reference(withPath: gamePath)
        
        let childUpdates = ["/score": currentGameScore]
        refGameTable.updateChildValues(childUpdates)
    }
    
    func switchLineup(to newLineupId: String, at gameTimeInSeconds: Int) {
        guard let lineupsPath = pathToCurrentGameLineups else { return }
        
        if let (currentLineupId, currentLineupKey, gameTime) = currentLineup {
            if currentLineupId == newLineupId { return }
            let refLineupsTable = Database.database().reference(withPath: "\(lineupsPath)/\(currentLineupId)")
            
            let endCurrentLineupTime: [String: Any] = [
                "start": gameTime,
                "end": gameTimeInSeconds
            ]
            let endCurrentChildUpdate = ["\(currentLineupKey)": endCurrentLineupTime]
            refLineupsTable.updateChildValues(endCurrentChildUpdate)
        }
        
        let refLineupsTable = Database.database().reference(withPath: "\(lineupsPath)/\(newLineupId)")
        let newLineupChildId = refLineupsTable.childByAutoId().key
        
        let newLineupTime: [String: Any] = [
            "start": gameTimeInSeconds,
            "end": -1
        ]
        let newChildUpdate = ["\(newLineupChildId)": newLineupTime]
        refLineupsTable.updateChildValues(newChildUpdate)
        currentLineup = (newLineupId, newLineupChildId, gameTimeInSeconds) as! (id: String, key: String, time: Int)
    }
}
