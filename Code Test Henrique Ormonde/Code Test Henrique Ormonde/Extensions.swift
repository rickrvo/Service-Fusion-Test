//
//  Extensions.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 04/01/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import Contacts


extension NSManagedObject {
    func toJSON() -> String? {
        let keys = Array(self.entity.attributesByName.keys)
        var dict = self.dictionaryWithValues(forKeys: keys)
        
        if dict["birthDate"] != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            
            let stringDate: String = formatter.string(from: dict["birthDate"] as! Date)
            dict["birthDate"] = stringDate
        }
        
//        if dict["image"] != nil {
//            dict["image"] = String(data: dict["image"] as! Data, encoding: .utf8)
//        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let reqJSONStr = String(data: jsonData, encoding: .utf8)
            return reqJSONStr
        }
        catch{}
        return nil
    }
    
    func toContact() -> CNContact? {
        // Creating a mutable object to add to the contact
        let contact = CNMutableContact()
        
        contact.imageData = Data()
        if let image = self.value(forKey: "image") as? Data {
            contact.imageData = image
        }
        if let firstName = self.value(forKey: "firstName") as? String {
            contact.givenName = firstName
        }
        if let lastName = self.value(forKey: "lastName") as? String {
            contact.familyName = lastName
        }
        
        var emails = [CNLabeledValue<NSString>]()
        if let emailList = self.value(forKey: "emails") as? String {
            let emailL = emailList.split(separator: ";")
            for email in emailL {
                let insertEmail = CNLabeledValue(label:CNLabelOther, value:NSString(string: String(email)))
                emails.append(insertEmail)
            }
        }
        contact.emailAddresses = emails
        
        var numbers = [CNLabeledValue<CNPhoneNumber>]()
        if let numberList = self.value(forKey: "phoneNumbers") as? String {
            let phones = numberList.split(separator: ";")
            var main = false
            for phone in phones {
                if main == false {
                    main = true
                    let insertNumber = CNLabeledValue(label:CNLabelPhoneNumberMain, value:CNPhoneNumber(stringValue:String(phone)))
                    numbers.append(insertNumber)
                } else {
                    let insertNumber = CNLabeledValue(label:CNLabelPhoneNumberMobile, value:CNPhoneNumber(stringValue:String(phone)))
                    numbers.append(insertNumber)
                }
            }
        }
        contact.phoneNumbers = numbers
        
        var addresses = [CNLabeledValue<CNMutablePostalAddress>]()
        if let addressList = self.value(forKey: "addresses") as? String {
            let addrs = addressList.split(separator: ";")
            for addr in addrs {
                let homeAddress = CNMutablePostalAddress()
                homeAddress.street = String(addr)
                let insertAddr = CNLabeledValue(label:CNLabelOther, value:homeAddress)
                addresses.append(insertAddr)
            }
        }
        contact.postalAddresses = addresses as! [CNLabeledValue<CNPostalAddress>]
        
        if let birthday = self.value(forKey: "birthDate") as? Date {
            let components = Calendar.current.dateComponents([.year,.month,.day], from: birthday)
            contact.birthday = components
        }
        
        return contact as CNContact
    }
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

extension String {
    func toPerson(person: Person) -> Void {
        
        var dict = convertToDictionary(text: self)
        
        if dict?["birthDate"] != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let date = dateFormatter.date(from: dict?["birthDate"] as! String)
            dict?["birthDate"] = date
        }
        
        if dict?["image"] != nil {
            let img = (dict?["image"] as! String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            dict?["image"] = img
        }
        
        person.id = dict?["id"] as! Int32
        person.addresses = dict?["addresses"] as? String
        person.emails = dict?["emails"] as? String
        person.phoneNumbers = dict?["phoneNumbers"] as? String
        person.firstName = dict?["firstName"] as? String
        person.lastName = dict?["lastName"] as? String
        person.birthDate = dict?["birthDate"] as? Date
        person.image = dict?["image"] as? Data
    }
}
