//
//  FrecuenciaListViewController.swift
//  MEDICAPP
//
//  Created by monica bayona on 11/1/19.
//  Copyright © 2019 Paola Bayona. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?

    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}


extension ChartXAxisFormatter: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
        let referenceTimeInterval = referenceTimeInterval
        else {
            return ""
        }
         dateFormatter.dateFormat = "MM/dd"
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }

}



class FrecuenciaListViewController: UIViewController {

    @IBOutlet weak var linechart: LineChartView!
    
    @IBAction func guardar(_ sender: Any) {
                
                  
                  let image2 = self.linechart.getChartImage(transparent: false)
                  print(image2)
                   UIImageWriteToSavedPhotosAlbum(image2!, nil, nil, nil)
        
    }
    struct Frecuencia {
        var fecha = 0.0
        var hora = 0.0
        var frecuencia = 0.0
       }
    
    var frecuencias: [Frecuencia] = []
    
   
    
   
    
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
        
        var referenceTimeInterval: TimeInterval = 0
        db.child("users/\(userID)/frecuencia_cardiaca").queryLimited(toLast: 25).observe(.value, with: { snapshot in
            self.frecuencias.removeAll()
            
            
             
             for child in snapshot.children {
              
             
              
               if let snapshot2 = child as? DataSnapshot,
                let dateString = snapshot2.key as? String,
                
                let value = snapshot2.value as? [String: AnyObject],
                let frecuencia = value["frecuencia"] as? String,
                 let horaString = value["hora"] as? String,
                 let hora = dateFormatter.date (from: horaString),
                
                let date = formatter2.date (from: dateString)
                {
                    
                let pfrecuencia = (frecuencia as NSString).doubleValue
                    
                  
                let horaInterval = hora.timeIntervalSince1970
                let xHora = (horaInterval - referenceTimeInterval) / (3600 * 24)
                let timeInterval = date.timeIntervalSince1970
                
                let xfecha = (timeInterval - referenceTimeInterval) / (3600 * 24)

               let yValue = pfrecuencia
            
                
                let r = Frecuencia(fecha: xfecha, hora: xHora, frecuencia: yValue)
                
                    
                
                
                self.frecuencias.append(r)
                  
                      
                  
               
              }
                   
                  
                  self.updateChart()
                 
                  
                  
              
             }
          
             
           })

        // Do any additional setup after loading the view.
    }
    
   
    
    
    private func updateChart() {
        let referenceTimeInterval: TimeInterval = 0
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        //formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        formatter.dateStyle = .short
        
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        
        linechart.xAxis.valueFormatter = xValuesNumberFormatter

        
        var chartEntry = [ChartDataEntry]()
        
        for i in 0..<frecuencias.count {
            
            let value = ChartDataEntry(x: Double(frecuencias[i].fecha), y: Double(frecuencias[i].frecuencia));        chartEntry.append(value)    }
        let line = LineChartDataSet(entries: chartEntry, label: "Frecuencia Cardiaca")
        line.colors = [UIColor.green]
        let data = LineChartData()
        data.addDataSet(line)
        linechart.data = data
        linechart.chartDescription?.text = "Frecuencia Cardiaca"
    
        
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
