//
//  login2ViewController.swift
//  MEDICAPP
//
//  Created by monica bayona on 12/12/19.
//  Copyright © 2019 Paola Bayona. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import FirebaseAuth
import FirebaseDatabase




      











class login2ViewController: FormViewController {
    
    struct FormItems {
        
           static let contraseña = "contraseña"
           static let email = "email"
       }
    
    func login(email: String, password: String)
    {
    Auth.auth().signIn(withEmail: email, password: password) { user, error in
                 if let error = error, user == nil {
                   let alert = UIAlertController(title: "Error al iniciar sesión",
                                                 message: error.localizedDescription,
                                                 preferredStyle: .alert)
                   
                   alert.addAction(UIAlertAction(title: "OK", style: .default))
                   
                   self.present(alert, animated: true, completion: nil)
                 }
               }
             

               Auth.auth().addStateDidChangeListener() { auth, user in
                  // 2
                  if user != nil {
                    
                    userID = Auth.auth().currentUser!.uid
                    db.child("users").child(userID).child("perfil").observeSingleEvent(of: .value, with: { (snapshot) in
                      // Get user value
                      let value = snapshot.value as? NSDictionary
                      let cuidador = value?["cuidador"] as? String ?? ""
                        if cuidador == "0"{
                            personatipo = "0"
                            user1 = userID
                            print("irHome")
                            self.performSegue(withIdentifier: "loginToHome", sender: nil)}
                         if cuidador == "1"
                        {
                             self.performSegue(withIdentifier: "loginToHomeCuidador", sender: nil)
                            personatipo = "1"
                            user1 = userID
                            print(userID)
                            
                        }
                    // ...
                      }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                    
                    // 3
                    
           
                  }
                }
    }
        
        
        
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let required = RuleRequired<String>(msg: "Ingrese un valor")
               var min6 = RuleMinLength(minLength: 6);
                            min6.validationError = ValidationError(msg: "Debe contener al menos 6 caracteres.")
               var min2 = RuleMinLength(minLength: 2);
                                   min2.validationError = ValidationError(msg: "Debe contener al menos 2 caracteres.")
                      var max25 = RuleMaxLength(maxLength: 25);
                      max25.validationError = ValidationError(msg: "Debe contener menos de 25 caracteres.")
               var max30 = RuleMaxLength(maxLength: 30);
               max30.validationError = ValidationError(msg: "Debe contener menos de 30 caracteres.")
        
        
        tableView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
         form +++ Section("Ingrese sus datos")
            
        <<< TextRow(FormItems.email) {
                        $0.title = "Email"
                        $0.add(rule: required)
                           $0.add(rule: min2)
                              $0.add(rule: max30)
                        $0.validationOptions = .validatesOnChange
                        }
                        .cellUpdate { cell, row in
                            if !row.isValid {
                                cell.titleLabel?.textColor = .red
                            }
                        }
                        .onRowValidationChanged { cell, row in
                            let rowIndex = row.indexPath!.row
                            while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                                row.section?.remove(at: rowIndex + 1)
                            }
                            if !row.isValid {
                                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                                    let labelRow = LabelRow() {
                                        $0.title = validationMsg
                                        $0.cell.height = { 30 }
                                    }
                                    let indexPath = row.indexPath!.row + index + 1
                                    row.section?.insert(labelRow, at: indexPath)
                                }
                            }
                    }
                   
                   
                 
                   
               <<< PasswordRow(FormItems.contraseña) {
                   $0.title = "Contraseña"
                   $0.add(rule: min6)
                   $0.add(rule: max25)
                   $0.add(rule: required)
                   }
                   .cellUpdate { cell, row in
                       if !row.isValid {
                           cell.titleLabel?.textColor = .red
                       }
                   }
                   .onRowValidationChanged { cell, row in
                       let rowIndex = row.indexPath!.row
                       while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                           row.section?.remove(at: rowIndex + 1)
                       }
                       if !row.isValid {
                           for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                               let labelRow = LabelRow() {
                                   $0.title = validationMsg
                                   $0.cell.height = { 30 }
                               }
                               let indexPath = row.indexPath!.row + index + 1
                               row.section?.insert(labelRow, at: indexPath)
                           }
                       }
               }

        
        <<< ButtonRow { row in
                   row.title = "Iniciar sesion"
                   }.onCellSelection({ [unowned self] (cell, row) in
                       row.section?.form?.validate();
                       if let email2 = self.form.rowBy(tag: FormItems.email) as? RowOf<String>,
                           let email = email2.value,
                           let password2 = self.form.rowBy(tag: FormItems.contraseña) as? RowOf<String>,
                           let password = password2.value
                      
                
                       {
                           
                           if self.form.validate().isEmpty {
                           
                            self.login(email: email, password: password)
                         }
        
                         }
                                            
                                    } )

                                            
                                            
                                            
                                // Do any additional setup after loading the view.
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
