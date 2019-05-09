//
//  AppDelegate.swift
//  basketball-app
//
//  Created by David on 9/5/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func testPlayerCreate() {
        let playerData : [String: Any] = ["fname": "Test",
                                          "lname": "Player",
                                          "height": "6'7\"",
                                          "weight": "190",
                                          "rank": "Freshman",
                                          "position": "Point Guard"]
        let playerId = DBApi.sharedInstance.createPlayer(info: playerData, completion: { })
        DBApi.sharedInstance.getPlayers { players in
            if players.contains(where: { $0.playerId == playerId }) {
                print("get players test passed")
            } else {
                print("get players test failed")
            }
        }
    }
    
    func testGameCreate() {
        let gameData: [String: Any] = [
            "title": "The Big game",
            "location": "The Big House",
            "gameType": "Playoffs",
            "gameDate": "Today",
            "gameTime": "3 pm",
            "score": 0,
            "opponent-score": 0,
            "gameDetail": "We gotta win this one"
        ]
        let gameId = DBApi.sharedInstance.createGames(info: gameData)
        DBApi.sharedInstance.currentGameId = gameId
        DBApi.sharedInstance.getGames { games in
            if games.contains(where: { ($0["game-id"] as? String ?? "") == gameId }) {
                print("get games test passed")
            } else {
                print("get games test failed")
            }
        }
    }
    
    func testAddStat(time: Double) {
        DBApi.sharedInstance.storeStat(type: .score3, pid: "test-player-id", seconds: time)
    }
    
    func testAddStatB() {
        DBApi.sharedInstance.storeStat(type: .techFoul, pid: "test-player-id", seconds: 60)
    }
    
    func testAddStatc() {
        DBApi.sharedInstance.storeStat(type: .block, pid: "test-player-id", seconds: 120)
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        
        DBApi.sharedInstance.currentUserId = "test-user-id-2"
        DBApi.sharedInstance.currentGameId = "test-game-id-2"
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

