//
//  TimerTest.swift
//  basketball-app
//
//  Created by Maggie Zhang on 11/5/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

/**
    Timer object, inherits from UIViewController
 
    - start
    - stop
    - restart
    - update counter
 */
class TimerTest: UIViewController {
    
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    var quarterTime: Int = 10
    
    @IBOutlet weak var labelMinute: UILabel!

    @IBOutlet weak var labelSecond: UILabel!
    
    @IBOutlet weak var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // No point enabling reset until stopwatch actually started
        resetBtn.isEnabled = false
        let strMinutes = String(format: "%02d", quarterTime)
        labelMinute.text = strMinutes
        labelSecond.text = "00"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleStartStop(_ sender: UIButton!) {
        
        // If button status is true use stop function, relabel button and enable reset button
        if (status) {
            stop()
            sender.setTitle("START", for: .normal)
            resetBtn.isEnabled = true
            
            // If button status is false use start function, relabel button and disable reset button
        } else {
            start()
            sender.setTitle("STOP", for: .normal)
            resetBtn.isEnabled = false
        }
        
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        
        restart()
        
    }
    
    func restart(){
        // Invalidate timer
        timer?.invalidate()
        
        // Reset timer variables
        startTime = 0
        time = 0
        elapsed = 0
        status = false
        
        // Reset all labels
        let strMinutes = String(format: "%02d", quarterTime)
        labelMinute.text = strMinutes
        labelSecond.text = "00"
        
    }
    func start() {
        
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        // Set Start/Stop button to true
        status = true
        
    }
    
    func stop() {
        
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
        
        // Set Start/Stop button to false
        status = false
        
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
        //let strMilliseconds = String(format: "%02d", milliseconds)
        
        // Add time vars to relevant labels
        labelMinute.text = strMinutes
        labelSecond.text = strSeconds
        //labelMillisecond.text = strMilliseconds
        
    }
}
