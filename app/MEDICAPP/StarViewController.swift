//
//  StartViewController.swift
//  Snapchat Camera
//
//  Created by ashika shanthi on 2/27/18.
//  Copyright © 2018 ashika shanthi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class StartViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            
            userID = Auth.auth().currentUser!.uid
            db.child("users").child(userID).child("perfil").observeSingleEvent(of: .value, with: { (snapshot) in
                                 // Get user value
                                 let value = snapshot.value as? NSDictionary
                                 let cuidador = value?["cuidador"] as? String ?? ""
                                   if cuidador == "0"{
                                       personatipo = "0"
                                    user1 = userID
                                    user2 = userID
                                       self.performSegue(withIdentifier: "loginToHome", sender: nil)}
                                   else if cuidador == "1"
                                   {
                                        self.performSegue(withIdentifier: "loginToHomeCuidador",   sender: nil)
                                       personatipo = "1"
                                    user1 = userID
                                    
                                   }
                               // ...
                                 }) { (error) in
                                   print(error.localizedDescription)
                               }
            
            
            
            
        }
    }
   

    
}
