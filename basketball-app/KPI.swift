//
//  KPI.swift
//  basketball-app
//
//  Created by David on 9/20/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//
/*
import UIKit
import Firebase
import FirebaseDatabase

class KPI: NSObject {
    var targetFG: Float
    var targetFT: Float
    var targetTO: Int
    var targetRB: Int
    var actualFG: Float
    var actualFT: Float
    var actualTO: Int
    var actualRB: Int
    
    init(pid: String) {
        let ref = Database.database().reference(withPath: "players")
        ref.child(pid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let targets = value?["targets"] as? NSDictionary ?? [:]
            let actual = value?["stats"] as? NSDictionary ?? [:]
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func meetsTargetFG(){
        var meetsTarget = false
        
        return meetsTarget
    }
}
*/
