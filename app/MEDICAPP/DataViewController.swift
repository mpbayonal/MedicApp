//
//  DataViewController.swift
//  MEDICAPP
//
//  Created by monica bayona on 11/5/19.
//  Copyright © 2019 Paola Bayona. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DataViewController: UIViewController {
    
     

    @IBOutlet weak var sexo: UILabel?
    @IBOutlet weak var nombre: UILabel?
    
    @IBOutlet weak var telefono: UILabel?
    @IBOutlet weak var listaFrec: UILabel?
    
    @IBOutlet weak var edad: UILabel?
    
    @IBOutlet weak var peso: UILabel?
    @IBOutlet weak var altura: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if personatipo == "1"
        {
            userID = user2
        }
        
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "HH':'mm"
        
        let formatter2 = DateFormatter()
                       formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        db.child("users/\(userID)/perfil").observe(.value, with: { snapshot in
              
          
        
            let value1 = snapshot.value as? [String: AnyObject]
                
               
                
           let nombre = value1?["nombre"] as? String
           let apellido = value1?["apellido"] as? String
            
            let peso = value1?["peso"] as? Int
            let altura = value1?["altura"] as? Int
           
              
           
               let telefono = value1?["telefono"] as? Int
                let sexo = value1?["sexo"] as? String
            let edad = value1?["edad"] as? Int
                  
            self.nombre?.text = nombre! + " " + apellido!
                print(peso)
            self.edad?.text = String(edad!)
            self.peso?.text = String(peso!)
                
               print(value1)
            self.altura?.text = String(altura!)
            self.telefono?.text = String(telefono!)
            self.sexo?.text = sexo!
              
        
              
            
              })
                   

        if personatipo == "1"
        {
            userID = user2
        }
                
        db.child("users/\(userID)/frecuencia_cardiaca").queryLimited(toLast: 10).observe(.value, with: { snapshot in
        
         var frecuenciaLista = ""
         
          
          for child in snapshot.children
          {
           
          
           let snapshot2 = child as? DataSnapshot
            
         
            let dateString = snapshot2?.key as? String
             
            let value = snapshot2?.value as? [String: AnyObject]
            let frecuencia = value?["frecuencia"] as? String
           
        
            
            var logFrecuencia =  frecuencia! + " - " + dateString! 
            
            frecuenciaLista = frecuenciaLista + logFrecuencia + "\n"
            
            }
            
           
            
          
                self.listaFrec?.text = frecuenciaLista
         
            
        })
            
      
                
              
          
            
              
                  
              
           
          }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
