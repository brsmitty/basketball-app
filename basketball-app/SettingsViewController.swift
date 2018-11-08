//
//  SettingsViewController.swift
//  basketball-app
//
//  Created by Mike White on 11/6/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SettingsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var timerLabel: UITextField!
    private var timerPicker = UIPickerView()
    var minutes:Int = 0
    // holds the player reference to firebase
    var playRef:DatabaseReference?
    // holds the database reference to firebase
    var databaseHandle:DatabaseHandle?
    // holds the users unique user ID
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the user id and set it to the user id global variable
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let uId = user?.uid else {return}
                self.uid = uId
            }
        }
        
        timerLabel.inputView = timerPicker
        timerPicker.dataSource = self
        timerPicker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "\(row) Minute"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            timerLabel.text = "\(row)"
            minutes = row
    }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }

    @IBAction func saveButton(_ sender: Any) {
        var pid = ""
        pid = uid + "-" + String(0)
        
        let ref = Database.database().reference(withPath: "timer")
        
        let playRef = ref.child(pid)
        let playData : [String: Any] = ["quarter": minutes]
        playRef.setValue(playData)
    }
}


