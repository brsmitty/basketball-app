//
//  FireRoot.swift
//  basketball-app
//
//  Created by Aniki on 10/7/19.
//  Copyright © 2019 Aniki Zarif. All rights reserved.
//
import Firebase

struct FireRoot{
    
    static let env = "users"
    
    static let db = Firestore.firestore()
    static let root = db.collection(env)
    
}
