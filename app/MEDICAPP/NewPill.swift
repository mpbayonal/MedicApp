//  Codigo tomado e inspirado por https://github.com/rffuste/ePill
//
//  NewPill.swift
//  MEDICAPP
//
//  Created by Gabriela Viñas on 9/29/19.
//  Copyright © 2019 Felipe Rivera. All rights reserved.
//

import Foundation
import UIKit

class NewPill: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var pillNameLbl: UILabel!
    @IBOutlet weak var pillNameTxt: UITextField!
    @IBOutlet weak var pillTimePick: UIDatePicker!
    @IBAction func addPill(_ sender: UIButton) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          
        var maxLength : Int
        
        maxLength = 0
          
        if textField == self.pillNameTxt{
            maxLength = 20
        }
          
        let currentString: NSString = textField.text! as NSString
          
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}
