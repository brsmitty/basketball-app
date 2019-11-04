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
    case score2 = "2 point score"
    case score3 = "3 point score"
    case score2Attempt = "2 point missed FG"
    case score3Attempt = "3 point missed FG"
    case freeThrow = "free throw score"
    case freeThrowAttempt = "free throw attempt"
    case assist = "assist"
    case turnover = "turnover"
    case offRebound = "offensive rebound"
    case defRebound = "defensive rebound"
    case steal = "steal"
    case block = "blocked shot"
    case deflection = "deflection"
    case personalFoul = "personal foul"
    case techFoul = "technical foul"
    case chargeTaken = "charge taken"
    case charge = "charge"
    case substitutionIn = "substitution in"
    case substitutionOut = "substitution out"
    case jumpBallWon = "jump ball win"
    case jumpBallLost = "jump ball loss"
    case pass = "completed pass"
    case threeSecondViolation = "3 second violation"
    case flagrantFoul = "flagrant foul"
    case shotLocation = "shotLocation"
}

//The keys of the performance indicators as they exist in the DB
enum KPIKeys: String{
    case assists = "assists"
    case blocks = "blocks"
    case charges = "chargesTaken"
    case defensiveRebounds = "defRebounds"
    case deflections = "deflections"
    case firstName = "fName"
    case foulShotsAttempted = "ftAtt"
    case foulShotsMade = "ftMade"
    case offensiveRebounds = "offRebounds"
    case personalFouls = "personalFoul"
    case points = "points"
    case steals = "steals"
    case technicalFouls = "techFoul"
    case threePointersAttempted = "threePtAtt"
    case threePointerstMade = "threePtMade"
    case turnovers = "turnovers"
    case twoPointersMade = "twoPtMade"
    case twoPointersAttempted = "twoPtAtt"
    case shotLocation = "shotLocation"
    
    static let allValues = [assists, blocks, charges, deflections, deflections, deflections, firstName,
        foulShotsAttempted,foulShotsMade,offensiveRebounds,personalFouls,personalFouls,points,
        shotLocation, steals,technicalFouls,threePointersAttempted,threePointerstMade,turnovers,twoPointersMade, twoPointersAttempted
    ]
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
    var uid : String? = UserDefaults.standard.string(forKey: "uid")
    var tid : String? = UserDefaults.standard.string(forKey: "tid")
    var currentUserId: String? = ""
    var currentGameId: String? = "some-game-id"
    var currentLineup: (id: String, key: String, time: Int)?
    var currentGameLineupIds: [String]?
    var currentGameScore: Int = 0
    
    //path to players nested in users table
    var pathToPlayers: String {
        return "users/\(currentUserId)/players"
    }
    //path to a player in the users table with given pid
    func pathToPlayer(pid: String) -> String{
        return pathToPlayers + "/\(pid)"
    }
    //path to games nested in the users table
    var pathToGames: String {
        return "users/\(currentUserId)/games"
    }
    //path to the ongoing game. "currentgameId" is changed to "test-game-id-2" in the application launch
    var pathtoCurrentGame: String? {
        guard let gameId = currentGameId else { return nil }
        return "users/\(currentUserId)/games/\(gameId)"
    }
    //path to lineups table nested within games which is nested within users
    var pathToCurrentGameLineups: String? {
        guard let gameId = currentGameId else { return nil }
        return "users/\(currentUserId)/games/\(gameId)/lineups"
    }
    //path to the current lineup
    var pathToCurrentLineup: String? {
        guard let gameId = currentGameId else { return nil }
        guard let lineupId = currentLineup?.id else { return nil }
        return "users/\(currentUserId)/games/\(gameId)/lineups/\(lineupId)"
    }
    //path to the current user's team.
    var pathToTeam: String {
        return "users/\(currentUserId)/team"
    }
    //path to the stats table nested in the game stats table in the users table
    func pathToStats(for pid: String) -> String? {
        guard let gameId = currentGameId else { return nil }
        return "\(pathToPlayers)/\(pid)/game-stats/\(gameId)/stats"
    }
    
    //path to the stats table nested in the game stats table in the users table. TODO: Change this to the correct location in new schema
    func pathToPlayerGameStats(for pid: String) -> String? {
        return "\(pathToPlayers)/\(pid)/dummy-stats/"
    }
    
    //THIS IS NOT USED AS CREATED PLAYER IS MADE IN PlayerManagerViewController
    //LEFT HERE FOR EXPANDABILITY
    //P.S. Implementation is deprecated
    //creates a player within the users table
    func createPlayer(info: [String: Any], completion: @escaping () -> Void) -> String {
        let refPlayersTable = Database.database().reference(withPath: pathToPlayers)
        let newPlayerId = refPlayersTable.childByAutoId().key
        print("print DBAPI CREATEPLAYER")
        let player: [String: Any] = [
            "user_id": currentUserId,
            "fName": info["fname"] as? String ?? "",
            "lName": info["lname"] as? String ?? "",
            "height": info["height"] as? String ?? "",
            "weight": info["weight"] as? String ?? "",
            "rank": info["rank"] as? String ?? "",
            "position": info["position"] as? String ?? ""
        ]
        
        let childUpdates = ["/\(newPlayerId ?? "")": player]
        refPlayersTable.updateChildValues(childUpdates)
        completion()
        
        return newPlayerId ?? ""
    }
    
