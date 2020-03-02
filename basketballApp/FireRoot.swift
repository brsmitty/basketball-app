//
//  FireRoot.swift
//  basketball-app
//
//  Created by Aniki on 10/7/19.
//  Copyright © 2019 Aniki Zarif. All rights reserved.
//
// This files serves as the directory to the mostly used document paths.
import Firebase


struct FireRoot{
    
    static let uid = UserDefaults.standard.string(forKey: "uid")
    static let tid = UserDefaults.standard.string(forKey: "tid")
    static let env = "users"
    //placeholder until all references are deleted
    static let root = Database.database().reference()
    static let db = Database.database().reference()
    //Firebase -> users -> uid
    static let user = db.child("users").child(uid!)
    
    //Firebase -> games
    static let games = db.child("games")
    
    //Firebase -> teams -> tid
    static let teams = db.child("teams").child(tid!)
    
    //Firebase -> players
    static let players = db.child("players")
    
    //Firebase -> lineups
    static let lineups = db.child("lineups")
}
