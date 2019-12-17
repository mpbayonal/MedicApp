//
//  LoginViewController.swift
//  Snapchat Camera
//
//  Created by ashika shanthi on 2/27/18.
//  Copyright © 2018 ashika shanthi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
     @IBOutlet weak var edad: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loginButton.layer.cornerRadius = 10
        email.delegate = self
        password.delegate = self
       
    }

    @IBAction func loginAction(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { user, error in
          if let error = error, user == nil {
            let alert = UIAlertController(title: "Sign In Failed",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
          }
        }
      

        Auth.auth().addStateDidChangeListener() { auth, user in
           // 2
           if user != nil {
             // 3
             self.performSegue(withIdentifier: "loginToHome", sender: nil)
    
           }
         }
       
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          
        var maxLength : Int
        
        maxLength = 0
          
        if textField == self.edad{
            maxLength = 5
        } else if textField == self.password{
            maxLength = 25
        } else if textField == self.email{
            maxLength = 30
        }
          
        let currentString: NSString = textField.text! as NSString
          
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}
