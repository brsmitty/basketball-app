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

/** Controls all functionality of the game view */
class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet var playerOneLongPress: UILongPressGestureRecognizer!

    weak var timer: Timer?
    var time: Double = 0
    var timeSeconds: Double = 0
    var elapsed: Double = 0
    var status: Bool = true
    var quarterTime: Int = 10
    var firebaseRef:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var uid: String = UserDefaults.standard.string(forKey: "uid") ?? ""
    var tid: String = UserDefaults.standard.string(forKey: "tid") ?? ""
    var gid: String = ""
    let storage = UserDefaults.standard
    var states : [String] = ["1ST", "2ND", "3RD", "4TH"]
    var currentLineup: String?

    var blurView: UIVisualEffectView?
    let paintButton = UIButton()
    let addOppButton = UIButton()

    struct foulObject {
        var player: Player
        var numberOfShots: Int
        var foulType: String
        var bonus: Bool
    }
    var gameState: [String: Any] = ["began": false,
                                    "transitionState": "init",
                                    "possession": "",
                                    "currentlyPaused": false,
                                    "possessionArrow": "",
                                    "teamFouls": 0,
                                    "oppTeamFouls": 0,
                                    "ballIndex": 999,
                                    "assistingPlayerIndex": 999,
                                    "stateIndex": -1,
                                    "quarterIndex": "1ST",
                                    "startTime": 0.0,
                                    "time": 0.0,
                                    "elapsed": 0.0,
                                    "status": false,
                                    "homeScore": 0,
                                    "timer": Timer(),
                                    "roster": [],
                                    "active": [],
                                    "bench": [],
                                    "lineups": [],
                                    "playSequence": [],
                                    "shots": [],
                                    "oppCharges": 0,
                                    "score": 0,
                                    "oppScore": 0,
                                    "halfTimeouts": 2,
                                    "fullTimeouts": 3,
                                    "oppHalfTimeouts": 2,
                                    "oppFullTimeouts": 3,
                                    "oppAnd1": false,
                                    "oppWasFouled" : false,
                                    "and1Display" : false,
                                    "missedFinalFT" : false, //if last foul shot was missed
                                    "opponent": [:] as [String: [String: Any]],
                                    "dribbles": [:] as [String: Int]]
    var panStartPoint = CGPoint() //beginning point of any given pan gesture
    var panEndPoint = CGPoint() //end point of any given pan gesture
    let boxHeight : CGFloat = 100.0 //constant for the height of the hit box for a player
    let boxWidth : CGFloat = 100.0 //constant for the width of the hit box for a player
    let benchWidth : CGFloat = 100.0 //constant for the width of the hit box for a player
    let benchPictureHeight : Int = 100 //constant for the width of the hit box for a player
    var boxRects : [CGRect] = [CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init(), CGRect.init()] //array of rectangles for hit boxes of hoop, PG, SG, SF, PF, C
    var currentPath = IndexPath()
    var paths:[IndexPath] = [IndexPath]()
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var timeOutsLeft: UILabel!
    @IBOutlet weak var timeOutsLeftDefense: UILabel!
    @IBOutlet weak var homePossession: UILabel!
    @IBOutlet weak var awayPossession: UILabel!
    @IBOutlet weak var homeFouls: UILabel!
    @IBOutlet weak var awayFouls: UILabel!
    @IBOutlet weak var gameStateBoard: UILabel!
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
    @IBOutlet weak var turnoverButton: UIButton!
    @IBOutlet weak var outOfBoundsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gameBoardImageView: UIImageView!
    
    var offenseCourtTransform: CGAffineTransform?
    var defenseCourtTransform: CGAffineTransform?
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        benchView.isHidden = true
        if(offenseCourtTransform == nil){
            offenseCourtTransform = courtView.transform
            defenseCourtTransform = courtView.transform.rotated(by: .pi)
        }

        let state = gameState["transitionState"] as! String
        print("The game state is \(state)")
        if (state == "init" ) { getRosterFromFirebase() }
        else if (state == "missedShot") {
            gameState["transitionState"] = "inProgress"
            populateBench()
            populateActive()
            handleRebound()
        }
        else if (state == "madeShot") {
            gameState["transitionState"] = "inProgress"
            populateBench()
            populateActive()
            if(gameState["possession"] as! String == "offense"){
                switchToDefense()
            } else if let score = gameState["opponentScored"] as? Int {
                gameState["opponentScored"] = nil
                if score == 2 {
                    selectOpposingPlayer(stat: .score2)
                } else if score == 3 {
                    selectOpposingPlayer(stat: .score3)
                } else {
                    switchToOffense()
                }
            }
        }
        else if (state == "freethrow") {
            gameState["transitionState"] = "inProgress"
            populateBench()
            populateActive()
            
            //first check if final free throw was missed, if not do normal possession switch
            if(gameState["missedFinalFT"] as! Bool == true){
                /*
                 This is an attempt to mitigate a bug. Without this, a bug occurs when the
                 opponent misses their last free throw and the player gets a defensive rebound.
                 It first prompts for blame on the foul, but then the rebound prompt goes over that,
                 and as a result of choosing defensive for the rebound it overlays a second blur view
                 asking for responsibility for the rebound. This causes the game to break and the only
                 way to fix it is to start over. Additionally, without this line, the blame text for who
                 committed the foul would be upside down whenever the opponent missed the last free throw.
                 
                 As a result of this mitigation the only issue is that it does not ask who committed the foul
                 when the opponent misses their last foul shot. - Alex Jacobs 4/8
                */
                if(gameState["possession"] as! String == "defense"){
                    //clear last blurview
                    if let blurView = self.blurView {
                        blurView.removeFromSuperview()
                        self.blurView = nil
                        buttonsEnabled(true)
                    }
                }
                
                //go to rebound logic
                gameState["missedFinalFT"] = false
                handleRebound()
            }else{
                if(gameState["possession"] as! String == "offense"){
                    switchToDefense()
                } else {
                    switchToOffense()
                }
            }
        } else if(state == "shotFoul"){
            /* if foul occured while taking a shot */
            gameState["transitionState"] = "inProgress"
            populateBench()
            populateActive()
            if(gameState["possession"] as! String == "offense"){
                let active = gameState["active"] as! [Player]
                let index = gameState["ballIndex"] as! Int
                handleFoul(player: active[index], userFoul: false, shotFoul: true)
            } else {
                // need to get which player committed the shooting foul
                let active = gameState["active"] as! [Player]
                let index = gameState["ballIndex"] as! Int
                handleFoul(player: active[index], userFoul: true, shotFoul: true)
            }
        } else if (state == "shotMadeFoul") {
            /* if foul occured while taking a shot & shot was made */
            gameState["transitionState"] = "inProgress"
            gameState["and1Display"] = true
            populateBench()
            populateActive()
            if gameState["possession"] as? String ?? "" == "offense" {
                let active = gameState["active"] as! [Player]
                let index = gameState["ballIndex"] as! Int
                handleFoul(player: active[index], userFoul: false, shotFoul: true)
            } else {
                gameState["oppAnd1"] = true;
                if let score = gameState["opponentScored"] as? Int {
                    gameState["opponentScored"] = nil
                    if score == 2 {
                        selectOpposingPlayer(stat: .score2)
                    } else if score == 3 {
                        selectOpposingPlayer(stat: .score3)
                    } else {
                        switchToOffense()
                    }
                }

                // need to get which player committed the shooting foul
                let active = gameState["active"] as! [Player]
                let index = gameState["ballIndex"] as! Int
                handleFoul(player: active[index], userFoul: true, shotFoul: true)
            }
        }
        /* No transitions, simply switch to show possession */
        if((state==nil || state.count==0) && gameState["possession"] != nil){
            if(gameState["possession"] as! String == "offense"){
                self.switchToOffense()
            } else if (gameState["possession"] as! String == "defense"){
                self.switchToDefense()
            }
        }

        if (gameState["began"] as! Bool){
            let userScore = gameState["homeScore"] as? Int ?? 0
            homeScore.text = String(format: "%02d", userScore)

            let oppScore = gameState["oppScore"] as? Int ?? 0
            awayScore.text = String(format: "%02d", oppScore)

            if((gameState["homeScore"] as! Int) < 10){
                self.homeScore.text! = "0" + String(gameState["homeScore"] as! Int)
            }
            else{
                self.homeScore.text! = String(gameState["homeScore"] as! Int)
            }
            if((gameState["oppScore"] as! Int) < 10){
                self.awayScore.text! = "0" + String(gameState["oppScore"] as! Int)
            }
            else{
                self.awayScore.text! = String(gameState["oppScore"] as! Int)
            }
            gameStateBoard.text = gameState["quarterIndex"] as? String
            self.time = gameState["time"] as! Double
            self.elapsed = gameState["elapsed"] as! Double
            self.status = true
            start()
        }

        let styleButton = UIButton()
        styleButton.translatesAutoresizingMaskIntoConstraints = false
        styleButton.setTitleColor(.white, for: .normal)
        styleButton.setTitle("Style", for: .normal)
        styleButton.addTarget(self, action: #selector(showStyleOptions), for: .touchUpInside)
        styleButton.tag = 246
        view.addSubview(styleButton)

        NSLayoutConstraint.activate([
            styleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            styleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            styleButton.widthAnchor.constraint(equalToConstant: 80),
            styleButton.heightAnchor.constraint(equalToConstant: 60)
            ])

        addOppButton.translatesAutoresizingMaskIntoConstraints = false
        addOppButton.setTitleColor(.white, for: .normal)
        addOppButton.setTitle("Add Opponent Player", for: .normal)
        addOppButton.addTarget(self, action: #selector(addOpponentPlayer), for: .touchUpInside)
        view.addSubview(addOppButton)

        NSLayoutConstraint.activate([
            addOppButton.trailingAnchor.constraint(equalTo: styleButton.leadingAnchor, constant: -20),
            addOppButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
//            addOppButton.widthAnchor.constraint(equalToConstant: 120),
            addOppButton.heightAnchor.constraint(equalToConstant: 60)
            ])

        paintButton.translatesAutoresizingMaskIntoConstraints = false
        paintButton.backgroundColor = .clear
        paintButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleThreeSecondViolation(_:))))
        courtView.addSubview(paintButton)
        
        gameBoardImageView.isUserInteractionEnabled = true
        gameBoardImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handlePauseGameClock)))

        NSLayoutConstraint.activate([
            paintButton.centerXAnchor.constraint(equalTo: courtView.centerXAnchor, constant: 5),
            paintButton.widthAnchor.constraint(equalToConstant: 225),
            paintButton.heightAnchor.constraint(equalToConstant: 275),
            paintButton.topAnchor.constraint(equalTo: courtView.topAnchor, constant: 20)
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserId()

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
        turnoverButton.layer.cornerRadius = 5
        outOfBoundsButton.layer.cornerRadius = 5

        //Set the timer
        let strMinutes = String(format: "%02d", self.quarterTime)
        self.labelMinute.text = strMinutes
        getTimerSet()
        labelSecond.text = "00"
        roundImages()

        tableView.delegate = self
        tableView.dataSource = self
        gameStateBoard.text = states[0]

        if (gameState["possession"] as! String == "defense") {
            switchToDefense()
        }
    }

    /** Get the user id and set it to the user id global variable*/
    func getUserId(){
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let uId = user?.uid else {return}
                self.uid = uId
            }
        }
    }

    func gameIsUsers(_ lid:String)-> Bool{
        var isUsers = false
        let lineupId = lid.prefix(28)
        isUsers = lineupId == uid
        return isUsers
    }
    
    //MARK: ???
    func getTimerSet(){
        firebaseRef = Database.database().reference()
        print("timer")
        databaseHandle = firebaseRef?.child("timer").observe(.childAdded, with: { (snapshot) in
            // If the player is one of the users players add it to the table
            if(self.gameIsUsers(snapshot.key)){
                // take data from the snapshot and add a player object
                var temp = 0
                temp = snapshot.childSnapshot(forPath: "quarter").value as! Int
                if(temp != 0){
                    self.quarterTime = temp
                    let strMinutes = String(format: "%02d", self.quarterTime)
                    self.labelMinute.text = strMinutes
                }
            }
            })
    }

    /** makes images rounded*/
    func roundImages(){
        imagePlayer1.layer.cornerRadius = imagePlayer1.frame.size.width/2
        imagePlayer1.clipsToBounds = true

        imagePlayer2.layer.cornerRadius = imagePlayer1.frame.size.width/2
        imagePlayer2.clipsToBounds = true

        imagePlayer3.layer.cornerRadius = imagePlayer1.frame.size.width/2
        imagePlayer3.clipsToBounds = true

        imagePlayer4.layer.cornerRadius = imagePlayer1.frame.size.width/2
        imagePlayer4.clipsToBounds = true

        imagePlayer5.layer.cornerRadius = imagePlayer1.frame.size.width/2
        imagePlayer5.clipsToBounds = true
    }


    /** accesses database to get game roster*/
    func getRosterFromFirebase(){
        DBApi.sharedInstance.getPlayers { [weak self] players in
            guard let s = self else { return }

            s.gameState["roster"] = players
            s.gameState["bench"] = players
            s.gameState["active"] = [Player?](repeating: nil, count: 5)

            var indexPaths = [IndexPath]()
            for i in 0..<players.count {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            s.paths = indexPaths
            s.currentPath = indexPaths.last ?? IndexPath(row: 0, section: 0)

            s.populateBench()
            s.tableView.beginUpdates()
            s.tableView.insertRows(at: s.paths, with: .automatic)
            s.tableView.endUpdates()
        }
    }

    /** creates player objects using data pulled from roster in database*/
    func createPlayerObjectsFromRoster(roster: [String: Any]){
        var i: Int = 0
        var players : [Player] = []
        for player in roster {

            let p = player.value as! [String: Any]

            let imageName = (p["fname"] as! String) + (p["lname"] as! String) + "image"
            let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
            let imageURL: URL = URL(fileURLWithPath: imagePath)
            guard FileManager.default.fileExists(atPath: imagePath),
                let imageData: Data = try? Data(contentsOf: imageURL),
                let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) else {
                    return
            }
            let photo = image

            let playerObject = Player(firstName: p["fname"] as! String,
                                      lastName: p["lname"] as! String,
                                      photo: photo,
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
                                      chargesTaken: p["chargesTaken"] as! Int,
                                      shotLocation: p["shotLocation"] as! [[Double]])
            players.append(playerObject)

            i += 1

            self.currentPath = IndexPath(row:players.count - 1, section: 0)

            paths.append(self.currentPath)

        }

        //REMOVE FOR DEMO///
        //self.gameState["active"] = [players[0], players[1], players[2], players[3], players[4]]
        //populateActive()
    }

    //MARK: Update Upponent Functions
    //Only in-game not on database
    /**add an opponent player to the game**/
    @objc func addOpponentPlayer() {
        let alert = UIAlertController(title: "Add Opponent Player", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = UIKeyboardType.numberPad
            textField.placeholder = "Jersey Number"
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            if let textField = (alert.textFields ?? []).first,
                let number = Int(textField.text ?? "") {
                self.insertOpponentPlayer(number: number)
            }
        }))
        alert.addAction(UIAlertAction(title: "Add Another", style: .default, handler: { action in
            if let textField = (alert.textFields ?? []).first,
                let number = Int(textField.text ?? "") {
                self.insertOpponentPlayer(number: number)
            }
            self.addOpponentPlayer()
        }))
        present(alert, animated: true)
    }

    /** insert the opponent player  given player number*/
    func insertOpponentPlayer(number: Int) {
        var opp = gameState["opponent"] as? [String: [String: Any]] ?? [:]
        opp["\(number)"] = [
            "points": 0,
            "rebounds": 0,
            "turnovers": 0
            ] as [String: Any]
        gameState["opponent"] = opp

        //updateOpponent()
    }

    /** store the opponent's rebound given their player number*/
    func storeOpponentRebound(number: Int) {
        var opp = gameState["opponent"] as? [String: [String: Any]] ?? [:]
        var oppPlayer = opp["\(number)"] ?? [:]
        let rebs = oppPlayer["rebounds"] as? Int ?? 0
        oppPlayer["rebounds"] = rebs + 1
        opp["\(number)"] = oppPlayer
        gameState["opponent"] = opp

        //updateOpponent()
        pushPlaySequence(event: "#\(number) recorded a rebound")
    }
    
    //Needs to store opponent stats
    /** store the opponent's points given the type of score, player number, and seconds*/
    func storeOpponentPoints(type: Statistic, number: Int, seconds: Double) {
        let opp = gameState["opponent"] as? [String: [String: Any]] ?? [:]
        //let oppPlayer = opp["\(number)"] ?? [:]
        //let pts = oppPlayer["points"] as? Int ?? 0
        //oppPlayer["points"] = pts + points
        switch type{
            case .score2:
           DBApi.sharedInstance.adjustScore(type: Statistic.score2, pid: "", seconds: seconds, tid: UserDefaults.standard.string(forKey: "oppId")!)
            case .score3:
                 DBApi.sharedInstance.adjustScore(type: Statistic.score3, pid: "", seconds: seconds, tid: UserDefaults.standard.string(forKey: "oppId")!)
            case .freeThrow:
                DBApi.sharedInstance.adjustScore(type: Statistic.freeThrow, pid: "", seconds: seconds, tid: UserDefaults.standard.string(forKey: "oppId")!)
            default: break
        }
        
        //opp["\(number)"] = oppPlayer
        gameState["opponent"] = opp

        //updateOpponent()
        pushPlaySequence(event: "#\(number) recorded a point score")
    }

    /** record opponent turnover given player number*/
    func storeOpponentTurnover(number: Int) {
        var opp = gameState["opponent"] as? [String: [String: Any]] ?? [:]
        var oppPlayer = opp["\(number)"] ?? [:]
        let turns = oppPlayer["turnovers"] as? Int ?? 0
        oppPlayer["points"] = turns + 1
        opp["\(number)"] = oppPlayer
        gameState["opponent"] = opp

        //updateOpponent()
        pushPlaySequence(event: "#\(number) recorded a turnover")
    }
    
    //Left here for expandability
    /*
    func updateOpponent() {
        let opponent = gameState["opponent"] as? [String: [String: Any]] ?? [:]
        let oppScore = gameState["oppScore"] as? Int ?? 0
        DBApi.sharedInstance.updateOpponentStats(to: opponent, score: oppScore)
    }
    */
    
    @IBOutlet weak var displayLabel: UILabel!
    func pushPlaySequence(event: String) {
        var playSequence = gameState["playSequence"] as! [String]
        playSequence.append(event)
        gameState["playSequence"] = playSequence
        displayLabel.text = event
    }

    func printPlaySequence() -> String {
        var playSequence = ""
        for event in gameState["playSequence"] as! [String] {
            playSequence += event + "\n"
        }
        return playSequence
    }

    /** add players to bench*/
    func populateBench(){
        var i = 0
        for view in benchView.subviews {
            if i >= 1 {
                view.removeFromSuperview()
            }
            i += 1
        }
        var y = 0
        for player in gameState["bench"] as! [Player] {
            print("Adding player to bench")
            let image = player.photo
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: y, width: 100, height: benchPictureHeight)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = imagePlayer1.frame.size.width/2
            imageView.clipsToBounds = true
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSubstitutionGesture(recognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(panGesture)
            benchView.addSubview(imageView)
            y += benchPictureHeight
        }
    }

    func populateActive() {
        var playerImages = [imagePlayer1, imagePlayer2, imagePlayer3, imagePlayer4, imagePlayer5]
        var i = 0
        for player in gameState["active"] as! [Player] {
            playerImages[i]!.image = player.photo
            i += 1
        }
    }

    /** show the bench view*/
    @IBAction func showBench(_ sender: UIButton) {
        benchView.isHidden = false
        benchView.frame = CGRect(x: -self.benchWidth, y: 0, width: self.benchWidth, height: 595)
        UIView.animate(withDuration: 0.3, animations: {
            self.benchView.frame = CGRect(x: 0, y: 0, width: self.benchView.frame.width, height: 595)
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func pauseStartClock(_ sender: UITapGestureRecognizer) {
  
    }

    /** hide view of bench*/
    @IBAction func hideBench(_ sender: UITapGestureRecognizer) {
        if (sender.location(in: containerView).x > benchView.frame.width) {
            UIView.animate(withDuration: 0.3, animations: {
                self.benchView.frame = CGRect(x: -self.benchWidth, y: 0, width: self.benchView.frame.width, height: 595)
                self.view.layoutIfNeeded()
            }, completion: {(finished) -> Void in
                self.benchView.isHidden = true
            })
        }
    }
    
    //MARK: NEEDS TO BE FIXED TO HANDLE SUBSTITUTIONS PROPERLY
    @IBAction func handleSubstitutionGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: containerView)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .began {
            self.panStartPoint = recognizer.location(in: benchView)
        }
        if recognizer.state == .ended { //drag gesture has ended
            self.panEndPoint = recognizer.location(in: containerView)
            var activePlayers = [Player?](repeating: nil, count: 5)
            var index = 0
            self.currentPath = IndexPath(row: index, section: 0)
            tableView.deleteRows(at: [self.currentPath], with: .fade)
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
                pushPlaySequence(event: "\(playerSubbingIn.firstName) subbed in")

                let full = !activePlayers.contains(where: { $0 == nil })
                //if full {
                    //let lineupIds = activePlayers.map { $0?.playerId ?? "" }
                    //DBApi.sharedInstance.switchLineup(to: DBApi.lineupId(from: lineupIds) ?? "", at: Int(timeSeconds))
                //}

                if (playerSubbingOut != nil) {
                    benchPlayers[benchIndex] = playerSubbingOut!
                    pushPlaySequence(event: "\(playerSubbingOut!.firstName) subbed out")
                } else {
                    benchPlayers.remove(at: benchIndex)
                }
                getPlayerImage(index: activeIndex).image = activePlayers[activeIndex]?.photo
                gameState["active"] = activePlayers
                gameState["bench"] = benchPlayers
                if (fullLineup()) { saveLineup() }
                populateBench()
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

    /** displays offensive options*/
    func presentOffensiveOptions(index: Int){
        let offenseAlert = UIAlertController(title: "Not enough players on court", message: "", preferredStyle: .actionSheet)
        
        let foul = UIAlertAction(title: "Personal Foul", style: UIAlertActionStyle.default) { UIAlertAction in self.handleFoul(player: self.player(i: index), userFoul: true) }
        
        let fouled = UIAlertAction(title: "Was Fouled", style: UIAlertActionStyle.default) { UIAlertAction in self.handleFoul(player: self.player(i: index), userFoul: false) }
        
        let techFoul = UIAlertAction(title: "Technical Foul", style: UIAlertActionStyle.default) { UIAlertAction in self.handleTechFoul(index: index) }
        
        let jumpball = UIAlertAction(title: "Jump Ball", style: UIAlertActionStyle.default) { UIAlertAction in self.handleJumpball(index: index) }
        
        if (fullLineup()){
            
            //Update offenseAlert as the game starts
            offenseAlert.title = "Line up is full"
            offenseAlert.message = "Lets start the game!"
            offenseAlert.addAction(jumpball)
            
            if (gameState["began"] as! Bool){
                offenseAlert.addAction(foul)
                offenseAlert.addAction(fouled)
                offenseAlert.addAction(techFoul)
            }
        }
        
        offenseAlert.popoverPresentationController?.sourceView = view
        let c = getPlayerImage(index: index).center
        let y = CGFloat(c.y + 100)
        let p = CGPoint(x: c.x, y: y)
        offenseAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: p, size: CGSize.init())
        present(offenseAlert, animated: false)
    }

    /** handles logic for a jump ball*/
    func handleJumpball(index: Int){
        print("Possession: \(self.gameState["possession"] ?? "")")
        print("Arrow     : \(self.gameState["possessionArrow"] ?? "")")
        if(status){
            restart()
            self.gameState["stateIndex"] = self.gameState["stateIndex"] as! Int + 1
            gameStateBoard.text = states[self.gameState["stateIndex"] as! Int]
            self.gameState["quarterIndex"] = gameStateBoard.text
        }
        start()
        if (gameState["began"] as! Bool == false){
            
            DBApi.sharedInstance.createGames()
            
            gameState["began"] = true
            gameState["ballIndex"] = index
            let jumpballAlert = UIAlertController(title: "Outcome", message: "", preferredStyle: .actionSheet)
            let won = UIAlertAction(title: "Won", style: UIAlertActionStyle.default) { UIAlertAction in
                self.gameState["possession"] = "offense"
                self.gameState["possessionArrow"] = "defense"
                self.addBorderToActivePlayer(index)
                let active = self.gameState["active"] as! [Player]
                DBApi.sharedInstance.storeStat(type: Statistic.jumpBallWon, pid: active[index].playerId, seconds: self.timeSeconds)
                print(active[index].playerId)
                self.pushPlaySequence(event: "\(active[index].firstName) won the jump ball")
                self.homePossession.text! = ""
                self.awayPossession.text! = ">"
                //TODO delete after demo
            }
            let lost = UIAlertAction(title: "Lost", style: UIAlertActionStyle.default) { UIAlertAction in
                self.gameState["possessionArrow"] = "offense"
                let active = self.gameState["active"] as! [Player]
                self.pushPlaySequence(event: "\(active[index].firstName) lost the jump ball")
                self.homePossession.text! = "<"
                self.awayPossession.text! = ""
                //TODO delete after demo
                DBApi.sharedInstance.storeStat(type: .jumpBallLost, pid: "\(active[index].playerId)", seconds: self.timeSeconds)
                self.switchToDefense()
            }
            jumpballAlert.addAction(lost)
            jumpballAlert.addAction(won)
            jumpballAlert.popoverPresentationController?.sourceView = view
            let c = getPlayerImage(index: index).center
            let y = CGFloat(c.y + 100)
            let p = CGPoint(x: c.x,	 y: y)
            jumpballAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: p, size: CGSize.init())
            present(jumpballAlert, animated: false)
        }
        else{
            gameState["possession"] = gameState["possessionArrow"]
            if (gameState["possessionArrow"] as! String == "defense"){
                self.pushPlaySequence(event: "jump ball, possession goes to the opponent")
                gameState["possessionArrow"] = "offense"
                self.homePossession.text! = "<"
                self.awayPossession.text! = ""
                switchToDefense()
            }
            else if (gameState["possessionArrow"] as! String == "offense"){
                gameState["possessionArrow"] = "defense"
                self.pushPlaySequence(event: "jump ball, possession goes to your team")
                self.homePossession.text! = ""
                self.awayPossession.text! = ">"
                switchToOffense()
            }
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

    func saveLineup () {
        var lineup: [String] = [];
        for player in gameState["active"] as! [Player] {
            lineup.append(player.playerId)
        }
        var lineups = gameState["lineups"] as! [[String]];
        lineups.append(lineup);
        gameState["lineups"] = lineups;
    }
    @IBOutlet weak var imageView: UIImageView!
    var coordinates = CGPoint.zero

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first{
            coordinates = touch.location(in: imageView)
            print(coordinates)
        }
    }
    @IBAction func handleTap(_ tapHandler: UITapGestureRecognizer) {
        print("Screen was tapped")
        benchView.isHidden = true
        if gameState["began"] as! Bool {
            if let view = tapHandler.view {
                switch (view.tag){
                case 5: shoot()
                break;
                case 0, 1, 2, 3, 4:
                    if let stat = gameState["selectingHomePlayerForStat"] as? Statistic,
                        let blurView = self.blurView {
                        print(stat)
                        buttonsEnabled(true)

                        let active = gameState["active"] as! [Player]
                        let player = active[view.tag]

                        if [.offRebound, .defRebound, .steal].contains(stat) {
                            addBorderToActivePlayer(view.tag)
                            gameState["ballIndex"] = view.tag
                        }

                        self.pushPlaySequence(event: "\(player.firstName) recorded a(n) \(stat.rawValue)")
                        DBApi.sharedInstance.storeStat(type: stat, pid: player.playerId, seconds: timeSeconds)

                        // REMOVE BLUR VIEW
                        blurView.removeFromSuperview()
                        self.blurView = nil

                        gameState["selectingHomePlayerForStat"] = nil
                        gameState["transitionState"] = "inProgress"

                        if [.defRebound, .steal, .chargeTaken].contains(stat) {
                            switchToOffense()
                        } else if [.turnover, .charge, .threeSecondViolation].contains(stat) {
                            switchToDefense()
                        }
                    }
                    else if gameState["possession"] as? String ?? "" == "offense" {
                        if gameState["ballIndex"] as! Int == (view.tag) { dribble() }
                        else { pass(to: view.tag) }
                    }
                    break;
                default: break;
                }
            }
        }
    }

    func shoot() {
        if (gameState["possession"] as! String == "offense") {
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "shotchartSegue", sender: nil)
        }
        else {
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "shotchartSegue", sender: nil)
          }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "shotchartSegue" {
            if let shotChartView = segue.destination as? ShotChartViewController {
                stop()
                self.gameState["time"] = self.time
                self.gameState["elapsed"] = self.elapsed
                self.gameState["status"] = self.status
                print(self.gameState["startTime"] as! Double)
                shotChartView.gameState = self.gameState
            }
        }
        else if segue.identifier == "freethrowSegue" {
            if let freethrowView = segue.destination as? FreethrowViewController {
                stop()
                self.gameState["time"] = self.time
                self.gameState["elapsed"] = self.elapsed
                self.gameState["status"] = self.status
                freethrowView.gameState = self.gameState
            }
        }
        else if segue.identifier == "mainMenu" {
            if let dest = segue.destination as? TeamSummaryViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
    }
    
    //Update the dribble stats of the player
    func dribble() {
        let index = gameState["ballIndex"] as! Int
        let active = gameState["active"] as! [Player?]
        guard let player = active[index] else { return }
        let dribbler = active[index]!
        dribbler.dribble()

        dribbleBorderRipple(index)
        addBorderToActivePlayer(index)
        self.pushPlaySequence(event: "\(active[index]!.firstName) dribbled")

        var dribbles = gameState["dribbles"] as? [String: Int] ?? [:]
        var count = dribbles[player.playerId] ?? 0
        count += 1
        dribbles[player.playerId] = count
        gameState["dribbles"] = dribbles

        if count % 2 == 0 {
            DBApi.sharedInstance.storeStat(type: .dribble, pid: dribbler.playerId, seconds: self.timeSeconds)
        }
    }

    func pass(to: Int) {
        if (gameState["possession"] as! String == "offense") {
            let index = gameState["ballIndex"] as! Int
            let active = gameState["active"] as! [Player?]
            let passer = active[index]!
            gameState["ballIndex"] = to
            gameState["assistingPlayerIndex"] = index
            addBorderToActivePlayer(to)
            passer.pass()
            self.pushPlaySequence(event: "\(passer.firstName) passed to \(active[to]!.firstName)")
            DBApi.sharedInstance.storeStat(type: .pass, pid: passer.playerId, seconds: timeSeconds)
        }
    }

    @objc func handleThreeSecondViolation(_ touchHandler: UILongPressGestureRecognizer) {
        if touchHandler.state == .began, gameState["began"] as? Bool ?? false {
            let possession = self.gameState["possession"] as? String ?? ""
            if (possession == "defense") {
                self.selectOpposingPlayer(stat: .turnover)
            } else if possession == "offense" {
                self.selectHomePlayer(stat: .threeSecondViolation, message: "Who committed the 3 sec. violation?")
            }
        }
    }
        //wait for next tapped player
    
    @objc func handlePauseGameClock(_ touchHandler: UILongPressGestureRecognizer) {
        guard gameState["began"] as? Bool == true else { return }
        if status {
            self.pushPlaySequence(event: "Game Un-Paused!")
            self.start()
        }
        else {
            self.pushPlaySequence(event: "Game Paused!")
            self.stop()
        }
    }

    func handleRebound(){
        let reboundAlert = UIAlertController(title: "Rebound", message: "", preferredStyle: .alert)
        let offensive = UIAlertAction(title: "Offensive", style: UIAlertActionStyle.default) { UIAlertAction in
            // wait for next tapped player...
            if self.gameState["possession"] as? String ?? "" == "offense" {
                self.selectHomePlayer(stat: .offRebound, message: "Who got the rebound?")
            } else {
                // select opposing player
                self.selectOpposingPlayer(stat: .offRebound)
            }
        }
        let defensive = UIAlertAction(title: "Defensive", style: UIAlertActionStyle.destructive) { UIAlertAction in
            if self.gameState["possession"] as? String ?? "" == "offense" {
                // select opposing player
                self.selectOpposingPlayer(stat: .defRebound)
            } else {
                self.selectHomePlayer(stat: .defRebound, message: "Who got the rebound?")
            }
        }
        reboundAlert.addAction(offensive)
        reboundAlert.addAction(defensive)
        reboundAlert.popoverPresentationController?.sourceView = view
        reboundAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: imageHoop.center, size: CGSize.init())
        present(reboundAlert, animated: true)
    }

    @IBAction func handleLongPress(_ touchHandler: UILongPressGestureRecognizer) {

        benchView.isHidden = true

        let index = touchHandler.view?.tag ?? 0
        if touchHandler.state == .began {
            let possession = self.gameState["possession"] as! String
            if (possession == "defense") {
                presentDefensiveOptions(index: index)
            } else {
                presentOffensiveOptions(index: index)
            }
        }

    }
    func presentDefensiveOptions(index: Int){

        let defenseAlert = UIAlertController(title: "Defensive Options", message: "", preferredStyle: .actionSheet)

        let foul = UIAlertAction(title: "Personal Foul", style: UIAlertActionStyle.default) { UIAlertAction in self.handleFoul(player: self.player(i: index), userFoul: true) }

        let fouled = UIAlertAction(title: "Was Fouled", style: UIAlertActionStyle.default) { UIAlertAction in self.handleFoul(player: self.player(i: index), userFoul: false) }

        let techFoul = UIAlertAction(title: "Technical Foul", style: UIAlertActionStyle.default) { UIAlertAction in self.handleTechFoul(index: index) }

        let jumpball = UIAlertAction(title: "Jump Ball", style: UIAlertActionStyle.default) { UIAlertAction in self.handleJumpball(index: index) }

        let block = UIAlertAction(title: "Block", style: UIAlertActionStyle.default) { UIAlertAction in self.handleBlock(player: self.player(i: index)) }

        let rebound = UIAlertAction(title: "Rebound", style: UIAlertActionStyle.default) { UIAlertAction in self.handleDefensiveRebound(player: self.player(i: index)) }


        if (fullLineup()){
            defenseAlert.addAction(jumpball)
            if (gameState["began"] as! Bool){
                defenseAlert.addAction(foul)
                defenseAlert.addAction(fouled)
                defenseAlert.addAction(techFoul)
                defenseAlert.addAction(block)
                defenseAlert.addAction(rebound)
            }
        }

        defenseAlert.popoverPresentationController?.sourceView = view
        let c = getPlayerImage(index: index).center
        let y = CGFloat(c.y + 100)
        let p = CGPoint(x: c.x, y: y)

        defenseAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: p, size: CGSize.init())

        present(defenseAlert, animated: false)

    }


    //foul detected, determine outcome and either change possession or record FT attempts/makes
    func handleFoul(player: Player, userFoul: Bool = false, shotFoul: Bool = false) {
        if userFoul { // user's team committed a foul
            var teamFouls = gameState["teamFouls"] as? Int ?? 0
            teamFouls += 1
            gameState["teamFouls"] = teamFouls

            let homeFoulsText = String(format: "%02d", teamFouls)
            homeFouls.text = homeFoulsText
            if teamFouls >= 7 || shotFoul {
                //set oppWasFouled to true so that the assignment text doesnt end up upside down
                gameState["oppWasFouled"] = true
                selectHomePlayer(stat: .personalFoul, message: "Who committed the foul?")
                //put the variable back to false
                gameState["oppWasFouled"] = false
                gameState["oppFreeThrow"] = true
                performSegue(withIdentifier: "freethrowSegue", sender: nil)
            }

            DBApi.sharedInstance.storeStat(type: .personalFoul, pid: player.playerId, seconds: self.timeSeconds)
            pushPlaySequence(event: "\(player.firstName) fouled")
        } else { // user's team was fouled
            var oppTeamFouls = gameState["oppTeamFouls"] as? Int ?? 0
            oppTeamFouls += 1
            gameState["oppTeamFouls"] = oppTeamFouls

            let awayFoulsText = String(format: "%02d", oppTeamFouls)
            awayFouls.text = awayFoulsText
            if oppTeamFouls >= 7 || shotFoul {
                gameState["fouledPlayer"] = player
                performSegue(withIdentifier: "freethrowSegue", sender: nil)
            }

            pushPlaySequence(event: "\(player.firstName) was fouled")
        }
    }

    @IBAction func handleTechFoul(index: Int) {
        if gameState["began"] as! Bool {
            let teamFouls = gameState["teamFouls"] as! Int
            gameState["teamFouls"] = teamFouls + 1
            if((gameState["teamFouls"] as! Int) < 9){
                self.homeFouls.text! = "0" + String(teamFouls + 1)
            }
            else{
                self.homeFouls.text! = String(teamFouls + 1)
            }
            gameState["fouledPlayerIndex"] = 999
            let techAlert = UIAlertController(title: "Turnover", message: "", preferredStyle: .actionSheet)
            var activePlayer: UIAlertAction
            for player in gameState["active"] as! [Player] {
                activePlayer = UIAlertAction(title: "\(player.firstName) \(player.lastName)", style: UIAlertActionStyle.default) { UIAlertAction in
                    let possession = self.gameState["possession"] as! String
                    if (possession == "offense") {

                    }
                    else if (possession == "defense") {

                    }
                    DBApi.sharedInstance.storeStat(type: Statistic.techFoul, pid: player.playerId, seconds: self.timeSeconds)
                    self.pushPlaySequence(event: "technical foul on \(player.firstName)")
                }
                techAlert.addAction(activePlayer)
            }
            techAlert.popoverPresentationController?.sourceView = view
            let c = turnoverButton.center
            let y = CGFloat(c.y + 100)
            let p = CGPoint(x: c.x, y: y)
            techAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: p, size: CGSize.init())
            present(techAlert, animated: false)
        }
    }

    @IBAction func handleCharge(_ sender: UIButton) {
        if gameState["began"] as! Bool {
            let possession = gameState["possession"] as! String
            if (possession == "offense") {
                let p = player(i: gameState["ballIndex"] as! Int)
                p.updatePersonalFouls(fouls: 1)
                self.pushPlaySequence(event: "\(p.firstName) charged")
                DBApi.sharedInstance.storeStat(type: .charge, pid: p.playerId, seconds: self.timeSeconds)
                switchToDefense()
            }
            else if (possession == "defense") {
                self.pushPlaySequence(event: "Opponent charged")

                self.selectHomePlayer(stat: .chargeTaken, message: "Who took the charge?")
                let opponentCharges = gameState["oppCharges"] as! Int
                gameState["oppCharges"] = opponentCharges + 1
            }
        }
    }
    //begin defensive handling
    func handleBlock(player: Player) {
        if gameState["began"] as! Bool {
            DBApi.sharedInstance.storeStat(type: .block, pid: player.playerId, seconds: timeSeconds)
            pushPlaySequence(event: "\(player.firstName) blocked a shot")
        }
    }
    func handleDefensiveRebound(player: Player) {
        if gameState["began"] as! Bool {
            DBApi.sharedInstance.storeStat(type: .defRebound, pid: player.playerId, seconds: timeSeconds)
            pushPlaySequence(event: "\(player.firstName) rebounded a shot")
            switchToOffense()
        }
    }

    @IBAction func handleTurnover(_ sender: UIButton) {
        let possession = gameState["possession"] as! String
        if (possession == "offense") {
            selectHomePlayer(stat: .turnover, message: "Who lost the ball?")
        } else if (possession == "defense") {
            selectOpposingPlayer(stat: .turnover)
            switchToOffense()
        }
    }

    @IBAction func handleOutOfBounds(_ sender: UIButton) {
        if gameState["began"] as! Bool {
            let outOfBoundsAlert = UIAlertController(title: "Last Touched By", message: "", preferredStyle: .actionSheet)
            let own = UIAlertAction(title: "Our Team", style: UIAlertActionStyle.default) { UIAlertAction in
                self.pushPlaySequence(event: "out of bounds on your team")
                let possession = self.gameState["possession"] as! String

                if (possession == "offense") {
                    self.switchToDefense()
                }
                else if (possession == "defense") {
                    self.stop()

                }
                self.selectHomePlayer(stat: .turnover, message: "Who lost the ball?")
            }
            let opponent = UIAlertAction(title: "Opponent", style: UIAlertActionStyle.default) { UIAlertAction in
                self.pushPlaySequence(event: "out of bounds on the opponent")
                let possession = self.gameState["possession"] as! String
                if (possession == "offense") {
                    self.stop()
                }
                else if (possession == "defense") {
                    self.switchToOffense()
                }
                self.selectOpposingPlayer(stat: .turnover)
            }

            outOfBoundsAlert.addAction(own)
            outOfBoundsAlert.addAction(opponent)
            outOfBoundsAlert.popoverPresentationController?.sourceView = view
            outOfBoundsAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: imageHoop.center, size: CGSize.init())
            present(outOfBoundsAlert, animated: true)
        }
    }

    @IBAction func handleTimeout(_ sender: UIButton) {
        if gameState["began"] as! Bool && gameState["currentlyPaused"] as! Bool == false{
            let possession = gameState["possession"] as! String

            let fullTimeouts = self.gameState["fullTimeouts"] as! Int
            let oppFullTimeouts = self.gameState["oppFullTimeouts"] as! Int
            let halfTimeouts = self.gameState["halfTimeouts"] as! Int
            let oppHalfTimeouts = self.gameState["oppHalfTimeouts"] as! Int

            let timeoutAlert = UIAlertController(title: "Timeout", message: "", preferredStyle: .actionSheet)
            let full = UIAlertAction(title: "60-second", style: UIAlertActionStyle.default) { UIAlertAction in
                if (possession == "offense") {
                    self.pushPlaySequence(event: "full timeout called, current full timeouts: " + String(fullTimeouts))
                    self.stop()
                    let temp = self.gameState["fullTimeouts"] as! Int
                    self.gameState["fullTimeouts"] = temp - 1
                    self.updateHomeTimeOuts()

                }
                else if (possession == "defense") {
                    self.pushPlaySequence(event: "full timeout called by opponent, current full timeouts: " + String(oppFullTimeouts))
                    self.stop()
                    self.gameState["oppFullTimeouts"] = oppFullTimeouts - 1
                    self.updateAwayTimeOuts()

                }
                self.timeoutButton.setTitle("Resume", for: UIControlState.normal)
            }
            let half = UIAlertAction(title: "30-second", style: UIAlertActionStyle.default) { UIAlertAction in
                if (possession == "offense") {
                    self.pushPlaySequence(event: "half timeout called, current half timeouts: " + String(halfTimeouts))
                    self.stop()
                    self.gameState["halfTimeouts"] = halfTimeouts - 1
                    self.updateHomeTimeOuts()
                }
                else if (possession == "defense") {
                    self.pushPlaySequence(event: "half timeout called by opponent, current half timeouts: " + String(oppHalfTimeouts))
                    self.stop()
                    self.gameState["oppHalfTimeouts"] = oppHalfTimeouts - 1
                    self.updateAwayTimeOuts()
                }
                self.timeoutButton.setTitle("Resume", for: UIControlState.normal)
            }

            let hasFullTimeouts = (possession == "offense" && fullTimeouts > 0) || (possession == "defense" && oppFullTimeouts > 0)
            let hasHalfTimeouts = (possession == "offense" && halfTimeouts > 0) || (possession == "defense" && oppHalfTimeouts > 0)

            if (hasFullTimeouts) { timeoutAlert.addAction(full) }
            if (hasHalfTimeouts) { timeoutAlert.addAction(half) }
            timeoutAlert.popoverPresentationController?.sourceView = view
            let c = timeoutButton.center
            let y = CGFloat(c.y + 100)
            let p = CGPoint(x: c.x, y: y)
            timeoutAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: p, size: CGSize.init())
            present(timeoutAlert, animated: false)
        } else if(gameState["currentlyPaused"] as! Bool == true){
           start()
        }
    }

    func updateHomeTimeOuts() {
        if(((self.gameState["fullTimeouts"] as! Int) +  (self.gameState["halfTimeouts"] as! Int)) == 4){
            self.timeOutsLeft.text! = "* * * *"
        } else if(((self.gameState["fullTimeouts"] as! Int) +  (self.gameState["halfTimeouts"] as! Int)) == 3){
            self.timeOutsLeft.text! = "* * *"
        } else if(((self.gameState["fullTimeouts"] as! Int) +  (self.gameState["halfTimeouts"] as! Int)) == 2){
            self.timeOutsLeft.text! = "* *"
        } else if(((self.gameState["fullTimeouts"] as! Int) +  (self.gameState["halfTimeouts"] as! Int)) == 1){
            self.timeOutsLeft.text! = "*"
        } else if(((self.gameState["fullTimeouts"] as! Int) +  (self.gameState["halfTimeouts"] as! Int)) == 0){
            self.timeOutsLeft.text! = ""
        }
    }
    func updateAwayTimeOuts() {
        if(((self.gameState["oppFullTimeouts"] as! Int) +  (self.gameState["oppHalfTimeouts"] as! Int)) == 4){
            self.timeOutsLeftDefense.text! = "* * * *"
        } else if(((self.gameState["oppFullTimeouts"] as! Int) +  (self.gameState["oppHalfTimeouts"] as! Int)) == 3){
            self.timeOutsLeftDefense.text! = "* * *"
        } else if(((self.gameState["oppFullTimeouts"] as! Int) +  (self.gameState["oppHalfTimeouts"] as! Int)) == 2){
            self.timeOutsLeftDefense.text! = "* *"
        } else if(((self.gameState["oppFullTimeouts"] as! Int) +  (self.gameState["oppHalfTimeouts"] as! Int)) == 1){
            self.timeOutsLeftDefense.text! = "*"
        } else if(((self.gameState["oppFullTimeouts"] as! Int) +  (self.gameState["oppHalfTimeouts"] as! Int)) == 0){
            self.timeOutsLeftDefense.text! = ""
        }
    }
    @IBAction func showGameSummary(_ sender: UIButton) {
        if gameState["began"] as! Bool {
            let playAlert = UIAlertController(title: "Plays", message: self.printPlaySequence(), preferredStyle: .alert)
            playAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { UIAlertAction in })
            playAlert.popoverPresentationController?.sourceView = view
            playAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: view.center, size: CGSize.init())
            present(playAlert, animated: false)
        }
    }

    func getPlayerObject(pid: String) -> Player {
        for player in gameState["roster"] as! [Player] {
            if (player.playerId == pid){
                return player
            }
        }
        return Player(firstName: "", lastName: "", photo: nil, position: "", height: "", weight: "", rank: "", playerId: "", teamId: "")
    }


    func dribbleBorderRipple(_ player: Int){
        switch(player){
        case 0:
            self.imagePlayer1.dribble()
            break
        case 1:
            self.imagePlayer2.dribble()
            break
        case 2:
            self.imagePlayer3.dribble()
            break
        case 3:
            self.imagePlayer4.dribble()
            break
        case 4:
            self.imagePlayer5.dribble()
            break
        default:
            break
        }

    }


    func addBorderToActivePlayer(_ player: Int){

        resetAllPlayerBorders()

        switch(player){
        case 0:
            imagePlayer1.layer.borderColor = UIColor.orange.cgColor
            imagePlayer1.layer.borderWidth = 4
            break
        case 1:
            imagePlayer2.layer.borderColor = UIColor.orange.cgColor
            imagePlayer2.layer.borderWidth = 4
            break
        case 2:
            imagePlayer3.layer.borderColor = UIColor.orange.cgColor
            imagePlayer3.layer.borderWidth = 4
            break
        case 3:
            imagePlayer4.layer.borderColor = UIColor.orange.cgColor
            imagePlayer4.layer.borderWidth = 4
            break
        case 4:
            imagePlayer5.layer.borderColor = UIColor.orange.cgColor
            imagePlayer5.layer.borderWidth = 4
            break
        default:
            break
        }
    }

    func resetAllPlayerBorders(){
        imagePlayer1.layer.borderWidth = 0
        imagePlayer2.layer.borderWidth = 0
        imagePlayer3.layer.borderWidth = 0
        imagePlayer4.layer.borderWidth = 0
        imagePlayer5.layer.borderWidth = 0
    }




    //creates a child in the teams table (not the one in users) with a roster and adds or updates info for a single player. UNUSED, DATACOLLECTION
    func syncSinglePlayerObjectToFirebase(index: Int){
        var data: [[String: Any]] = []
        var tid = ""
        for playerObject in self.gameState["roster"] as! [Player] {
            tid = playerObject.teamId
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
            data.append(playerData)
        }
        let firebaseRef = Database.database().reference(withPath: "teams")
        let teamRosterRef = firebaseRef.child(tid).child("roster")
        teamRosterRef.setValue(data)
    }







    //MARK: TIMER

    func restart(){
        // Invalidate timer
        timer?.invalidate()
        status = true

        // Reset timer variables
        gameState["startTime"] = 0
        time = 0
        elapsed = 0

        // Reset all labels
        let strMinutes = String(format: "%02d", quarterTime)
        labelMinute.text = strMinutes
        labelSecond.text = "00"
    }

    func start() {
        if(status){
            gameState["startTime"] = Date().timeIntervalSinceReferenceDate - elapsed
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            status = false
            self.timeoutButton.setTitle("Timeout", for: UIControlState.normal)
            gameState["currentlyPaused"] = false
        }
    }

    func stop() {
        self.gameState["currentlyPaused"] = true
        let temp = gameState["startTime"] as! Double
        elapsed = Date().timeIntervalSinceReferenceDate - temp
        timer?.invalidate()
        status = true
        resetAllPlayerBorders()
    }

    @objc func updateCounter() {
        // Calculate total time since timer started in seconds
        let temp = gameState["startTime"] as! Double
        time = Date().timeIntervalSinceReferenceDate - temp
        gameState["timeSeconds"] = time
        timeSeconds = time

        // Calculate minutes
        let minutes = Int(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        let minutes2 = quarterTime - minutes - 1

        // Calculate seconds
        let seconds = Int(59.0) - Int(time)
        time -= TimeInterval(seconds)

        if(minutes2 == 0 && seconds == 0){
            stop()
            status = true
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



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPath = indexPath
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playerCell = "PlayerCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: playerCell, for: indexPath) as? BenchTableViewCell
            else{
                fatalError("Dequeued cell was not of type BenchTableViewCell")
        }
        cell.photoImageView.image = (gameState["bench"]as! [Player])[indexPath.row].photo

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let players = gameState["bench"] as! [Player]
        return players.count
    }

    func player(i: Int) -> Player {
        let players = gameState["active"] as! [Player]
        return players[i] as Player
    }


    //MARK: OFFENSE
    func switchToOffense() {
        print("switching to offense")

        self.pushPlaySequence(event: "switch to offense")
        courtView.transform = offenseCourtTransform!

        gameState["possession"] = "offense"
        imageHoop.center.y = 129
        imagePlayer1.center.y = 147
        imagePlayer2.center.y = 407
        imagePlayer3.center.y = 525
        imagePlayer4.center.y = 407
        imagePlayer5.center.y = 147
        boxRects[0] = CGRect.init(x: imageHoop.frame.origin.x, y: imageHoop.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[1] = CGRect.init(x: imagePlayer1.frame.origin.x, y: imagePlayer1.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[2] = CGRect.init(x: imagePlayer2.frame.origin.x, y: imagePlayer2.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[3] = CGRect.init(x: imagePlayer3.frame.origin.x, y: imagePlayer3.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[4] = CGRect.init(x: imagePlayer4.frame.origin.x, y: imagePlayer4.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[5] = CGRect.init(x: imagePlayer5.frame.origin.x, y: imagePlayer5.frame.origin.y, width: boxWidth, height: boxHeight)
        if (gameState["fullTimeouts"] as! Int == 0 && gameState["halfTimeouts"] as! Int == 0) {
            timeoutButton.isEnabled = false
        }
        else {
            timeoutButton.isEnabled = true
        }
    }


    func routeFoul(type: String, player: Player) {
        let onOffense: Bool = gameState["possession"] as! String == "offense"
        if (onOffense){

        }
        else {

        }
    }

    //MARK: DEFENSE
    func switchToDefense() {
        print("switching to defense")

        self.pushPlaySequence(event: "switch to defense")
        resetAllPlayerBorders()
        courtView.transform = defenseCourtTransform ?? courtView.transform
        gameState["possession"] = "defense"
        imageHoop.center.y = 529
        imagePlayer1.center.y = 547
        imagePlayer2.center.y = 307
        imagePlayer3.center.y = 175
        imagePlayer4.center.y = 307
        imagePlayer5.center.y = 547
        boxRects[0] = CGRect.init(x: imageHoop.frame.origin.x, y: imageHoop.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[1] = CGRect.init(x: imagePlayer1.frame.origin.x, y: imagePlayer1.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[2] = CGRect.init(x: imagePlayer2.frame.origin.x, y: imagePlayer2.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[3] = CGRect.init(x: imagePlayer3.frame.origin.x, y: imagePlayer3.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[4] = CGRect.init(x: imagePlayer4.frame.origin.x, y: imagePlayer4.frame.origin.y, width: boxWidth, height: boxHeight)
        boxRects[5] = CGRect.init(x: imagePlayer5.frame.origin.x, y: imagePlayer5.frame.origin.y, width: boxWidth, height: boxHeight)
        if (gameState["oppFullTimeouts"] as! Int == 0 && gameState["oppHalfTimeouts"] as! Int == 0) {
            timeoutButton.isEnabled = false
        }
        else {
            timeoutButton.isEnabled = true
        }
    }

    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
        print("Pinch updates steals")
        if gameState["began"] as! Bool {
            if let view = sender.view {
                let player = self.player(i: view.tag)
                DBApi.sharedInstance.storeStat(type: .steal, pid: player.playerId, seconds: timeSeconds)
                pushPlaySequence(event: "\(player.firstName) stole the ball")
            }
        }
    }

    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        print("swipe updates deflections")
        if gameState["began"] as! Bool {
            if let view = sender.view {
                let player = self.player(i: view.tag)
                DBApi.sharedInstance.storeStat(type: .deflection, pid: player.playerId, seconds: timeSeconds)
                pushPlaySequence(event: "\(player.firstName) deflected the ball")
            }
        }
    }

    @objc func showStyleOptions() {
        let styleAlert = UIAlertController(title: "Style Options", message: "", preferredStyle: .actionSheet)

        let plain = UIAlertAction(title: "Plain", style: UIAlertActionStyle.default) { [weak self] _ in
            self?.setCourtColor(color: "plain")
        }
        styleAlert.addAction(plain)

        let red = UIAlertAction(title: "Red", style: UIAlertActionStyle.default) { [weak self] _ in
            self?.setCourtColor(color: "red")
        }
        styleAlert.addAction(red)

        let blue = UIAlertAction(title: "Blue", style: UIAlertActionStyle.default) { [weak self] _ in
            self?.setCourtColor(color: "blue")
        }
        styleAlert.addAction(blue)

        let green = UIAlertAction(title: "Green", style: UIAlertActionStyle.default) { [weak self] _ in
            self?.setCourtColor(color: "green")
        }
        styleAlert.addAction(green)

        let black = UIAlertAction(title: "Black", style: UIAlertActionStyle.default) { [weak self] _ in
            self?.setCourtColor(color: "black")
        }
        styleAlert.addAction(black)

        styleAlert.popoverPresentationController?.sourceView = view
        let c = imageHoop.center
        let y = CGFloat(c.y + 100)
        let p = CGPoint(x: c.x, y: y)

        styleAlert.popoverPresentationController?.sourceRect = CGRect.init(origin: p, size: CGSize.init())

        present(styleAlert, animated: false)
    }

    func setCourtColor(color: String) {
        let img: UIImage?
        switch color {
        case "red": img = UIImage(named: "courtRed")
        case "green": img = UIImage(named: "courtGreen")
        case "blue": img = UIImage(named: "courtBlue")
        case "black": img = UIImage(named: "courtBlack")
        default: img = UIImage(named: "blankCourt")
        }
        courtView.image = img
    }

    // show quick select for home team
    func selectHomePlayer(stat: Statistic, message: String) {
        buttonsEnabled(false)

        gameState["selectingHomePlayerForStat"] = stat
        // gray out view except player icons
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        courtView.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        blurView.contentView.addSubview(stack)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        stack.addArrangedSubview(label)

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("No One", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cancelPlayerSelect), for: .touchUpInside)
        stack.addArrangedSubview(button)
        
        //only flip the assignment text if on defense
        if gameState["possession"] as? String ?? "" == "defense" {
            //dont flip if opponent foul shot
            if !(gameState["oppWasFouled"] as! Bool){
                stack.transform = CGAffineTransform(rotationAngle: .pi)
            }else{
                gameState["oppWasFouled"] = false
            }
        }

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        self.blurView = blurView

        courtView.bringSubview(toFront: blurView)
        view.bringSubview(toFront: imagePlayer1)
        view.bringSubview(toFront: imagePlayer2)
        view.bringSubview(toFront: imagePlayer3)
        view.bringSubview(toFront: imagePlayer4)
        view.bringSubview(toFront: imagePlayer5)
    }

    @objc func cancelPlayerSelect() {
        if let stat = gameState["selectingHomePlayerForStat"] as? Statistic,
            let blurView = self.blurView {
            buttonsEnabled(true)

            // REMOVE BLUR VIEW
            blurView.removeFromSuperview()
            self.blurView = nil

            gameState["selectingHomePlayerForStat"] = nil
            gameState["transitionState"] = "inProgress"

            if [.defRebound, .steal, .chargeTaken].contains(stat) {
                switchToOffense()
            } else if [.turnover, .charge, .threeSecondViolation].contains(stat) {
                switchToDefense()
            }
        }
    }
    
    //MARK: USEFUL BUT BAD IMPLEMENTATION
    //Needs to be adjusted
    func selectOpposingPlayer(stat: Statistic) {
        let opponent = gameState["opponent"] as? [String: [String: Any]] ?? [:]
        let possession = gameState["possession"] as? String ?? ""
        let completion: (Int) -> () = { number in
            if [.defRebound, .offRebound].contains(stat) {
                if possession == "offense" && stat == .defRebound {
                    self.switchToDefense()
                }
                self.storeOpponentRebound(number: number)
            } else if [.turnover].contains(stat) {
                self.storeOpponentTurnover(number: number)
                self.switchToOffense()
            } else if [.score2, .score3, .freeThrow].contains(stat) {
                switch stat {
                case .score2:
                    self.storeOpponentPoints(type: Statistic.score2, number: number, seconds: self.timeSeconds)
                    //only switch possession if not And1, otherwise possession will switch later
                    if !(self.gameState["oppAnd1"] as! Bool){
                        self.switchToOffense()
                    }else{
                        self.gameState["oppAnd1"] = false
                    }
                case .score3:
                    self.storeOpponentPoints(type: Statistic.score3, number: number, seconds: self.timeSeconds)
                    //only switch possession if not And1, otherwise possession will switch later
                    if !(self.gameState["oppAnd1"] as! Bool){
                        self.switchToOffense()
                    }else{
                        self.gameState["oppAnd1"] = false
                    }
                case .freeThrow:
                    self.storeOpponentPoints(type: Statistic.freeThrow, number: number, seconds: self.timeSeconds)
                default: break
                }
            }
        }

        //COMMENT OUT BY ALEX JACOBS 2/18 - CAUSES BUGS AND NOT USEFUL AT THE MOMENT
        
//        let alert = UIAlertController(title: "Select a Player", message: nil, preferredStyle: .actionSheet)
//        alert.popoverPresentationController?.sourceView = addOppButton
//        for number in Array(opponent.keys) {
//            let num = Int(number) ?? 999
//            alert.addAction(UIAlertAction(title: "\(number)", style: .default, handler: { action in
//                completion(num)
//            }))
//        }
//        if alert.actions.count > 0 {
//            present(alert, animated: true)
//        } else {
            completion(999)
        //}
    }

    func buttonsEnabled(_ enabled: Bool) {
        let alpha: CGFloat = enabled ? 1.0 : 0.5
        chargeButton.isEnabled = enabled
        chargeButton.alpha = alpha
        turnoverButton.isEnabled = enabled
        turnoverButton.alpha = alpha
        timeoutButton.isEnabled = enabled
        timeoutButton.alpha = alpha
        outOfBoundsButton.isEnabled = enabled
        outOfBoundsButton.alpha = alpha
        paintButton.isEnabled = enabled
        benchButton.isEnabled = enabled
        benchButton.alpha = alpha
        gameSummaryButton.isEnabled = enabled
        gameSummaryButton.alpha = alpha
    }
}
