//
//  UIImageViewExtension.swift
//  basketball-app
//
//  Created by Mike White on 11/17/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
   
   func dribble(){
      
      let anim = CABasicAnimation(keyPath: "borderColor")
      
      anim.duration = 0.15
      anim.fromValue = UIColor.orange.cgColor
      anim.toValue = UIColor.cyan.cgColor
      anim.autoreverses = true
      anim.repeatCount = 0
      
      layer.add(anim, forKey: nil)
   }
}