    //MARK: Create Games
    //Create a new game by adding game ids for every player of the user
    //For those of who are not playing then the stats of the player is 0
    func createGames(gid : String) {
            
        //ADD SNAPSHOSTLISTENER
        FireRoot.players.getDocuments(){
                (querySnapshot, err) in
            if err != nil{
                    print("Error getting documents.")
                }else{
                    for document in querySnapshot!.documents{
                        var playerGameStats: [String: Int] = [:]
                        for key in KPIKeys.allValues{
                            playerGameStats[key.rawValue] = 0
                        }
                        FireRoot.players.document(document.documentID)
                            .collection("stats").document(gid)
                            .setData(playerGameStats){
                                err in
                                if err != nil{
                                    print("Error adding game to players.")
                                }else{
                                    print("Added games to players.")
                                }
                        }
                    }
                }
        }
    }
    
    //gets the games nested in the users table, passes it as an argument to a code block
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
    
    //Attach a listener to a player stat and run that when a value change occurs in the DB: TODO: Make this listen to individual stats
    func listenToPlayerStat(pid: String, completion: @escaping (DataSnapshot) -> Void){
        guard let statsPath = pathToPlayerGameStats(for: pid) else {return}
        let playerStatsRef = Database.database().reference(withPath: statsPath )
        playerStatsRef.observe(.value) { (snapshot) in
            completion(snapshot)
        }
    }
    
    //MARK: Probably Crap
    //Sets all of the player stats to be 0 and save it to Firestore
    func setDefaultPlayerStats(pid: String){
        guard let statsPath = pathToPlayerGameStats(for: pid) else { return }
        let statsRef = Database.database().reference(withPath: statsPath)
        var defaultStats: [String: Int] = [:]
        for key in KPIKeys.allValues{
            defaultStats[key.rawValue] = 0
        }
        statsRef.setValue(defaultStats)
    }
    
    //MARK: Get Players
    //Gets the players of the user, and passes it as an argument to a code block
    func getPlayers(completion: @escaping ([Player]) -> Void) {
        
        //Get players of user from the database
        FireRoot.players.getDocuments(){
                (querySnapshot, err) in
            if err != nil {
                    print("Problem getting players from database")
                }else{
                    var players = [Player]()
                    for player in querySnapshot!.documents{
                        players.append(Player(dictionary: player.data(), id: player.documentID))
                    }
                    completion(players)
                }
        }
    }

    //MARK: Storing Stats (ICP)
    //will store an event and the game time associated with it in the game-stats table
    func storeStat(type: Statistic, pid: String, seconds: Double) -> String? {
        let ref = FireRoot.root.document(uid!)
            .collection("team").document(tid!)
            .collection("players").document(pid).collection("Stats")
        
        
        guard let statsPath = pathToStats(for: pid) else { return nil }
        let refStatsTable = Database.database().reference(withPath: statsPath)
        let newStatId = refStatsTable.childByAutoId().key
        
        let statistic: [String: Any] = [
            "type": type.rawValue,
            "game-time": seconds
        ]
        
        //let childUpdates = ["/\(newStatId ?? "")": statistic]
        //refStatsTable.updateChildValues(childUpdates)
        
        adjustScore(type: type)
        
        return newStatId
    }
    //updates the score of the current game
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
    //Subs players in and out and records the time they were subbed in and out in the lineup table (withing users and games)
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
        let newChildUpdate = ["\(newLineupChildId ?? "")": newLineupTime]
        refLineupsTable.updateChildValues(newChildUpdate)
        currentLineup = ((newLineupId, newLineupChildId, gameTimeInSeconds) as! (id: String, key: String, time: Int))
    }
    //updates the dribbles nested in the game in the users table. TODO: this info should be in the players table
    func updateDribbles(to dribbles: [String: Int]) {
        guard let gamePath = pathtoCurrentGame else { return }
        let refGameTable = Database.database().reference(withPath: gamePath)
        
        let childUpdates: [String: [String: Int]] = ["/dribbles": dribbles]
        refGameTable.updateChildValues(childUpdates)
    }
    //updates the oppscore and oppstates in the game nested in the users table
    func updateOpponentStats(to opponent: [String: [String: Any]], score: Int) {
        guard let gamePath = pathtoCurrentGame else { return }
        let refGameTable = Database.database().reference(withPath: gamePath)
        
        let childUpdates: [String: Any] = ["/oppScore": score,
                                           "/oppStats": opponent]
        refGameTable.updateChildValues(childUpdates)
    }
    // To-do: Update shot locations
    func updateShotLocation(to shotLocation: [String: [Int]]) {
        guard let gamePath = pathtoCurrentGame else { return }
        let refGameTable = Database.database().reference(withPath: gamePath)
        
        let childUpdates: [String: Any] = ["/shotLocation": shotLocation]
        refGameTable.updateChildValues(childUpdates)
    }
    
    
}
