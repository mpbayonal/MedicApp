//
//  signUp2ViewController.swift
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



extension AuthErrorCode {
    var description: String? {
        switch self {
        case .emailAlreadyInUse:
            return "Este correo ya está siendo usado por otro usuario"
        case .userDisabled:
            return "Este usuario ha sido deshabilitado"
        case .operationNotAllowed:
            return "Operación no permitida"
        case .invalidEmail:
            return "Correo electrónico no valido"
        case .wrongPassword:
            return "Contraseña incorrecta"
        case .userNotFound:
            return "No se encontró cuenta del usuario con el correo especificado"
        case .networkError:
            return "No hay conexion a internet"
        case .weakPassword:
            return "Contraseña muy debil o no válida"
        case .missingEmail:
            return "Hace falta registrar un correo electrónico"
        case .internalError:
            return "Error interno"
        case .invalidCustomToken:
            return "Token personalizado invalido"
        case .tooManyRequests:
            return "Ya se han enviado muchas solicitudes al servidor"
        default:
            return nil
        }
    }
}

   



public extension Error {
    var localizedDescription: String {
        let error = self as NSError
        if error.domain == AuthErrorDomain {
            if let code = AuthErrorCode(rawValue: error.code) {
                if let errorString = code.description {
                    return errorString
                }
            }
        }
        
        return error.localizedDescription
    } }

class signUp2ViewController: FormViewController {
    
    struct FormItems {
        static let nombre = "name"
        static let edad = "edad"
        static let apellido = "apellido"
        static let altura = "altura"
        static let peso = "peso"
        static let sexo = "sexo"
        static let contraseña = "contraseña"
        static let email = "email"
        static let cuidador = "cuidador"
        static let telefono = "telefono"
    }
    
 
    
    func registrar (email: String, password: String, nombre: String, apellido: String,sexo: String, edad: Int, altura: Int,peso: Int, cuidador: Bool, telefono: Int)
    
    {
        let db = Database.database().reference()
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            print(error?.localizedDescription as Any)
         if error == nil {
             print("You have successfully signed up")
            userID = Auth.auth().currentUser!.uid
            print(userID)
            
            db.child("users/\(userID)/perfil/nombre").setValue(nombre)
            
            db.child("users/\(userID)/perfil/apellido").setValue(apellido)
            
            db.child("users/\(String(describing: userID))/perfil/edad").setValue(edad)
            
            db.child("users/\(String(describing: userID))/perfil/sexo").setValue(sexo)
            db.child("users/\(String(describing: userID))/perfil/altura").setValue(altura)
            db.child("users/\(String(describing: userID))/perfil/peso").setValue(peso)
            db.child("users/\(String(describing: userID))/perfil/telefono").setValue(telefono)
            
            if cuidador {
               db.child("users/\(String(describing: userID))/perfil/cuidador").setValue("1")
                self.performSegue(withIdentifier: "signUptoHomeCuidador", sender: nil)
                personatipo = "1"
                user1 = userID
            }
            else
            {
                db.child("users/\(String(describing: userID))/perfil/cuidador").setValue("0")
                self.performSegue(withIdentifier: "signUptoHome", sender: nil)
                
                user2 = userID
                personatipo = "0"
            }
            
             
             //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
             
             
         } else {
            
            
            let alertController = UIAlertController(title: "No se pudo registrar el usuario", message: error?.localizedDescription, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
          
                if self.presentedViewController == nil {
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    self.dismiss(animated: false, completion: nil)
                    self.present(alertController, animated: true, completion: nil)
                }
        
            
            
            
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
                           $0.title = "Telefono de emergencia"
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
            
            
            <<< SwitchRow(FormItems.cuidador) {
            $0.title = "Tiene personas a su cargo"
            $0.value = false
        }
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

        <<< PasswordRow() {
            $0.title = "Confirmar contraseña"
            $0.add(rule: RuleEqualsToRow(form: form, tag: FormItems.contraseña, msg: "Las contraseñas no coinciden"))
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
            row.title = "Registrarse"
            }.onCellSelection({ [unowned self] (cell, row) in
                row.section?.form?.validate();
                if let nombre2 = self.form.rowBy(tag: FormItems.nombre) as? RowOf<String>,
                    let nombre = nombre2.value,
                    let email2 = self.form.rowBy(tag: FormItems.email) as? RowOf<String>,
                    let email = email2.value,
                    let password2 = self.form.rowBy(tag: FormItems.contraseña) as? RowOf<String>,
                    let password = password2.value,
                    let apellido2 = self.form.rowBy(tag: FormItems.apellido) as? RowOf<String>,
                    let apellido = apellido2.value,
                    let edad2 = self.form.rowBy(tag: FormItems.edad) as? RowOf<Int>,
                    let edad = edad2.value,
                    let sexo2 = self.form.rowBy(tag: FormItems.sexo) as? RowOf<String>,
                    let sexo = sexo2.value,
                    let esCuidador1 = self.form.rowBy(tag: FormItems.cuidador) as? RowOf<Bool>,
                    let cuidador = esCuidador1.value,
                    let peso2 = self.form.rowBy(tag: FormItems.peso) as? RowOf<Int>,
                    let peso = peso2.value,
                    let altura2 = self.form.rowBy(tag: FormItems.altura) as? RowOf<Int>,
                    let altura = altura2.value,
                    let telefono2 = self.form.rowBy(tag: FormItems.telefono) as? RowOf<Int>,
                    let telefono = telefono2.value
                    
                {
                    
                    if self.form.validate().isEmpty {
                    
                        self.registrar(email: email, password: password, nombre: nombre, apellido: apellido, sexo: sexo, edad: edad, altura: altura, peso: peso, cuidador: cuidador, telefono: telefono)
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
