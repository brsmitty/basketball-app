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
    
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    var quarterTime: Int = 10
    let storage = UserDefaults.standard
    var gameState: [String: Any] = ["began": false,
                                    "transitionState": "init",
                                    "possession": "",
                                    "possessionArrow": "",
                                    "teamFouls": 0,
                                    "ballIndex": 999,
                                    "assistingPlayerIndex": 999,
                                    "startTime": 0.0,
                                    "time": 0.0,
                                    "elapsed": 0.0,
                                    "status": false,
                                    "quarterTime": 10,
                                    "timer": Timer(),
                                    "roster": [],
                                    "active": [],
                                    "bench": [],
                                    "lineups": [],
                                    "playSequence": [],
                                    "shots": []]
    
    var activePlayerIdStrings = [String?](repeating: nil, count: 5) //String array of the PIDs of all 5 players on the floor currently, starts as nil until intial subs are made
    var activePlayerObjects = [Player?](repeating: nil, count: 5) //parallel to active, contains all player objects
    
    var panStartPoint = CGPoint() //beginning point of any given pan gesture
    var panEndPoint = CGPoint() //end point of any given pan gesture
    let boxHeight : CGFloat = 100.0 //constant for the height of the hit box for a player
    let boxWidth : CGFloat = 100.0 //constant for the width of the hit box for a player
    let benchWidth : CGFloat = 100.0 //constant for the width of the hit box for a player
    let benchPictureHeight : Int = 50 //constant for the width of the hit box for a player
    var boxRects : [CGRect] = [CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init()] //array of rectangles for hit boxes of hoop, PG, SG, SF, PF, C
    @IBOutlet weak var benchView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var labelMinute: UILabel!
    @IBOutlet weak var courtView: UIImageView! //court image outlet
    @IBOutlet weak var imageHoop: UIImageView! //hoop image outlet
    @IBOutlet weak var imagePlayer1: UIImageView! //PG image outlet
    @IBOutlet weak var imagePlayer2: UIImageView! //SG image outlet
    @IBOutlet weak var imagePlayer3: UIImageView! //SF image outlet
    @IBOutlet weak var imagePlayer4: UIImageView! //PF image outlet
    @IBOutlet weak var imagePlayer5: UIImageView! //C image outlet
    @IBOutlet weak var chargeButton: UIButton!
    @IBOutlet weak var timeoutButton: UIButton!
    @IBOutlet weak var benchButton: UIButton!
    @IBOutlet weak var gameSummaryButton: UIButton!
    @IBOutlet weak var techFoulButton: UIButton!
    @IBOutlet weak var outOfBoundsButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        benchView.isHidden = true
        let state = gameState["transitionState"] as! String
        if (state == "missedShot") { handleRebound() }
        else if (state == "madeShot") { switchToDefense() }
        else if (state == "init" ) { getRosterFromFirebase() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxRects[0] = CGRect.init(x: imageHoop.frame.origin.x, y: imageHoop.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[1] = CGRect.init(x: imagePlayer1.frame.origin.x, y: imagePlayer1.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[2] = CGRect.init(x: imagePlayer2.frame.origin.x, y: imagePlayer2.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[3] = CGRect.init(x: imagePlayer3.frame.origin.x, y: imagePlayer3.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[4] = CGRect.init(x: imagePlayer4.frame.origin.x, y: imagePlayer4.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[5] = CGRect.init(x: imagePlayer5.frame.origin.x, y: imagePlayer5.frame.origin.y, width: boxWidth, height: boxHeight)

      
      chargeButton.layer.cornerRadius = 5
      timeoutButton.layer.cornerRadius = 5
      benchButton.layer.cornerRadius = 5
      gameSummaryButton.layer.cornerRadius = 5
      techFoulButton.layer.cornerRadius = 5
      
        
        let strMinutes = String(format: "%02d", quarterTime)
        labelMinute.text = strMinutes
        labelSecond.text = "00"
      
      // circular all images
      roundImages()
    }

   func roundImages(){
      imagePlayer1.layer.masksToBounds = false
      imagePlayer1.layer.cornerRadius = imagePlayer1.frame.size.width/2
      imagePlayer1.clipsToBounds = true
      
      imagePlayer2.layer.masksToBounds = false
      imagePlayer2.layer.cornerRadius = imagePlayer1.frame.size.width/2
      imagePlayer2.clipsToBounds = true
      
      imagePlayer3.layer.masksToBounds = false
      imagePlayer3.layer.cornerRadius = imagePlayer1.frame.size.width/2
      imagePlayer3.clipsToBounds = true
      
      imagePlayer4.layer.masksToBounds = false
      imagePlayer4.layer.cornerRadius = imagePlayer1.frame.size.width/2
      imagePlayer4.clipsToBounds = true
      
      imagePlayer5.layer.masksToBounds = false
      imagePlayer5.layer.cornerRadius = imagePlayer1.frame.size.width/2
      imagePlayer5.clipsToBounds = true
   }
    // FIREBASE READ & WRITE FUNCTIONS ///////////////////////////////////////////////
    
    func getRosterFromFirebase(){
        //grab persistently stored TID, pull roster from firebase
        var roster : [String: Any] = [:]
        let tid = storage.string(forKey: "tid")!
        let firebaseRef = Database.database().reference()
        firebaseRef.child("teams").child(tid).child("roster").observeSingleEvent(of: .value, with: { (snapshot) in
            var value = snapshot.value as? [String: Any]
            //fill roster dictionary with appropriate player values from firebase (key = PID, value = nested player dictionary)
            if value == nil { value = [:] }
            for v in value! {
                let key = v.key
                let val = v.value as! [String: Any]
                roster[key] = val
            }
            self.createPlayerObjectsFromRoster(roster: roster)
        }) { (error) in print(error.localizedDescription) }
    }
    
    func createPlayerObjectsFromRoster(roster: [String: Any]){
        var i: Int = 0
        var players : [Player] = []
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
            players.append(playerObject)
            i += 1
        }
        self.gameState["roster"] = players
        self.gameState["bench"] = players
        self.gameState["active"] = [Player?](repeating: nil, count: 5)
        populateBench()
    }

    func populateBench(){
        var y = 0
        for _ in gameState["bench"] as! [Player] {
            let image = UIImage(named: "Kevin")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: y, width: 100, height: benchPictureHeight)
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSubstitutionGesture(recognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(panGesture)
            benchView.addSubview(imageView)
            y += benchPictureHeight
        }
    }
    
    @IBAction func showBench(_ sender: UIButton) {
        benchView.isHidden = false
    }
    
    @IBAction func hideBench(_ sender: UITapGestureRecognizer) {
        if (sender.location(in: containerView).x > benchWidth) { benchView.isHidden = true }
    }
    
    @IBAction func handleSubstitutionGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: containerView)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .began {
            self.panStartPoint = recognizer.location(in: benchView)
        }
        if recognizer.state == .ended {
            self.panEndPoint = recognizer.location(in: containerView)
            var activePlayers = [Player?](repeating: nil, count: 5)
            var index = 0
            for player in gameState["active"] as! [Player?] {
                activePlayers[index] = player
                index += 1
            }
            var benchPlayers = gameState["bench"] as! [Player]
            let benchIndex = getBenchPlayerIndex(point: self.panStartPoint)
            let activeIndex = getActivePlayerIndex(point: self.panEndPoint)
            if (activeIndex != 999) {
                let playerSubbingIn = benchPlayers[benchIndex]
                let playerSubbingOut = activePlayers[activeIndex]
                activePlayers[activeIndex] = playerSubbingIn
                if (playerSubbingOut != nil) {
                    benchPlayers[benchIndex] = playerSubbingOut!
                }
                else {
                    benchPlayers.remove(at: benchIndex)
                    var i = 0
                    for view in benchView.subviews {
                        if i >= 2 + benchIndex {
                            let newY = Int(view.frame.minY) - benchPictureHeight
                            view.frame = CGRect(x: 0, y: newY, width: 100, height: benchPictureHeight)
                        }
                        i += 1
                    }
                }
                
                getPlayerImage(index: activeIndex).image = UIImage(named: "Kevin")
                view.removeGestureRecognizer(recognizer)
                recognizer.view?.removeFromSuperview()
                gameState["active"] = activePlayers
                gameState["bench"] = benchPlayers
            }
            else {
                recognizer.view?.center = self.panStartPoint
            }
        }
    }
    
    func getBenchPlayerIndex(point: CGPoint) -> Int {
        var index = 0
        for _ in gameState["bench"] as! [Player] {
            let y = CGFloat((index + 1) * benchPictureHeight)
            if point.y <= y {
                self.panStartPoint = CGPoint(x: benchWidth / 2, y: y - CGFloat(benchPictureHeight / 2))
                return index
            }
            index += 1
        }
        return index
    }
    
    func getActivePlayerIndex(point: CGPoint) -> Int {
        var index = 1
        for _ in boxRects {
            if boxRects[index].contains(point) {
                return index - 1
            }
            index += 1
            if index > 5 { return 999 }
        }
        return 999
    }
    
    func getPlayerImage(index: Int) -> UIImageView {
        switch (index) {
            case 0: return imagePlayer1
            case 1: return imagePlayer2
            case 2: return imagePlayer3
            case 3: return imagePlayer4
            case 4: return imagePlayer5
            default: return imagePlayer1
        }
    }
    
    func presentOffensiveOptions(point: CGPoint, index: Int){
        let offenseAlert = UIAlertController(title: "Offensive Options", message: "", preferredStyle: .actionSheet)
        let turnover = UIAlertAction(title: "Turnover", style: UIAlertActionStyle.default) { UIAlertAction in self.handleTurnover(index: index) }
        let foul = UIAlertAction(title: "Foul", style: UIAlertActionStyle.default) { UIAlertAction in self.handleFoul(index: index) }
        let jumpball = UIAlertAction(title: "Jump Ball", style: UIAlertActionStyle.default) { UIAlertAction in self.handleJumpball(point: point, index: index) }
        if (fullLineup()){
            offenseAlert.addAction(jumpball)
            if (gameState["began"] as! Bool){
                offenseAlert.addAction(turnover)
                offenseAlert.addAction(foul)
            }
        }
        offenseAlert.popoverPresentationController?.sourceView = view
        offenseAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: CGPoint.init(x: point.x, y: point.y + 50), size: CGSize.init())
        present(offenseAlert, animated: false)
    }
    
    func handleJumpball(point: CGPoint, index: Int){
        if (gameState["began"] as! Bool == false){
            gameState["began"] = true
            gameState["ballIndex"] = index - 1
            let jumpballAlert = UIAlertController(title: "Outcome", message: "", preferredStyle: .actionSheet)
            let won = UIAlertAction(title: "Won", style: UIAlertActionStyle.default) { UIAlertAction in
                self.gameState["possession"] = "offense"
                self.gameState["possessionArrow"] = "defense"
            }
            let lost = UIAlertAction(title: "Lost", style: UIAlertActionStyle.default) { UIAlertAction in
                self.gameState["possessionArrow"] = "offense"
                self.switchToDefense()
            }
            jumpballAlert.addAction(lost)
            jumpballAlert.addAction(won)
            jumpballAlert.popoverPresentationController?.sourceView = view
            jumpballAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: CGPoint.init(x: point.x, y: point.y + 50), size: CGSize.init())
            present(jumpballAlert, animated: false)
        }
        else{
            gameState["possession"] = gameState["possessionArrow"]
            if (gameState["possessionArrow"] as! String == "defense"){ gameState["possessionArrow"] = "offense" }
            else if (gameState["possessionArrow"] as! String == "offense"){ gameState["possessionArrow"] = "defense" }
        }
    }
    
    func fullLineup() -> Bool {
        let active = gameState["active"] as! [Player?]
        for player in active {
            if player == nil {
                return false
            }
        }
        return true
    }
    
    @IBAction func handleTap(_ tapHandler: UITapGestureRecognizer) {
        benchView.isHidden = true
        if gameState["began"] as! Bool {
            if let view = tapHandler.view {
                switch (view.tag){
                    case 0: shoot()
                        break;
                    case 1, 2, 3, 4, 5:
                        if gameState["ballIndex"] as! Int == view.tag { dribble() }
                        else { pass(to: view.tag) }
                        break;
                    default: break;
                }
            }
        }
    }
    
    func shoot() {
        UIView.setAnimationsEnabled(false)
        self.performSegue(withIdentifier: "shotchartSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shotchartSegue" {
            if let shotChartView = segue.destination as? ShotChartViewController {
                shotChartView.gameState = self.gameState
            }
        }
    }
    
    func dribble() {
        let index = gameState["ballIndex"] as! Int
        var active = gameState["active"] as! [Player?]
        let dribbler = active[index]!
        dribbler.dribble()
    }
    
    func pass(to: Int) {
        let index = gameState["ballIndex"] as! Int
        var active = gameState["active"] as! [Player?]
        let passer = active[index]!
        gameState["ballIndex"] = to
        gameState["assistingPlayerIndex"] = index
        passer.pass()
    }
    
    func handleRebound(){
        let reboundAlert = UIAlertController(title: "Offensive Rebound?", message: "", preferredStyle: .actionSheet)
        var activePlayer: UIAlertAction
        var i = 0
        for player in gameState["active"] as! [Player?] {
            let fname = player?.firstName
            let lname = player?.lastName
            activePlayer = UIAlertAction(title: "\(fname!) \(lname!)", style: UIAlertActionStyle.default) { UIAlertAction in
                player?.updateOffRebounds(rebounds: 1)
                self.gameState["ballIndex"] = i
            }
            reboundAlert.addAction(activePlayer)
            i += 1
        }
        let defensive = UIAlertAction(title: "No", style: UIAlertActionStyle.default) { UIAlertAction in
            
        }
        reboundAlert.addAction(defensive)
        reboundAlert.popoverPresentationController?.sourceView = view
        reboundAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: imageHoop.center, size: CGSize.init())
        present(reboundAlert, animated: true)
    }
    
    //long press detected, display offensive player options
    @IBAction func handleLongPress(_ touchHandler: UILongPressGestureRecognizer) {
        benchView.isHidden = true
        let point = touchHandler.location(in: containerView)
        let index = touchHandler.view?.tag ?? 0
        if touchHandler.state == .began {
            presentOffensiveOptions(point: point, index: index)
        }
    }
    
    //return whether player is on the floor currently or not
    func isActive(pid: String) -> Bool{
        for player in activePlayerIdStrings {
            if (player == pid){
                return true
            }
        }
        return false
    }
    
    //pass detected, record and update ballIndex
    func handlePass(passingPlayerIndex: Int, receivingPlayerIndex: Int){
        if passingPlayerIndex - 1 == gameState["ballIndex"] as! Int {
            gameState["assistingPlayerIndex"] = passingPlayerIndex - 1
            gameState["ballIndex"] = receivingPlayerIndex - 1
        }
    }
    
    //turnover recorded, change possession
    func handleTurnover(index: Int){
        let playerObject = self.activePlayerObjects[index - 1]! as Player
        playerObject.updateTurnovers(turnovers: 1)
        switchToDefense()
    }
    
    @IBAction func handleCharge(_ sender: UIButton) {
        if gameState["began"] as! Bool {
            let playerObject = activePlayerObjects[gameState["ballIndex"] as! Int]! as Player
            playerObject.updatePersonalFouls(fouls: 1)
        }
    }
    
    @IBAction func handleTechFoul(_ sender: UIButton) {
        let position = panEndPoint
        let popupForTechFoul = UIAlertController(title: "Offensive Rebound?", message: "", preferredStyle: .actionSheet)
        
        var activePlayer: UIAlertAction
        for player in activePlayerObjects {
            let fname = player?.firstName
            let lname = player?.lastName
            activePlayer = UIAlertAction(title: "\(fname!) \(lname!)", style: UIAlertActionStyle.default) {
                UIAlertAction in
                player?.updateTechFouls(fouls: 1)
                print("Success: techincal foul recorded for \(fname!)")
            }
            popupForTechFoul.addAction(activePlayer)
        }
        
        let coachOption = UIAlertAction(title: "Coach", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("Success: recognized coach technical foul")
        }
        popupForTechFoul.addAction(coachOption)
        let popover = popupForTechFoul.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect.init(origin: position, size: CGSize.init())
        present(popupForTechFoul, animated: true)
    }
    
    func switchToDefense() {
        
    }
    
    @IBAction func showGameSummary(_ sender: UIButton) {
        
    }
    
    @IBAction func handleOutOfBounds(_ sender: UIButton) {
        
    }
    
    @IBAction func handleTimeout(_ sender: UIButton) {
        
    }
    
    //foul detected, determine outcome and either change possession or record FT attempts/makes
    func handleFoul(index: Int){
        let playerObject = self.activePlayerObjects[index - 1]! as Player
        playerObject.updatePersonalFouls(fouls: 1)
        let fouls = gameState["teamFouls"] as! Int
        gameState["teamFouls"] = fouls + 1
    }
    
    func getPlayerObject(pid: String) -> Player {
        for player in gameState["roster"] as! [Player] {
            if (player.playerId == pid){
                return player
            }
        }
        return Player(firstName: "", lastName: "", photo: nil, position: "", height: "", weight: "", rank: "", playerId: "", teamId: "")
    }
    
    
    
    
    
    
    
    
    //FIREBASE DATA SYNC FUNCTIONALITY BELOW
    
    func syncAllPlayerObjectsToFirebase(){
        syncSinglePlayerObjectToFirebase(index: 1)
        syncSinglePlayerObjectToFirebase(index: 2)
        syncSinglePlayerObjectToFirebase(index: 3)
        syncSinglePlayerObjectToFirebase(index: 4)
        syncSinglePlayerObjectToFirebase(index: 5)
        print("Success: player data recorded in remote database")
    }
    
    @IBAction func sync(_ sender: UIButton) {
        syncAllPlayerObjectsToFirebase()
    }
    
    func syncSinglePlayerObjectToFirebase(index: Int){
        let playerObject = self.activePlayerObjects[index - 1]! as Player
        let playerData : [String: Any] = ["pid":  playerObject.playerId,
                                          "tid": playerObject.teamId,
                                          "fname": playerObject.firstName,
                                          "lname": playerObject.lastName,
                                          "photo": "",
                                          "height": playerObject.height,
                                          "weight": playerObject.weight,
                                          "rank": playerObject.rank,
                                          "position": playerObject.position,
                                          "points": playerObject.points,
                                          "assists": playerObject.assists,
                                          "turnovers": playerObject.turnovers,
                                          "threePtAtt": playerObject.threePtAtt,
                                          "twoPtAtt": playerObject.twoPtAtt,
                                          "threePtMade": playerObject.threePtMade,
                                          "twoPtMade": playerObject.twoPtMade,
                                          "ftAtt": playerObject.ftAtt,
                                          "ftMade": playerObject.ftMade,
                                          "offRebounds": playerObject.offRebounds,
                                          "defRebounds": playerObject.defRebounds,
                                          "steals": playerObject.steals,
                                          "blocks": playerObject.blocks,
                                          "deflections": playerObject.deflections,
                                          "personalFoul": playerObject.personalFoul,
                                          "techFoul": playerObject.techFoul,
                                          "chargesTaken": playerObject.chargesTaken]
        let firebaseRef = Database.database().reference(withPath: "teams")
        let teamRosterRef = firebaseRef.child(playerObject.teamId).child("roster")
        teamRosterRef.child(playerObject.playerId).setValue(playerData)
    }
    
    
    
    
    
    
    
    // TIMER FUNCTIONALITY BELOW
    
    func restart(){
        // Invalidate timer
        timer?.invalidate()
        
        // Reset timer variables
        startTime = 0
        time = 0
        elapsed = 0
        
        // Reset all labels
        let strMinutes = String(format: "%02d", quarterTime)
        labelMinute.text = strMinutes
        labelSecond.text = "00"
    }
    func start() {
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func stop() {
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
    }
    
    @objc func updateCounter() {
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = Int(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        let minutes2 = quarterTime - minutes - 1
        
        // Calculate seconds
        let seconds = Int(59.0) - Int(time)
        time -= TimeInterval(seconds)
        
        if(minutes2 == 0 && seconds == 0){
            stop()
        }
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes2)
        let strSeconds = String(format: "%02d", seconds)
        
        // Add time vars to relevant labels
        labelMinute.text = strMinutes
        labelSecond.text = strSeconds
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
