//
//  DefaultUITextField.swift
//  basketball-app
//
//  Created by Mike White on 10/17/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

@IBDesignable
class DefaultUITextField: UITextField {

   override func layoutSubviews() {
      super.layoutSubviews()
      
      self.layer.borderColor = UIColor(white: 200/255, alpha: 1).cgColor
      self.layer.borderWidth = 2
      self.layer.cornerRadius = 5
      
   }
   
   override func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: 8, dy: 7)
   }
   
   override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return textRect(forBounds: bounds)
   }

}
