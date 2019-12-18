//  Codigo tomado e inspirado por https://github.com/rffuste/ePill
//
//  PillList.swift
//  MEDICAPP
//
//  Created by monica bayona on 12/12/19.
//  Copyright © 2019 Felipe Rivera. All rights reserved.
//

import Foundation
import UIKit
import os.log
import UserNotifications

import Firebase
import FirebaseDatabase
import FirebaseAuth


class PillList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
   
    var pillList = [Pill]()
    var userID = user1
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        if personatipo == "1"
        {
            userID = user2
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH':'mm"
        
        
     
        
        db.child("users/\(userID)/pastillasLista").queryLimited(toLast: 30).observe(.value, with: { snapshot in
            self.pillList.removeAll()
           
           for child in snapshot.children {
            let value1 = snapshot.value as? [String: AnyObject]
         
           
            let snapshot2 = child as? DataSnapshot
            let id = snapshot2?.key
      
            
             if let snapshot = child as? DataSnapshot,
                
                let value = snapshot.value as? [String: AnyObject],
                let nombre = value["nombre"] as? String,
                let horaString = value["hora"] as? String,
                let estado = value["estado"] as? Int,
                
                let hora = dateFormatter.date (from: horaString),
                let pillItem  = Pill(name: nombre, time: hora, uuid: id!, status: Int8(estado)){
                
                 self.pillList.append(pillItem)
            }
                 
                
                
               
                
                
            
           }
        self.tableView.reloadData()
           
         })
        
      
        if let savedPills = loadPills() {
            pillList += savedPills
        }
    }
    
    
    @IBAction func unwindToMain(sender:UIStoryboardSegue){
        
        let db = Database.database().reference()
        
        
        guard let newPillVC = sender.source as? NewPill else {return}
        
        if newPillVC.pillNameTxt.text! == "" {
            
            let alert = UIAlertController(title: "Error al añadir el medicamento",
                                                                  message: "El nombre del medicamento esta vacio",
                                                                  preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                   
                                  
            
            if self.presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.dismiss(animated: false, completion: nil)
                self.present(alert, animated: true, completion: nil)
            }
            
                        
        }
        else{
        
        let new = Pill(name:newPillVC.pillNameTxt.text!, time:newPillVC.pillTimePick.date)
        pillList.append(new)
        
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let stringDate: String = formatter.string(from: new.time)
        print(stringDate)
            
        
        
            
        
        
        pillList.sort {
            $0.time.compare($1.time) == ComparisonResult.orderedAscending
        }
        
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.schedulePillNotification(from: new, at: new.time)
        
        db.child("users/\(userID)/pastillasLista/\(new.uuid)/nombre").setValue(new.pillName)
        
        
        db.child("users/\(userID)/pastillasLista/\(new.uuid)/hora").setValue(stringDate)
        
        db.child("users/\(userID)/pastillasLista/\(new.uuid)/estado").setValue(-1)
        
        
        tableView.reloadData()
        savePills()
        }
        
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
        
        cell.pillNameLabel.text = pill.pillName
        
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        let timeTxt = formatter.string(from:pill.time)
        cell.pillTimeLabel.text? = timeTxt
       
        if (pill.status == 1){
            cell.backgroundColor = UIColor.green
            cell.pillImage.image = #imageLiteral(resourceName: "greenTick")
        }
        else
        {
            if (pill.status == 0)
            {
                cell.backgroundColor = UIColor.orange
            }
            else
            {
                cell.backgroundColor = UIColor.white
               
            }
        }
        
       
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        
        return cell
    }
    
   
    internal  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentDateTime = Date()
                                  
                               
                                  
                                  let formatter2 = DateFormatter()
                                  formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
                               
                                       
                                  let stringDate: String = formatter2.string(from: currentDateTime)
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
       
        let pill = pillList[indexPath.row]
        
        
        
        if (pill.status == -1){
            
           
           
            db.child("users/\(userID)/pastillasLista/\(pill.uuid)/estado").setValue(1)
            pill.status = 1
           
            db.child("users/\(userID)/logPastillas/\(stringDate)/nombreMedicamento").setValue(pill.pillName)
        
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pill.uuid])
            
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.schedulePillNotification(from: pill, at: pill.time)
            
        }
        else{
            if (pill.status == 0){
                
                
                pill.status = 1
                
                db.child("users/\(userID)/logPastillas/\(stringDate)/nombreMedicamento").setValue(pill.pillName)
                
                let pendingIdentifier = pill.uuid + "l"
                print (pendingIdentifier)
                
               
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pendingIdentifier])
                
              
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pill.uuid])
                
               
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate?.schedulePillNotification(from: pill, at: pill.time)
                
              
                UIApplication.shared.applicationIconBadgeNumber -= 1
            }
            else{
                db.child("users/\(userID)/pastillasLista/\(pill.uuid)/estado").setValue(-1)
                pill.status = -1
            }
        }
        

        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let pill = pillList[indexPath.row]
        
       
     
        
       
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { (action, view, handler) in
            os_log("Delete pill action Tapped.", log: OSLog.default, type: .debug)
            
           
            db.child("users/\(self.userID)/pastillasLista/\(pill.uuid)").removeValue {_,_ in
                }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pill.uuid])
            
            
           
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
            os_log("Pills successfully saved.", log: OSLog.default, type: .debug)
            
        } else {
            os_log("Failed to save pills...", log: OSLog.default, type: .error)
        }
    }
    
   
    private func loadPills() -> [Pill]?  {
        
        
       // return NSKeyedUnarchiver.unarchiveObject(withFile: Pill.ArchiveURL.path) as? [Pill]
        return pillList
    }
}

