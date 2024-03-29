//
//  ViewController.swift
//  basketball-app
//
//  Created by David on 9/5/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import EventKit
import os.log

/** Handles view of scheduled games */

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var GameOptionalDetail: UITextField!
    @IBOutlet weak var GameOpponent: UITextField!
    @IBOutlet weak var GameTime: UITextField!
    @IBOutlet weak var GameDate: UITextField!
    @IBOutlet weak var GameType: UITextField!
    @IBOutlet weak var Location: UITextField!
    
   @IBOutlet var opponentLabel: UILabel!
   @IBOutlet var locationLabel: UILabel!
   @IBOutlet var typeLabel: UILabel!
   @IBOutlet var dateLabel: UILabel!
   @IBOutlet var timeLabel: UILabel!
   @IBOutlet var detailLabel: UILabel!
   internal var locationPick = ["Home", "Away", "Netural"]
    internal var typePick = ["Non-Conference", "Conference", "Playoff", "Tournament","Scrimmage"]
    internal var locationPicker = UIPickerView()
    internal var typePicker = UIPickerView()
    internal var datePicker = UIDatePicker()
    internal var timePicker = UIDatePicker()
    var game : Game?
    var location : String?
    var gameTitle : String?
    var gameDate : Date?
    var gameType : String?
    var gameTime : String?
    var gameDetail : String?
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        switch pickerView.tag {
        case 0:
            count = locationPick.count
            break
        case 1:
            count = typePick.count
            break
        default:
            break
        }
        return count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            Location.text = locationPick[row]
            break
        case 1:
            GameType.text = typePick[row]
            break
        default:
            break
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var returnValue = ""
        switch pickerView.tag {
        case 0:
            returnValue = locationPick[row]
            break
        case 1:
            returnValue = typePick[row]
            break
        default:
            break
        }
        return returnValue
    }
   
   override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 5
    
        locationPicker.dataSource = self
        locationPicker.delegate = self
        locationPicker.tag = 0
        Location.inputView = locationPicker
    
        typePicker.dataSource = self
        typePicker.delegate = self
        typePicker.tag = 1
        GameType.inputView = typePicker
    
        datePicker.datePickerMode = .date
        GameDate.inputView = datePicker
        datePicker.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
    
        timePicker.datePickerMode = .time
        GameTime.inputView = timePicker
        timePicker.addTarget(self, action: #selector(ViewController.timeChanged(timePicker:)), for: .valueChanged)
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
      
      GameOptionalDetail.autocorrectionType = .no
      GameOpponent.autocorrectionType = .no
      GameTime.autocorrectionType = .no
      GameDate.autocorrectionType = .no
      GameType.autocorrectionType = .no
      Location.autocorrectionType = .no
      
      GameOptionalDetail.layer.cornerRadius = 5
      GameOpponent.layer.cornerRadius = 5
      GameTime.layer.cornerRadius = 5
      GameDate.layer.cornerRadius = 5
      GameType.layer.cornerRadius = 5
      Location.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "MM/dd/yyyy"
        GameDate.text = dataFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @objc func timeChanged(timePicker: UIDatePicker){
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "HH:mm"
        GameTime.text = dataFormatter.string(from: timePicker.date)
        //view.endEditing(true)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        let detailString = GameDate.text!
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM, dd, yyyy"
        let raceDate = GameDate.text
        let date = dateFormatter.date(from: raceDate!)
        
        game = Game(title: GameOpponent.text!, detail: detailString)
        gameDate = date
        gameTitle = GameOpponent.text!
        location = Location.text!
        gameType = GameType.text!
        gameDetail = GameOptionalDetail.text!
        gameTime = GameTime.text!
    }
    
    
  
    
    
    
}
