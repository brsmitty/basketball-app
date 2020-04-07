//
//  DBApi.swift
//  basketballApp
//
//  Created by Sean O'Donnell on 2/13/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//
//  Fixed by Aniki Zarif on 11/15/19
//  Removed all FirebaseDatabase usage

import Foundation
import FirebaseFirestore
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
    case dribble = "dribble"
}

//The keys of the performance indicators as they exist in the DB
enum KPIKeys: String{
    case assists = "assists"
    case blocks = "blocks"
    case chargeTaken = "chargesTaken"
    case charges = "charges"
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
    case substitutionIn = "subIn"
    case substitutionOut = "subOut"
    case jumpBallWon = "jumpWon"
    case jumpBallLost = "jumpLost"
    case pass = "pass"
    case threeSecondViolation = "3SecViolation"
    case flagrantFoul = "flagrantFoul"
    case shotLocation = "shotLocation"
    case dribble = "dribble"
    
    static let allValues = [assists, blocks, charges, chargeTaken, deflections, deflections, deflections, defensiveRebounds,
        foulShotsAttempted,foulShotsMade,offensiveRebounds,personalFouls,personalFouls,points,
        shotLocation, steals,technicalFouls,threePointersAttempted,threePointerstMade,turnovers,twoPointersMade,
        twoPointersAttempted, substitutionIn, substitutionOut, jumpBallWon, jumpBallLost, pass, threeSecondViolation, flagrantFoul, dribble
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
    
    //MARK: Create Games
    //Create a new game by adding game ids for every player of the user
    //For those of who are not playing then the stats of the player is 0
    func createGames() {
            
        var game_fields: [String: Any] = [:]
        var game_info: [String: Any] = [:]
        //Initialize game fields
        for key in KPIKeys.allValues{
            game_fields[key.rawValue] = 0
        }
        //Additional game fields
        game_fields["score"] = 0
        game_fields["oppScore"] = 0
        game_info["title"] = ""
        game_fields["timeScored"] = [] as [Double]
         
         //Creating a new game in the firebase
        /*
         let game = FireRoot.games
             .addDocument(data: game_fields){
                 err in
                 if err != nil{
                     print("Error adding game")
                 }else{
                     print("Added new game")
                 }
         }
 */
        let game = FireRoot.games.childByAutoId()
        let gid = game.key
        UserDefaults.standard.set(gid, forKey: "gid")
        
        //Setting the opponents stats and opponent ID to user defaults
        //Useful to update opponent's stats
        game_fields["oppName"] = ""
        /*
        let oppId = FireRoot.games.document(gid).collection("opponent")
                    .addDocument(data: game_fields){
                       err in
                       if err != nil{
                           print("Error adding opponent")
                       }else{
                           print("Added opponent")
                       }
                   }
 */
        //TODO: add necessary fields to new game object
        UserDefaults.standard.set(gid, forKey: "oppId")
        var player_stats: [String: Any] = [:]
        //Setting the game under the player
        let players = FireRoot.players
        var numPlayers: Int = 0
        players.observe(DataEventType.value, with: { indPlayer in
            //let numPlayers = indPlayer.childrenCount
            for plyr in indPlayer.children.allObjects as! [DataSnapshot] {
                var playerGameStats: [String: Any] = [:]
                for key in KPIKeys.allValues{
                    playerGameStats[key.rawValue] = 0
                }
                //need to set value
                player_stats = (["player_stats": playerGameStats])
                numPlayers = numPlayers.advanced(by: 1)
                
                players.child(plyr.key).updateChildValues(player_stats)
            }
            
        })
        /*
        FireRoot.players.getDocuments(){
                (querySnapshot, err) in
            if err != nil{
                    print("Error getting documents.")
                }else{
                    for document in querySnapshot!.documents{
                        var playerGameStats: [String: Any] = [:]
                        for key in KPIKeys.allValues{
                            playerGameStats[key.rawValue] = 0
                        }
                        playerGameStats["timeScored"] = []
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
 */
    }
    
    
    //MARK: Listen To Player Stats
    //Attach a listener to a player stat
    func listenToPlayerStat(pid: String, completion: @escaping (DataSnapshot) -> Void){
        let gid = UserDefaults.standard.string(forKey: "gid")!
        print("lISTENTOPLAYERSTAT \(String(describing: UserDefaults.standard.string(forKey: "gid")))")
        FireRoot.games.child(gid).child("player_stats").child(pid).observe(DataEventType.value, with: { (snapshot) in
            completion(snapshot)
        })
            /*
            }
            .collection("stats").document(UserDefaults.standard.string(forKey: "gid")!)
            .addSnapshotListener{
                (snapshot, err) in
                //print(snapshot?.data())
                completion(snapshot!)
        }
 */
    }
    
    //MARK: Listen To Player Season Stats
    //Attach a listener to a player season stats
    func listenToPlayerSeasonStat(pid: String, completion: @escaping (DataSnapshot) -> Void){
        print("lISTENTOPLAYERSTAT \(String(describing: UserDefaults.standard.string(forKey: "pid")))")
        FireRoot.players.child(pid).child("season_stats").observe(DataEventType.value, with: { (snapshot) in
            completion(snapshot)
        })
        /*
        FireRoot.players.document(pid)
            .collection("stats").document("season_stats")
            .addSnapshotListener{
                (snapshot, err) in
                if err != nil{
                    print("Problem listening to Player Stat.")
                }
                completion(snapshot!)
        }
 */
    }
    
    //MARK: Listen To Game Score
    //Attach listener game score
    func listenToGameScore(gid: String, side: String, completion: @escaping (DataSnapshot)->Void){
        
        if(side == "user"){
            FireRoot.games.child(gid).child("score").observe(DataEventType.value, with: { (snapshot) in
                completion(snapshot)
            })
        }else{
            FireRoot.games.child(gid).child("opp_score").observe(DataEventType.value, with: { (snapshot) in
                completion(snapshot)
            })
        }
    }
    
    //MARK: Get Players
    //Gets the players of the user, and passes it as an argument to a code block
    func getPlayers(completion: @escaping ([Player]) -> Void) {
        
        //Get players of user from the database
        //.child("player_info").child(uid!)
        var count = 1
        FireRoot.players.observe(DataEventType.value, with: { indPlayer in
            //let numPlayers = indPlayer.childrenCount
            print(count)
            print(indPlayer.childSnapshot(forPath: "player_info/user_id").value as Any )
            print(self.uid!)
            if(indPlayer.childSnapshot(forPath: "player_info/user_id").value as? String == self.uid!) {
                var players = [Player]()
                for plyr in indPlayer.children.allObjects as! [DataSnapshot] {
                    players.append(Player(dictionary: plyr.ref.dictionaryWithValues(forKeys: [self.uid!]), id: plyr.key))

                    completion(players)
                }
            count = count.advanced(by: 1)
                
            }
            
        })
        /*
        getDocuments(){
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
 */
    }

    //MARK: Storing Stats
    //Storing stats into the database using pid
    func storeStat(type: Statistic, pid: String, seconds: Double){
        
        //May need to do team stats
        let gid = UserDefaults.standard.string(forKey: "gid")!
        //Reference of player games stats
        let refPlayer = FireRoot.games.child(gid).child("player_stats").child(pid)
        
        print("Seconds = \(seconds)")
        //Reference to player season stats
        let refPlayerSeasons = FireRoot.players.child(pid).child("season_stats")
        
        //Reference to current game stats
        let refGame = FireRoot.games.child(gid)
        
        //Update the fields of the player stats during the game
        switch type.rawValue{
        case "2 point score":
            refPlayer.updateChildValues([
                "twoPtMade": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "twoPtMade": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "twoPtMade": FieldValue.increment(Int64(1))
            ])
            
        case "3 point score":
            refPlayer.updateChildValues([
                "threePtMade": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "threePtMade": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "threePtMade": FieldValue.increment(Int64(1))
            ])

        case "2 point missed FG" :
            refPlayer.updateChildValues([
                "twoPtAtt": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "twoPtAtt": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "twoPtAtt": FieldValue.increment(Int64(1))
            ])
            
        case "3 point missed FG":
            refPlayer.updateChildValues([
                "threePtAtt": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "threePtAtt": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "threePtAtt": FieldValue.increment(Int64(1))
            ])
            
        case "free throw score":
            refPlayer.updateChildValues([
                "ftMade": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "ftMade": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "ftMade": FieldValue.increment(Int64(1))
            ])
            
        case "free throw attempt":
            refPlayer.updateChildValues([
                "ftAtt": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "ftAtt": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "ftAtt": FieldValue.increment(Int64(1))
           ])
            
        case "assist":
            refPlayer.updateChildValues([
                "assists": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "assists": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "assists": FieldValue.increment(Int64(1))
            ])
            
        case "turnover":
            refPlayer.updateChildValues([
                "turnovers": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "turnovers": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "turnovers": FieldValue.increment(Int64(1))
            ])
            
        case "offensive rebound":
            refPlayer.updateChildValues([
                "offRebound": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "offRebound": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "offRebound": FieldValue.increment(Int64(1))
            ])
            
        case "defensive rebound":
            refPlayer.updateChildValues([
                "defRebound": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "defRebound": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "defRebound": FieldValue.increment(Int64(1))
            ])
            
        case "steal":
            refPlayer.updateChildValues([
                "steals": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "steals": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "steals": FieldValue.increment(Int64(1))
            ])
            
        case "blocked shot":
            refPlayer.updateChildValues([
                "blocks": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "blocks": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "blocks": FieldValue.increment(Int64(1))
            ])
            
        case "deflection":
            refPlayer.updateChildValues([
                "deflections": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "deflections": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "deflections": FieldValue.increment(Int64(1))
            ])
            
        case "personal foul":
            refPlayer.updateChildValues([
                "personalFoul": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "personalFoul": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "personalFoul": FieldValue.increment(Int64(1))
            ])
            
        case "technical foul":
            refPlayer.updateChildValues([
                "techFoul": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "techFoul": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "techFoul": FieldValue.increment(Int64(1))
            ])
            
        case "charge taken":
            refPlayer.updateChildValues([
                "chargesTaken": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "chargesTaken": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "chargesTaken": FieldValue.increment(Int64(1))
            ])
            
        case "charge":
            refPlayer.updateChildValues([
                "charges": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "charges": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "charges": FieldValue.increment(Int64(1))
            ])
            
        case "substitution in":
            refPlayer.updateChildValues([
                "subIn": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "subIn": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "subIn": FieldValue.increment(Int64(1))
            ])
            
        case "substitution out":
            refPlayer.updateChildValues([
                "subOut": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "subOut": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "subOut": FieldValue.increment(Int64(1))
            ])
            
        case "jump ball win":
            refPlayer.updateChildValues([
                "jumpWon": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "jumpWon": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "jumpWon": FieldValue.increment(Int64(1))
            ])
            
        case "jump ball lost":
            refPlayer.updateChildValues([
                "jumpLost": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "jumpLost": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "jumpLost": FieldValue.increment(Int64(1))
            ])
            
        case "completed pass":
            refPlayer.updateChildValues([
                "pass": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "pass": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "pass": FieldValue.increment(Int64(1))
            ])
            
        case "3 second violation":
            refPlayer.updateChildValues([
                "3SecViolation": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "3SecViolation": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "3SecViolation": FieldValue.increment(Int64(1))
            ])
        case "flagrant foul":
            refPlayer.updateChildValues([
                "flagrantFoul": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "flagrantFoul": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "flagrantFoul": FieldValue.increment(Int64(1))
            ])
        case "dribble":
            refPlayer.updateChildValues([
                "dribble": FieldValue.increment(Int64(1))
            ])
            refPlayerSeasons.updateChildValues([
                "dribble": FieldValue.increment(Int64(1))
            ])
            refGame.updateChildValues([
                "dribble": FieldValue.increment(Int64(1))
            ])
        default:
            print("Data not saved")
        }
        adjustScore(type: type, pid: pid, seconds: seconds, tid: gid)
    }
    
    //MARK: Adjust Score
    //updates the score of the current game
    func adjustScore(type: Statistic, pid: String, seconds: Double, tid : String) {
        
        //Setting path to update the scores
        let path : DatabaseReference
        if(tid == UserDefaults.standard.string(forKey: "gid")){
            path = FireRoot.games.child(tid)
        }else{
            path = FireRoot.games.child(UserDefaults.standard.string(forKey: "gid")!)
                .child("opp_score")
        }
        
        var points: Int
        switch type {
        case .freeThrow:
            points = 1
            //Update the time scored
            path.updateChildValues(["timeScored": FieldValue.arrayUnion([seconds])])
        case .score2:
            points = 2
            path.updateChildValues(["timeScored": FieldValue.arrayUnion([seconds])])
        case .score3:
            points = 3
            path.updateChildValues(["timeScored": FieldValue.arrayUnion([seconds])])
        default: return
        }
        currentGameScore += points
        
        //Update the score in the database
        path.updateChildValues(["score" : FieldValue.increment(Int64(points))])
        
        if(tid == UserDefaults.standard.string(forKey: "gid")){
            //Update the players score for game
            FireRoot.games.child(UserDefaults.standard.string(forKey: "gid")!).child("player_stats").child(pid).updateChildValues(["points": FieldValue.increment(Int64(points))])
            
        
            //Update the players score in season stats
            FireRoot.players.child(pid).child("player_info").updateChildValues(["points": FieldValue.increment(Int64(points))])
            
        }
    }
    
    //MARK: LEFT HERE FOR EXPANDABILITY
    /*
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
    */
    
    //Deprecated: Still using firebase
    //updates the oppscore and oppstates in the game nested in the users table
    /*
    func updateOpponentStats(to opponent: [String: [String: Any]], score: Int) {
        guard let gamePath = pathtoCurrentGame else { return }
        let refGameTable = Database.database().reference(withPath: gamePath)
        
        let childUpdates: [String: Any] = ["/oppScore": score,
                                           "/oppStats": opponent]
        refGameTable.updateChildValues(childUpdates)
    }*/
    
    /*
    // To-do: Update shot locations
    func updateShotLocation(to shotLocation: [String: [Int]]) {
        guard let gamePath = pathtoCurrentGame else { return }
        let refGameTable = Database.database().reference(withPath: gamePath)
        print("shots: \(shotLocation)")
        let childUpdates: [String: Any] = ["/shotLocation": shotLocation]
        refGameTable.updateChildValues(childUpdates)
    }
    */
}
