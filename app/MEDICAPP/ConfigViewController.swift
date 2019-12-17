//  Codigo tomado e inspirado por https://github.com/rffuste/ePill
//
//  ViewController.swift
//  MEDICAPP
//
//  Created by Gabriela Viñas on 9/29/19.
//  Copyright © 2019 Felipe Rivera. All rights reserved.
//

import UIKit
import UserNotifications


extension UNUserNotificationCenter {
    func cleanRepeatingNotifications(){
        print ("Cleaning all notification requests....")
        getPendingNotificationRequests {(requests) in
            for request in requests{
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [request.identifier])
            }
        }
    }
}

class ConfigViewController: UIViewController {
    

    
 
    
    @IBAction func deleteAllNotifications(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        center.cleanRepeatingNotifications()
    }
    
    @IBAction func checkNotifications(_ sender: Any) {
        
        var displayString = ""
        
        
        print (" === Current Pending Notifications === ")
        
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            (requests) in
            displayString += "Notification count: \(requests.count)\t"
            for request in requests{
                displayString += request.identifier + ", \t"
            }
            print(displayString)
        }
    }
    
    
    
    
    
    
}

