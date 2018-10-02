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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var initialCenter = CGPoint()
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.view != nil else {return}
        let piece = recognizer.view!
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = recognizer.translation(in: piece.superview)
        if recognizer.state == .began {
            print("pan begin")
            // Save the view's original position.
            self.initialCenter = piece.center
        }
        // Update the position for the .began, .changed, and .ended states
        if recognizer.state != .cancelled {
            print("pan changed/ended")
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        }
        else {
            print("pan cancelled")
            // On cancellation, return the piece to its original location.
            piece.center = initialCenter
        }
    }
}
