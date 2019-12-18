//
//  pacientesViewController.swift
//  MEDICAPP
//
//  Created by monica bayona on 12/12/19.
//  Copyright © 2019 Paola Bayona. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseDatabase
import FirebaseAuth

class pacientesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    

    

    @IBAction func cerrarSesion(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
               do {
                 try firebaseAuth.signOut()
               } catch let signOutError as NSError {
                 print ("Error signing out: %@", signOutError)
               }
               
               if Auth.auth().currentUser == nil {
                         self.performSegue(withIdentifier: "cerrar", sender: nil)
                     }
        
    }
    

    
    @IBAction func añadirPaciente(_ sender: Any) {
        
        self.performSegue(withIdentifier: "registrarPaciente", sender: nil)
        
    }
    
            @IBOutlet weak var tableView: UITableView!
            
           
            var pillList = [Paciente]()
            
            
            override func viewDidLoad() {
                super.viewDidLoad()
                let db = Database.database().reference()
             
                tableView.delegate = self
                tableView.dataSource = self
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH':'mm"
                userID = user1
                
                db.child("users/\(userID)/pacientes").observe(.value, with: { snapshot in
                    self.pillList.removeAll()
                    print("paso2222")
                   
                   print(userID)
                   for child in snapshot.children {
                   
                    let value1 = snapshot.value as? [String: AnyObject]
               
                   
                    let snapshot2 = child as? DataSnapshot
                      print(snapshot2)
                    let idUsuario = snapshot2?.key
              
                    
                     if let snapshot = child as? DataSnapshot,
                        
                        let value = snapshot.value as? [String: AnyObject],
                        let nombre = value["nombre"] as? String,
                        let id = value["id"] as? String,
                    
                       let apellido = value["apellido"] as? String,
                       
                        let pillItem  = Paciente(name: nombre, apellido: apellido, uuid: id, temp: "temp"){
                        print(pillItem)
                         self.pillList.append(pillItem)
                         print("paso")
                    }
                         
                        
                        
                       
                        
                        
                    
                   }
                self.tableView.reloadData()
                   
                 })
                
              
             
            }
            
            

            
            func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }
            
         
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return pillList.count
            }
            
         
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                let cellIdentifier = "cell"
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PillCell  else {
                    fatalError("The dequeued cell is not an instance of PillTableViewCell.")
                }
                
              
                let pill = pillList[indexPath.row]
                
                cell.pillNameLabel.text = pill.nombre + " " + pill.apellido
                
                
              
            
                cell.backgroundColor = UIColor.white
            
               
                cell.layer.cornerRadius = 12
                cell.layer.masksToBounds = true
                cell.layer.borderWidth = 1
                
                return cell
            }
            
           
            internal  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
               
                
                tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                
               
                let pill = pillList[indexPath.row]
                user2 = pill.uuid
                user1 = userID
                personatipo = "1"
                
                self.performSegue(withIdentifier: "signUptoHome", sender: nil)
                
                

                tableView.reloadData()
                
            }
            
            
            func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
            {
                userID = user1
                let pill = pillList[indexPath.row]
                
               
             
                
               
                let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { (action, view, handler) in
                    os_log("Paciente pill action Tapped.", log: OSLog.default, type: .debug)
                    
                   var userID = Auth.auth().currentUser!.uid
                    db.child("users/\(userID)/pacientes/\(pill.uuid)").removeValue {_,_ in
                        }
                    
                    
                    
                   
                    //self.pillList.remove(at: indexPath.row)
                    tableView.reloadData()
                    self.savePills()
                    
                }
                deleteAction.backgroundColor = .red
                
                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                configuration.performsFirstActionWithFullSwipe = true
                return configuration
            }
            
         
            private func savePills() {
                
                
                let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(pillList, toFile: Pill.ArchiveURL.path)
                
                
                
                
                
                if isSuccessfulSave {
                    os_log("pacientes successfully saved.", log: OSLog.default, type: .debug)
                    
                } else {
                    os_log("Failed to save pacientes...", log: OSLog.default, type: .error)
                }
            }
            
           
            private func loadPills() -> [Paciente]?  {
                
                
               // return NSKeyedUnarchiver.unarchiveObject(withFile: Pill.ArchiveURL.path) as? [Pill]
                return pillList
            }
        }

