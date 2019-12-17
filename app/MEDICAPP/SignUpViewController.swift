//
//  SignUpViewController.swift
//  Snapchat Camera
//
//  Created by ashika shanthi on 2/27/18.
//  Copyright © 2018 ashika shanthi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Eureka




class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signUpButton: UIButton!
   
    @IBOutlet weak var edad: UITextField!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
   
    @IBOutlet weak var Apellido: UITextField!
    @IBOutlet weak var Nombre: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 10
        email.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
        edad.delegate = self
    }
  
    @IBAction func signUpAction(_ sender: Any) {
         let db = Database.database().reference()
        
     Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
        print(error?.localizedDescription as Any)
     if error == nil {
         print("You have successfully signed up")
        let userID = Auth.auth().currentUser!.uid
        print(userID)
        
        db.child("users/\(userID)/perfil/nombre").setValue(self.Nombre.text)
        
        db.child("users/\(userID)/perfil/apellido").setValue(self.Apellido.text)
        
        db.child("users/\(String(describing: userID))/perfil/edad").setValue(self.edad.text)
        
         self.performSegue(withIdentifier: "signUptoHome", sender: nil)
         //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
         
         
     } else {
        
        
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
      
            if self.presentedViewController == nil {
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                self.dismiss(animated: false, completion: nil)
                self.present(alertController, animated: true, completion: nil)
            }
    
        
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }


}
}
}
