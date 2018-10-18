//
//  GameViewController.swift
//  basketball-app
//
//  Created by David on 10/2/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class GameViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var gameState: [String: Any] = [:]
    var tid : String = ""
    var possession: String = "" //keeps track of whether current possession is offense or defense, starts as neither at beginning of the game, until a jump ball occurs
    var possessionArrow: String = "" //possession arrow for jump balls
    var ballIndex : Int = 0 //keeps track of the index of the player who currently has the ball. alligned with active[String]
    var active = [String?](repeating: nil, count: 5) //String array of the PIDs of all 5 players on the floor currently, starts as nil until intial subs are made
    var activeObjects = [Player?](repeating: nil, count: 5) //parallel to active, contains all player objects
    var roster = [Player?](repeating: nil, count: 20)
    var panStartPoint = CGPoint() //beginning point of any given pan gesture
    var panEndPoint = CGPoint() //end point of any given pan gesture
    let boxHeight : CGFloat = 100.0 //constant for the height of the hit box for a player
    let boxWidth : CGFloat = 100.0 //constant for the width of the hit box for a player
    var boxRects : [CGRect] = [CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init()] //array of rectangles for hit boxes of hoop, PG, SG, SF, PF, C -- IN THAT ORDER
    
    @IBOutlet weak var courtView: UIImageView! //court image outlet
    @IBOutlet weak var imageHoop: UIImageView! //hoop image outlet
    @IBOutlet weak var imagePlayer1: UIImageView! //PG image outlet
    @IBOutlet weak var imagePlayer2: UIImageView! //SG image outlet
    @IBOutlet weak var imagePlayer3: UIImageView! //SF image outlet
    @IBOutlet weak var imagePlayer4: UIImageView! //PF image outlet
    @IBOutlet weak var imagePlayer5: UIImageView! //C image outlet
    
    // OVERRIDE VIEW FUNCTIONS ///////////////////////////////////////////////
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRoster()
        //retrieveGameState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init all hitbox rectangles from the UI Image Views
        boxRects[0] = CGRect.init(x: imageHoop.frame.origin.x, y: imageHoop.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[1] = CGRect.init(x: imagePlayer1.frame.origin.x, y: imagePlayer1.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[2] = CGRect.init(x: imagePlayer2.frame.origin.x, y: imagePlayer2.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[3] = CGRect.init(x: imagePlayer3.frame.origin.x, y: imagePlayer3.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[4] = CGRect.init(x: imagePlayer4.frame.origin.x, y: imagePlayer4.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[5] = CGRect.init(x: imagePlayer5.frame.origin.x, y: imagePlayer5.frame.origin.y, width: boxWidth, height: boxHeight)
    }
    
    // GAME STATE FUNCTIONS ///////////////////////////////////////////////
    
    /*func retrieveGameState(){
        defaults.set([:], forKey: "gameState")
        gameState = defaults.object(forKey: "gameState") as! [String: Any]
        print(gameState)
        if (gameState.count == 0){
            getRoster()
        }
    }
    
    func saveGameState(){
        defaults.set(gameState, forKey: "gameState")
    }
    
    func resetGameState(){
        defaults.set([:], forKey: "gameState")
    }*/
    
    // FIREBASE READ & WRITE FUNCTIONS ///////////////////////////////////////////////
    
    func getRoster(){
        //grab persistently stored TID, pull roster from firebase
        var roster : [String: Any] = [:]
        tid = defaults.string(forKey: "tid")!
        let firebaseRef = Database.database().reference()
        firebaseRef.child("teams").child(tid).child("roster").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            //fill roster dictionary with appropriate player values from firebase (key = PID, value = nested player dictionary)
            for v in value! {
                let key = v.key
                let val = v.value as! [String: Any]
                roster[key] = val
            }
            self.gameState["roster"] = roster
            self.createPlayerObjectsFromRoster(roster: roster)
//            self.saveGameState()
        }) { (error) in //error pulling roster from firebase
            print(error.localizedDescription)
        }
    }
    
    func createPlayerObjectsFromRoster(roster: [String: Any]){
        var i: Int = 0
        for player in roster {
            let p = player.value as! [String: Any]
            let playerObject = Player(firstName: p["fname"] as! String,
                           lastName: p["lname"] as! String,
                           photo: nil,
                           position: p["position"] as! String,
                           height: p["height"] as! String,
                           weight: p["weight"] as! String,
                           rank: p["rank"] as! String,
                           playerId: p["pid"] as! String,
                           teamId: p["tid"] as! String,
                           points: p["points"] as! Int,
                           assists: p["assists"] as! Int,
                           turnovers: p["turnovers"] as! Int,
                           threePtAtt: p["threePtAtt"] as! Int,
                           twoPtAtt: p["twoPtAtt"] as! Int,
                           threePtMade: p["threePtMade"] as! Int,
                           twoPtMade: p["twoPtMade"] as! Int,
                           ftAtt: p["ftAtt"] as! Int,
                           ftMade: p["ftMade"] as! Int,
                           offRebounds: p["offRebounds"] as! Int,
                           defRebounds: p["defRebounds"] as! Int,
                           steals: p["steals"] as! Int,
                           blocks: p["blocks"] as! Int,
                           deflections: p["deflections"] as! Int,
                           personalFoul: p["personalFoul"] as! Int,
                           techFoul: p["techFoul"] as! Int,
                           chargesTaken: p["chargesTaken"] as! Int)
            self.roster[i] = playerObject
            i += 1
        }
    }
    
    // GESTURE HANDLER FUNCTIONS ///////////////////////////////////////////////
    
    //handles passing swipe gestures from player to player, as well as layup swipe gestures from player to hoop
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.view != nil else {return}
        let player = recognizer.view!
        let translation = recognizer.translation(in: player.superview)
        if recognizer.state == .began {
            self.panStartPoint = player.center
        }
        if recognizer.state == .ended {
            self.panEndPoint = CGPoint(x: panStartPoint.x + translation.x, y: panStartPoint.y + translation.y)
            determineAction(startIndex: determineBoxIndex(point: self.panStartPoint), endingIndex: determineBoxIndex(point: self.panEndPoint))
        }
        if recognizer.state == .cancelled {print("cancel")}
    }
    
    //long press detected, display offensive player options
    @IBAction func handleLongPress(_ touchHandler: UILongPressGestureRecognizer) {
        let point = touchHandler.location(in: self.courtView)
        let index = determineBoxIndex(point: point)
        if touchHandler.state == .began {
            presentOffensiveOptions(point: point, index: index)
        }
    }
    
    //shot detected, display full shot chart for placement of shot location
    @IBAction func handleShot(_ recognizer: UITapGestureRecognizer) {
        UIView.setAnimationsEnabled(false)
//        saveGameState()
        self.performSegue(withIdentifier: "shotChartSegue", sender: nil)
    }
    
    // GENERAL HELPER FUNCTIONS ///////////////////////////////////////////////
    
    //returns index in active[String] and boxRects[CGRect] of hitbox which was targeted, given the coordinate point of the user interaction(s). return 999 for empty gesture, i.e. swipe to random spot on court
    func determineBoxIndex(point: CGPoint) -> Int {
        var i: Int = 0
        for rect in boxRects {
            if rect.contains(point){ return i }
            else{ i += 1 }
        }
        return 999
    }
    
    //determine if a swipe was a pass (player to player) or a layup (player to hoop)
    func determineAction(startIndex: Int, endingIndex: Int){
        if endingIndex == 0 {
            handleLayup(playerIndex: startIndex)
        }
        else if endingIndex != 999 {
            handlePass(passingPlayerIndex: startIndex, receivingPlayerIndex: endingIndex)
        }
    }
    
    //return whether player is on the floor currently or not
    func isActive(pid: String) -> Bool{
        for player in active {
            if (player == pid){
                return true
            }
        }
        return false
    }
    
    //display appropriate actions for current offensive possession
    func presentOffensiveOptions(point: CGPoint, index: Int){
        let popupForOffensivePlayerOptions = UIAlertController(title: "Offensive Options", message: "", preferredStyle: .actionSheet)
        let turnoverBtn = UIAlertAction(title: "Turnover", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.handleTurnover()
        }
        let foulBtn = UIAlertAction(title: "Foul", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.handleFoul(index: index)
        }
        let jumpBallBtn = UIAlertAction(title: "Jump Ball", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.handleJumpBall(point: point)
        }
        let subPlayerBtn = UIAlertAction(title: "Sub", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.subPlayer(index: index, point: point)
        }
        if (active[index - 1] != nil){
            if (possession != ""){
                popupForOffensivePlayerOptions.addAction(turnoverBtn)
                popupForOffensivePlayerOptions.addAction(foulBtn)
            }
            popupForOffensivePlayerOptions.addAction(jumpBallBtn)
        }
        popupForOffensivePlayerOptions.addAction(subPlayerBtn)
        let popover = popupForOffensivePlayerOptions.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect.init(origin: CGPoint.init(x: point.x, y: point.y + 50), size: CGSize.init())
        present(popupForOffensivePlayerOptions, animated: true)
    }
    
    // BASKETBALL ACTION FUNCTIONS ///////////////////////////////////////////////
    
    //layup detected, display paint image for more accurate placement of layup shot location
    func handleLayup(playerIndex: Int){
        UIView.setAnimationsEnabled(false)
//        saveGameState()
        self.performSegue(withIdentifier: "layupSegue", sender: nil)
    }
    
    //pass detected, record and update ballIndex
    func handlePass(passingPlayerIndex: Int, receivingPlayerIndex: Int){
        ballIndex = receivingPlayerIndex
    }
    
    //turnover recorded, change possession
    func handleTurnover(){

    }
    
    //jump ball recorded, determine outcome and set possession accordingly
    func handleJumpBall(point: CGPoint){
        let popupForJumpBallOutcome = UIAlertController(title: "Outcome", message: "", preferredStyle: .actionSheet)
        let jumpBallWonOutcome = UIAlertAction(title: "Won", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.possession = "offense"
        }
        let jumpBallLostOutcome = UIAlertAction(title: "Lost", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.possession = "defense"
            
        }
        popupForJumpBallOutcome.addAction(jumpBallWonOutcome)
        popupForJumpBallOutcome.addAction(jumpBallLostOutcome)
        let popover = popupForJumpBallOutcome.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect.init(origin: CGPoint.init(x: point.x, y: point.y + 50), size: CGSize.init())
        present(popupForJumpBallOutcome, animated: true)
    }
    
    //foul detected, determine outcome and either change possession or record FT attempts/makes
    func handleFoul(index: Int){
        
    }
    
    //player sub detected, display bench players and update active[String] accordingly
    func subPlayer(index: Int, point: CGPoint){
        let popupForBenchedPlayersToSub = UIAlertController(title: "Bench", message: "", preferredStyle: .actionSheet)
        var benchPlayer: UIAlertAction
        for player in gameState["roster"] as! NSDictionary {
            let dict = player.value as! NSDictionary
            if (!isActive(pid: dict["pid"] as! String)){
                let fname = dict["fname"] as! String
                let lname = dict["lname"] as! String
                let pid = dict["pid"] as! String
                benchPlayer = UIAlertAction(title: "\(fname) \(lname)", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.active[index - 1] = pid
                    self.activeObjects[index - 1] = self.getPlayerObject(pid: pid)
                }
                popupForBenchedPlayersToSub.addAction(benchPlayer)
            }
        }
        let popover = popupForBenchedPlayersToSub.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect.init(origin: CGPoint.init(x: point.x, y: point.y + 50), size: CGSize.init())
        present(popupForBenchedPlayersToSub, animated: true)
    }
    
    func getPlayerObject(pid: String) -> Player{
        for player in roster{
            if (player!.playerId == pid){
                return player!
            }
        }
        return Player(firstName: "", lastName: "", photo: nil, position: "", height: "", weight: "", rank: "", playerId: "", teamId: "")
    }
    
    func syncAllPlayerObjectsToFirebase(){
        
    }
    
    func syncSinglePlayerObjectToFirebase(index: Int){
        
    }
}
