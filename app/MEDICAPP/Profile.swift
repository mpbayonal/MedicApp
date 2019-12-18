//
//  Profile.swift
//  MEDICAPP
//
//  Created by monica bayona on 12/12/19.
//  Copyright © 2019 Paola Bayona. All rights reserved.

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import MessageUI


class Profile: UIViewController,MFMessageComposeViewControllerDelegate {
    
    var telefono = 123
    var temp = false
    
 

    @IBOutlet weak var cerrarSesion: UIButton!
    

    @IBAction func ir(_ sender: Any) {
        
        self.performSegue(withIdentifier: "listaPacientes", sender: nil)
    }
    
    @IBAction func pacienteIr(_ sender: Any) {
        
        print("paso")
                temp = true
              
               if personatipo == "1"
                                  {
                                   if temp == true {
                                    userID = user1
                                        self.performSegue(withIdentifier: "listaPacientes", sender: nil)
                                   }
                                     
                                  }
        
        
    }
    
    
 

    
    @IBAction func enviarMensaje(_ sender: Any) {
        
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "Necesito ayuda";
        var tel = String(telefono)
        messageVC.recipients = [tel]
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result) {
        case .cancelled:
            print("Se cancelo el envio del mensaje")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Fallo la entrega del mensaje")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    
    @IBOutlet weak var nombre: UILabel!
    
  
    
    
    @IBOutlet weak var lpm: UILabel!
    

   
    @IBOutlet weak var paciente: UIButton!
    
    @IBOutlet weak var logOut: UIButton!
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
        
      
              
      
        if personatipo == "1"
        {
            userID = user2
        }
        else
        {
            self.paciente.isHidden = true
            
        }
            
        db.child("users/\(userID)/perfil").observe(.value, with: { snapshot in
        
        let value1 = snapshot.value as? [String: AnyObject]
        let telefono = value1?["telefono"] as? Int
        let nombre = value1?["nombre"] as? String
        let apellido = value1?["apellido"] as? String
        
            
            self.nombre.text = (nombre ?? "") + " " + (apellido ?? "")
        })
        db.child("users/\(userID)/frecuencia_cardiaca").queryLimited(toLast: 1).observe(.childAdded, with: { snapshot in
            
            let value = snapshot.value as? [String: AnyObject]
            let frecuencia = value?["frecuencia"] as? String
            
            
            
            self.lpm.text = frecuencia
                
             
            
                    })
        
        
        
      
        
     
    
    
           
}
       

    @IBAction func llamarContacto(_ sender: Any) {
        
        var tel = String(telefono)
        
        makePhoneCall(phone_number: tel)
    }
    
    func enviarMensaje()
    {
        
    }
    
    func makePhoneCall(phone_number: String) {
       let url:URL = URL(string: "tel:\(phone_number)")!
       let application:UIApplication = UIApplication.shared
       if (application.canOpenURL(url)) {
           if #available(iOS 10, *) {
               application.open(url)
           } else {
               application.openURL(url)
           }
       }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        
        
      
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        if Auth.auth().currentUser == nil {
            
                 
            personatipo = "-1"; self.performSegue(withIdentifier: "NoLoggedIn", sender: nil)
              }
      
        
        
    }
    
}
