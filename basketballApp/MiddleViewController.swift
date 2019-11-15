//
//  MiddleViewController.swift
//  basketball-app
//
//  Created by Mike White on 9/25/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Charts




class MiddleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    final class QuarterNameFormatter: NSObject, IAxisValueFormatter {
        
        var quarterTime = 10
        
        func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
            let intValue = Int(value)
            switch intValue {
            case 0:
                return "1st"
            case quarterTime:
                return "2nd"
            case (quarterTime * 2):
                return "3rd"
            case (quarterTime * 3):
                return "4th"
            default:
                return ""
            }
        }
    }
    
    static let borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5).cgColor
    
    
    var opponentTeam: String = "Team2"
    var teamName: String = UserDefaults.standard.string(forKey: "tid")!
    @IBOutlet weak var gameSummaryTitle: UILabel!
    
    @IBOutlet weak var gameChart: LineChartView!
    
    @IBOutlet weak var shotChart: UIView!
    
    
    var schedules: [String] = []
    var times: [String] = []
    var dates: [Date] = []
    var locations: [String] = []
    var uid: String = ""
    var tid: String = ""
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var welcomeBar: UIImageView!
    
    @IBOutlet weak var kpiBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var playbookBtn: UIButton!
    @IBOutlet weak var scheduleBtn: UIButton!
    @IBOutlet weak var performanceBtn: UIButton!
    @IBOutlet weak var gameTimeBtn: UIButton!
    @IBOutlet weak var playerManagerBtn: UIButton!

    @IBOutlet weak var NGDetail: UILabel!
    @IBOutlet weak var NGDate: UILabel!

   @IBOutlet var mainView: UIView!
   @IBOutlet weak var settingsView: UIView!
   @IBOutlet weak var NGTitle: UILabel!
    
    @IBOutlet weak var lineupRankingView: UIView!
    
    @IBOutlet weak var UsVsOppsView: UIView!
    @IBOutlet weak var tableViewWrapper: UIView!
    
    
    @IBOutlet weak var viewBoxScoreButton: UIButton!
    
    
    var admin: Bool = false
    // holds the player reference to firebase
    var playRef:DatabaseReference?
    // holds the database reference to firebase
    var databaseHandle:DatabaseHandle?
    // holds the users unique user ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(false, forKey: "admin")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadPlayers()
        
        setDefaultViewStyle(view: self.lineupRankingView)
        setDefaultViewStyle(view: self.UsVsOppsView)
        setDefaultViewStyle(view: self.tableViewWrapper)
        setDefaultButtonStyle(button: self.viewBoxScoreButton)
        self.gameSummaryTitle.text = teamName + " vs " + opponentTeam
        
        updateGraph()
        
        let bounds =  shotChart.bounds
        
        let xCoord = bounds.midX
        let yCoord = bounds.midY
        
        let pointList = [CGPoint(x: xCoord, y: yCoord), CGPoint(x: xCoord, y: yCoord + 10)]
        let missedList = [CGPoint(x: xCoord - 20, y: yCoord), CGPoint(x: xCoord + 20, y: yCoord)]
        
        addShotChartDots(pointList: pointList, made: true)
        addShotChartDots(pointList: missedList, made: false)
        
        
        self.shotChart.bounds = bounds
        for subview in shotChart.subviews {
            subview.bounds = bounds
            subview.frame = bounds
        }
        // Do any additional setup after loading the view.
    }
    
    func addShotChartDots(pointList: [CGPoint], made: Bool){
        for point in pointList{
            let radius = 8.0 as CGFloat
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: radius, height: radius))
            let layer = CAShapeLayer()
            layer.path = dotPath.cgPath
            layer.strokeColor = (made ? UIColor.blue.cgColor: UIColor.red.cgColor)
            layer.fillColor = (made ? UIColor.blue.cgColor: UIColor.red.cgColor)
            shotChart.layer.addSublayer(layer)
        }
    }
    
    private func setDefaultViewStyle(view: UIView){
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 10.0
        view.layer.borderColor = MiddleViewController.borderColor
    }
    
    private func setDefaultButtonStyle(button: UIButton){
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
    }
    
    func updateGraph(){
        var lineInfo = [ChartDataEntry]()
        var opplineInfo = [ChartDataEntry]()
//        lineInfo.append(ChartDataEntry(x: 0, y: 0))
//        lineInfo.append(ChartDataEntry(x: 5.5, y: 3.3))
//        lineInfo.append(ChartDataEntry(x: 6.5, y: 9.9))
        
        var testScore: Double = 0
        var testOppScore: Double = 0
        var x: Double = 0
        while testScore < 100 && x < 20 {
            lineInfo.append(ChartDataEntry(x: x, y: testScore))
            opplineInfo.append(ChartDataEntry(x: x, y: testOppScore))
            testScore += Double(Int.random(in: 0...4))
            testOppScore += Double(Int.random(in: 0...3))
            x += 1
        }
        
        
//        opplineInfo.append(ChartDataEntry(x: 0, y: 0))
//        opplineInfo.append(ChartDataEntry(x: 22.5, y: 66.3))
//        opplineInfo.append(ChartDataEntry(x: 25.5, y: 88.9))
        
        let ourTeamLine = LineChartDataSet(entries: lineInfo, label: self.teamName)
        ourTeamLine.colors = [UIColor.blue]
        ourTeamLine.drawCirclesEnabled = false
        
        let oppTeamLine = LineChartDataSet(entries: opplineInfo, label: self.opponentTeam)
        oppTeamLine.colors = [NSUIColor.red]
        oppTeamLine.drawCirclesEnabled = false
        
        let data = LineChartData()
        data.addDataSet(ourTeamLine)
        data.addDataSet(oppTeamLine)
        data.setDrawValues(false)
        
        gameChart.xAxis.valueFormatter = QuarterNameFormatter()
        
        gameChart.chartDescription?.text = "Game Chart"
        gameChart.rightAxis.axisMinimum = 0
        gameChart.leftAxis.axisMinimum = 0
        gameChart.rightAxis.axisMaximum = 100
        gameChart.leftAxis.axisMaximum = 100
        gameChart.leftAxis.enabled = false
        gameChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        gameChart.xAxis.axisMinimum = 0
        gameChart.xAxis.axisMaximum = 40        
        
        gameChart.data = data
        
        gameChart.layer.borderWidth = 1.0
        gameChart.layer.cornerRadius = 10.0
        gameChart.layer.borderColor = MiddleViewController.borderColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        //let defaults = UserDefaults.standard
        //uid = defaults.string(forKey: "uid")!
        
        // Get the user id and set it to the user id global variable
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let uId = user?.uid else {return}
                self.uid = uId
            }
        }
      settingsView.isHidden = true
        getGames()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Store the new players in firebase
        playRef?.removeObserver(withHandle: databaseHandle!)
    }
    
    
    func gameIsUsers(_ lid:String)-> Bool{
        var isUsers = false
        
        let lineupId = lid.prefix(28)
        isUsers = lineupId == uid
        
        return isUsers
    }
    
    func getGames(){
        // Set up the references
        //Change this function only
        playRef = Database.database().reference()
        databaseHandle = playRef?.child("games").observe(.childAdded, with: { (snapshot) in
            
            // If the player is one of the users players add it to the table
                // take data from the snapshot and add a player object
                if(self.gameIsUsers(snapshot.key)){
                    let title = snapshot.childSnapshot(forPath: "title")
                    let location = snapshot.childSnapshot(forPath: "location")
                    let gameDate = snapshot.childSnapshot(forPath: "gameDate")
                    let gameTime = snapshot.childSnapshot(forPath: "gameTime")
                    
                    self.schedules.append(title.value as! String)
                    self.times.append(gameTime.value as! String)
                    self.locations.append(location.value as! String)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM, dd, yyyy"
                    let date = dateFormatter.date(from: gameDate.value as! String)
                    self.dates.append(date!)
                    
                    if(self.schedules[0] != ""){
                        let temp = self.compareDates()
                        let currentDate = NSDate()
                        if(temp > currentDate as Date){
                            let dataFormatter = DateFormatter()
                            dataFormatter.dateFormat = "MM/dd/yyyy"
                            self.NGDate.text = dataFormatter.string(from: temp)
                            let number = self.dates.index(of: temp)!
                            self.NGTitle.text = self.schedules[number]
                            let temp2 = self.locations[number] + " - " + self.times[number]
                            self.NGDetail.text = temp2
                        }
                    }
                }

        })
    }
    
    func compareDates() -> Date{
        var temp: Date = dates[0]
        let currentDate = NSDate()
        for everyDate in dates{
            if(temp > everyDate || temp < currentDate as Date){
                temp = everyDate
            }
        }
        return temp
    }
    
    //MARK: Player metrics table
    var players = [Player]()
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    //MARK: Player Metrics
    //TODO: change this to game instead of season
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameSummaryPlayerMetricCell", for: indexPath) as? GameSummaryTableViewCell else {
            fatalError("The deqeued cell is not an instance of Player KPITableViewCell")
        }
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = BoxScoreViewController.LightGrayBackground
        }
        print("tableView")
        let player = players[indexPath.row]
        cell.playerName.text = "-" + player.lastName + ", " + player.firstName.prefix(1) + "."
        //print("Players = \(players)")
        return cell
    }
    

    //number of groupings in the table that show up
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func loadPlayers() {
        DBApi.sharedInstance.getPlayers{ [weak self] players in
            guard let s = self else { return }
            s.players = players
            s.tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func toggleAdmin(_ sender: UIButton) {
        print("value on entrance" + String(admin) + "\n")
        if (admin){
            UserDefaults.standard.setValue(false, forKey: "admin")
            admin = false
            print("set to false\n")
        }
        else{
            let alertController = UIAlertController(title: "Confirm Admin Elevation", message: "Please enter your account password", preferredStyle: .alert)
            alertController.addTextField{ (pwdTextField : UITextField!) -> Void in
                pwdTextField.placeholder = "Password"
                pwdTextField.isSecureTextEntry = true
            }
            let saveAction = UIAlertAction(title: "Continue", style: .default, handler: { alert -> Void in
                let textField = alertController.textFields![0] as UITextField
                let pwd = textField.text!
                let user = Auth.auth().currentUser
                let userEmail = user?.email ?? ""
                let credential: AuthCredential = EmailAuthProvider.credential(withEmail: userEmail, password: pwd)
                user?.reauthenticateAndRetrieveData(with: credential, completion: { (auth, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        UserDefaults.standard.setValue(true, forKey: "admin")
                        self.admin = true
                        print("set to true\n")
                    }
                })
            })
            alertController.addAction(saveAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
   @IBAction func openSettings(_ sender: UIButton) {
      settingsView.isHidden = false
      
      self.settingsView.frame = CGRect(x: 0, y: -settingsView.frame.height, width: settingsView.frame.width, height: settingsView.frame.height)
      self.view.layoutIfNeeded()
      
      UIView.animate(withDuration: 0.3, animations: {
         self.settingsView.frame = CGRect(x: 0, y: 0, width: self.settingsView.frame.width, height: self.settingsView.frame.height)
         self.view.layoutIfNeeded()
      })
   }
   
   @IBAction func closeSettings(_ sender: UITapGestureRecognizer){

      if (sender.location(in: mainView).y > settingsView.frame.height){
         if(!settingsView.isHidden){
            UIView.animate(withDuration: 0.3, animations: {
               self.settingsView.frame = CGRect(x: 0, y: -self.settingsView.frame.height, width: self.settingsView.frame.width, height: self.settingsView.frame.height)
               self.view.layoutIfNeeded()
            }, completion: {(finished) -> Void in
               self.settingsView.isHidden = true
            })
         }
      }
         
      
   }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "schedule" {
            if let dest = segue.destination as? ScheduleViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "playbook" {
            if let dest = segue.destination as? PlaybookMasterViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "playerManager" {
            if let dest = segue.destination as? PlayerManagerViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "gameView" {
            if let dest = segue.destination as? GameViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "performanceSegue" {
            if let dest = segue.destination as? PerformanceViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "kpiSegue" {
            if let dest = segue.destination as? BoxScoreViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        else if segue.identifier == "mainMenu" {
            if let dest = segue.destination as? MiddleViewController {
                dest.uid = self.uid
                dest.tid = self.tid
            }
        }
        
        if segue.destination is BoxScoreViewController{
            let boxScore = segue.destination as? BoxScoreViewController
            boxScore?.opponentTeam = self.opponentTeam
        }
    }

}
