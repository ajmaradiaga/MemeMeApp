//
//  MemeTextDelegate.swift
//  MemeMe
//
//  Created by Antonio Maradiaga on 11/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import Foundation
import UIKit

class MemeTextDelegate: NSObject, UITextFieldDelegate {
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.text = textField.text.uppercaseString
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.text = textField.text.uppercaseString
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
}
