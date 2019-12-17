//
//  pacientenuevoViewController.swift
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

import UIKit

class pacientenuevoViewController: FormViewController {
    
    struct FormItems {
        static let nombre = "name"
        static let edad = "edad"
        static let apellido = "apellido"
        static let altura = "altura"
        static let peso = "peso"
        static let sexo = "sexo"
        static let cuidador = "cuidador"
        static let telefono = "telefono"
    }
    
 
    
    func registrar (nombre: String, apellido: String,sexo: String, edad: Int, altura: Int,peso: Int, telefono: Int)
    
    {
        let db = Database.database().reference()
        
        
                  let uuid = UUID().uuidString
            
            db.child("users/\(uuid)/perfil/nombre").setValue(nombre)
            
            db.child("users/\(uuid)/perfil/apellido").setValue(apellido)
            
            db.child("users/\(String(describing: uuid))/perfil/edad").setValue(edad)
             print("paso")
            db.child("users/\(String(describing: uuid))/perfil/sexo").setValue(sexo)
            db.child("users/\(String(describing: uuid))/perfil/altura").setValue(altura)
            db.child("users/\(String(describing: uuid))/perfil/peso").setValue(peso)
            db.child("users/\(String(describing: uuid))/perfil/telefono").setValue(telefono)
            db.child("users/\(String(describing: uuid))/perfil/cuidador").setValue("0")
        
            db.child("users/\(String(describing: uuid))/perfil/sexo").setValue(sexo)
            db.child("users/\(userID)/pacientes/\(uuid)/id").setValue(uuid)
        db.child("users/\(userID)/pacientes/\(uuid)/nombre").setValue(nombre)
        db.child("users/\(userID)/pacientes/\(uuid)/apellido").setValue(apellido)
        
         self.performSegue(withIdentifier: "RegresarHomeCuidador", sender: nil)
              
            
            }
            
             
             //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
             
             
       
    
    
    

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
        
        form +++ Section("Perfil")
           
            <<< TextRow(FormItems.nombre) {
                $0.title = "Nombre"
                $0.add(rule: required)
                $0.add(rule: min2)
                $0.add(rule: max25)
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
           
            <<< TextRow(FormItems.apellido) {
                $0.title = "Apellido"
                $0.add(rule: required)
                $0.add(rule: min2)
                $0.add(rule: max25)
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
            
            
            
            <<< IntRow(FormItems.telefono) {
                           $0.title = "Teléfono de emergencia"
                           $0.value = 0000
                           $0.add(rule: RuleGreaterThan(min: 99, msg: "Ingrese un numero mayor a 2 digitos"))
                           $0.add(rule: RuleSmallerThan(max: 1000000000000000, msg: "Ingrese un numero menor a 20 digitos"))
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
                   
            <<< PickerInputRow<Int>(FormItems.edad){
                        $0.title = "Edad"
                        $0.options = []
                        for i in 0...120{
                            $0.options.append(i)
                        }
                        $0.value = $0.options.first
                    }
            <<< PickerInputRow<Int>(FormItems.altura){
                        $0.title = "Altura en cm"
                        $0.options = []
                        for i in 1...230{
                            $0.options.append(i)
                        }
                        $0.value = $0.options.first
                    }
            <<< PickerInputRow<Int>(FormItems.peso){
                        $0.title = "Peso en kg"
                        $0.options = []
                        for i in 1...230{
                            $0.options.append(i)
                        }
                        $0.value = $0.options.first
                    }
            <<< PickerInputRow<String>(FormItems.sexo){
                        $0.title = "Sexo"
                        $0.options = ["m","f"]
                        
                        $0.value = $0.options.first
                    }
            
            
     
          
    
            
        <<< ButtonRow { row in
            row.title = "Registrarse"
            }.onCellSelection({ [unowned self] (cell, row) in
                row.section?.form?.validate();
                if let nombre2 = self.form.rowBy(tag: FormItems.nombre) as? RowOf<String>,
                    let nombre = nombre2.value,
                    let apellido2 = self.form.rowBy(tag: FormItems.apellido) as? RowOf<String>,
                    let apellido = apellido2.value,
                    let edad2 = self.form.rowBy(tag: FormItems.edad) as? RowOf<Int>,
                    let edad = edad2.value,
                    let sexo2 = self.form.rowBy(tag: FormItems.sexo) as? RowOf<String>,
                    let sexo = sexo2.value,
                    let peso2 = self.form.rowBy(tag: FormItems.peso) as? RowOf<Int>,
                    let peso = peso2.value,
                    let altura2 = self.form.rowBy(tag: FormItems.altura) as? RowOf<Int>,
                    let altura = altura2.value,
                    let telefono2 = self.form.rowBy(tag: FormItems.telefono) as? RowOf<Int>,
                    let telefono = telefono2.value
                    
                {
                    
                    if self.form.validate().isEmpty {
                    
                        self.registrar( nombre: nombre, apellido: apellido, sexo: sexo, edad: edad, altura: altura, peso: peso, telefono: telefono)
                  }
                
                   
                    
                    
                    
                    
                    
                    
                  //  birthDateRow.value = Date(timeInterval: -900*365*86400, since: Date())
                 //   birthDateRow.updateCell()
                    
                  //  likeRow.value = true
                 //   likeRow.updateCell()
                    
                //    row.disabled = .function([FormItems.name]) { form in
               //         (form.rowBy(tag: FormItems.name) as? RowOf<String>)?.value == "Yoda"
              //      }
              //      row.evaluateDisabled()
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
