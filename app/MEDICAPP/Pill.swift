//  Codigo tomado e inspirado por https://github.com/rffuste/ePill
//
//  Pill.swift
//  MEDICAPP
//
//  Created by Gabriela Viñas on 9/29/19.
//  Copyright © 2019 Felipe Rivera. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Pill: NSObject, NSCoding {
    
    
    var pillName: String = ""
    var status: Int8
    var time: Date
    var uuid: String = ""
    
    
    
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("pills")
    
   
    struct PropertyKey {
        static let name = "name"
        static let status = "status"
        static let time = "time"
        static let uuid = "uuid"
    }
    
  
    init(name:String, time:Date) {
        
        self.pillName = name
        self.status = -1
        self.time = time
        self.uuid = UUID().uuidString
       
        
    }
    
    init?(name:String, time:Date, uuid:String,status : Int8 ) {
        
        self.pillName = name
        self.status = status
        self.time = time
        self.uuid = uuid
       
        
    }
    
   
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(pillName as String, forKey:PropertyKey.name)
        aCoder.encode(status as Int8,  forKey:PropertyKey.status)
        aCoder.encode(time as Date, forKey:PropertyKey.time)
        aCoder.encode(uuid as String, forKey:PropertyKey.uuid)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Pill object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? Date else {
            os_log("Unable to decode the time for a Pill object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard (aDecoder.decodeObject(forKey: PropertyKey.uuid) as? String) != nil else {
            os_log("Unable to decode the uuid for a Pill object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(name: name, time: time)
    }
    
}
