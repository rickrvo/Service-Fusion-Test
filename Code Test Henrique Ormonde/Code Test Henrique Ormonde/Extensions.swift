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
        
        if dict["image"] != nil {
            dict["image"] = String(data: dict["image"] as! Data, encoding: .utf8)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let reqJSONStr = String(data: jsonData, encoding: .utf8)
            return reqJSONStr
        }
        catch{}
        return nil
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
