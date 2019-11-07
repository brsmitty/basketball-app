//
//  FireRoot.swift
//  basketball-app
//
//  Created by Aniki on 10/7/19.
//  Copyright © 2019 Aniki Zarif. All rights reserved.
//
// This files serves as the directory to the mostly used document paths.
import FirebaseFirestore

struct FireRoot{
    
    static let uid = UserDefaults.standard.string(forKey: "uid")
    static let tid = UserDefaults.standard.string(forKey: "tid")
    static let env = "users"
    
    static let db = Firestore.firestore()
    //Firestore -> users
    static let root = db.collection("users")
    
    //Firestore -> users -> uid
    static let user = root.document(uid!)
    
    //Firestore -> users -> uid -> team -> tid
    static let team = user.collection("team").document(tid!)
    
    //Firestore -> users -> uid -> team -> tid -> players
    static let players = team.collection("players")
    
    //Firestore -> users -> uid -> team -> tid -> games
    static let games = team.collection("games")
}
