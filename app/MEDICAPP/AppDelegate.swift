//
//  AppDelegate.swift
//  MEDICAPP
//
//  Created by Gabriela Viñas on 9/29/19.
//

import UIKit
import UserNotifications
import Firebase
import GoogleMaps
import GooglePlaces
import FirebaseDatabase

let googleApiKey = "AIzaSyBPY05CqaJ55b4j9FUEjOWQCXrZ1C0HEAQ"
let db = Database.database().reference()
var userID = "0"
var user1 = "0"
var user2 = "0"
var personatipo = "-1"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)

         
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        
      
       
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (accepted, error) in
            if !accepted{
                print ("Authorization denied")
            }
        }
        let takeAction = UNNotificationAction(identifier: "takePill", title: "Take pill", options: [])
        let laterAction = UNNotificationAction(identifier: "laterPill", title: "Postpone pill", options: [])
        let category = UNNotificationCategory(identifier: "pillCategory", actions:[takeAction, laterAction], intentIdentifiers: [], options:[])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }
    
    func schedulePillNotification (from pill: Pill, at time: Date ){
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time) as NSDateComponents
        
        print ("Pill time: \(timeComponents.hour):\(timeComponents.minute):\(timeComponents.second)")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents as DateComponents, repeats:true)
        
        let content = UNMutableNotificationContent()
        content.title = "MedicApp"
        content.subtitle = "Recordatorio de Medicamento"
        content.body = "Hora de tomar \(pill.pillName). "
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "pillCategory"
        
        var pillIdentifier = ""
        if (pill.status != 0){
            pillIdentifier = pill.uuid
        }
        else{
            pillIdentifier = pill.uuid + "l"
        }
        
        let request = UNNotificationRequest(identifier: pillIdentifier, content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print (error)
            }
        }
        
        
        var displayString = "Current Pending Notifications "
        
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            (requests) in
            displayString += "count: \(requests.count)\t"
            for request in requests{
                displayString += request.identifier + "\t"
            }
            print(displayString)
        }
    }
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

