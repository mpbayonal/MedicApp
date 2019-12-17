//
//  Paciente.swift
//  MEDICAPP
//
//  Created by monica bayona on 12/12/19.
//  Copyright © 2019 Paola Bayona. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Paciente: NSObject, NSCoding {
    
    
    var nombre: String = ""
    var apellido: String = ""
 
    var uuid: String = ""
    
    
    
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("pills")
    
   
    struct PropertyKey {
        static let name = "name"
       

        static let apellido = "apellido"
        static let uuid = "uuid"
    }
    
  
    init(name:String, apellido:String, uuid:String) {
        
        self.nombre = name
        self.apellido = apellido
       
      
        self.uuid = uuid
       
        
    }
    
    init?(name:String, apellido:String, uuid:String, temp: String) {
        
        self.nombre = name
        self.apellido = apellido
        
        
        self.uuid = uuid
       
        
    }
    
   
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nombre as String, forKey:PropertyKey.name)
        aCoder.encode(apellido as String, forKey:PropertyKey.apellido)
        aCoder.encode(uuid as String, forKey:PropertyKey.uuid)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Pill object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let apellido = aDecoder.decodeObject(forKey: PropertyKey.apellido) as? String else {
            os_log("Unable to decode the name for a Pill object.", log: OSLog.default, type: .debug)
            return nil
        }
        
     guard let id = aDecoder.decodeObject(forKey: PropertyKey.uuid) as? String else {
         os_log("Unable to decode the name for a Pill object.", log: OSLog.default, type: .debug)
         return nil
     }
        
   
        
        self.init(name: name, apellido: apellido, uuid: id)
    }
    
}




