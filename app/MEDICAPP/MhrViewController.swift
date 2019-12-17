//
//  mhrViewController.swift
//  MEDICAPP
//
//  Created by Gabriela Viñas on 10/4/19.
//  Copyright © 2019 Felipe Rivera. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import Firebase
import FirebaseDatabase
 
class mhrViewController: UIViewController {
    
    @IBOutlet weak var labelV: UILabel!
    @IBOutlet weak var tapV: UIView!
    let tapR = UITapGestureRecognizer()
    
    
    var healthStore: HKHealthStore? = nil
    var startTime: TimeInterval? = nil
   
    var lpm = 0.0
    var numTaps = 0.0
    let lpmTipo =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if personatipo == "1"
        {
            userID = user2
        }
        tapR.addTarget(self, action: #selector(mhrViewController.tappedView))
        tapV.addGestureRecognizer(tapR)
        tapV.isUserInteractionEnabled = true
    }
    
    
    @objc func tappedView() {
        
        
        
        if let start = startTime {
            numTaps += 1
            
            let now = Date().timeIntervalSince1970
            let elapsed = now-start
            lpm = (60/elapsed) * numTaps
            
            if numTaps == 15 {
                
                let currentDateTime = Date()
                
                let formatter = DateFormatter()
                     formatter.dateFormat = "HH:mm"
                
                let formatter2 = DateFormatter()
                formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let stringTime: String = formatter.string(from: currentDateTime)
                     
                let stringDate: String = formatter2.string(from: currentDateTime)

                
                
                let msg = "Tu frecuencia cadiaca es:" + String(Int(lpm)) + " lpm"
                
                db.child("users/\(userID)/frecuencia_cardiaca/\(stringDate)/frecuencia").setValue(String(Int(lpm)))
                             
                db.child("users/\(userID)/frecuencia_cardiaca/\(stringDate)/hora").setValue(stringTime)

                
                let tapAlert = UIAlertController(title: "Listo!", message: msg, preferredStyle:
                    UIAlertController.Style.alert)
                //tapAlert.addAction(UIAlertAction(title: "Adicionar a Health", style: .destructive, handler:
                    //addToHomeKit))
                tapAlert.addAction(UIAlertAction(title: "Tomar otra vez", style: .destructive, handler:
                    reset))
                
                self.present(tapAlert, animated: true, completion: nil)
            }
            
            labelV.text = "Continua tocando!"
        }
        else {
            startTime = Date().timeIntervalSince1970
        }
        
    }
    
    func addToHomeKit(_ alert: UIAlertAction!){
        
        if isHealthAvailable() && isHealthAuthorized() {
            let lpmCantidad = HKQuantity(unit: HKUnit(from: "cuenta/min"),doubleValue:lpm)
            let lpmMuestra = HKQuantitySample(type: lpmTipo!, quantity: lpmCantidad, start: Date(), end: Date())
            
          
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                       AnalyticsParameterItemID: "test",
                       AnalyticsParameterItemName: "test",
                       AnalyticsParameterContentType: "cont"
                       ])
            
            healthStore!.save(lpmMuestra, withCompletion: {(success, error) -> Void in
                if let err = error {
                    NSLog("Error guardando la muestra de LPM: \(err.localizedDescription)")
                }
            })
        }
        else {
            alertError("Debes autorizar que esta app se comunique con Health")
        }
        
        reset(nil)
        
    }
    
    func isHealthAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    func isHealthAuthorized() -> Bool {
        return healthStore!.authorizationStatus(for: lpmTipo!) == HKAuthorizationStatus.sharingAuthorized
    }
    func requestAuthorization() {
        let lpmTipos : Set<HKSampleType> = [lpmTipo!]
        
        
        healthStore!.requestAuthorization(toShare: lpmTipos, read: [],
                                          completion: {(Success, error) -> Void in
                                            if let err = error {
                                                NSLog("Error al solicitar acceso \(err.localizedDescription)")
                                            }
                                            
        })
        
    }
    
    func reset(_ alert: UIAlertAction!){
        numTaps = 0.0
        startTime = nil
        labelV.text = "Toca el corazon al ritmo del pulso!"
    }
    
    func alertError(_ msg: String){
        let tapAlert = UIAlertController(title: "Alerta!", message: msg, preferredStyle:
            UIAlertController.Style.alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: reset))
        
        self.present(tapAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}


