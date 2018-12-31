//
//  EditPersonViewController.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 22/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit
import CoreData

class EditPersonViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    var person: Person?
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var but_Avatar: UIButton!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var date_birthDay: UIDatePicker!
    @IBOutlet weak var but_addAddress: UIButton!
    @IBOutlet weak var tableView_Address: UITableView!
    @IBOutlet weak var but_addNumber: UIButton!
    @IBOutlet weak var tableView_Number: UITableView!
    @IBOutlet weak var but_addEmail: UIButton!
    @IBOutlet weak var tableView_Email: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ((person?.id) != nil) {
            //   this is Edit mode

            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "id = %@", String(person!.id))
            
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        person = result as? Person
                        if (result.value(forKey: "firstName") as? String) != nil {
                            txt_firstName.text = result.value(forKey: "firstName") as? String
                            //                            person?.firstName = result.value(forKey: "firstName") as? String
                        }
                        if (result.value(forKey: "lastName") as? String) != nil {
                            txt_lastName.text = result.value(forKey: "lastName") as? String
                            //                            person?.lastName = result.value(forKey: "lastName") as? String
                        }
                        if (result.value(forKey: "addresses") as? String) != nil {
//                            person?.addresses = result.value(forKey: "addresses") as? String
                            tableView_Address.reloadData()
                        }
                        if (result.value(forKey: "phoneNumbers") as? String) != nil {
//                            person?.phoneNumbers = result.value(forKey: "phoneNumbers") as? String
                            tableView_Number.reloadData()
                        }
                        if (result.value(forKey: "emails") as? String) != nil {
//                            person?.emails = result.value(forKey: "emails") as? String
                            tableView_Email.reloadData()
                        }
                        if (result.value(forKey: "birthDate") as? String) != nil {
                            //                            person?.birthDate = result.value(forKey: "birthDate") as? Date
                            date_birthDay.date = result.value(forKey: "birthDate") as? Date ?? Date()
                        }
                        if (result.value(forKey: "image") as? UIImage) != nil {
                            img_Avatar.image = result.value(forKey: "image") as? UIImage
                        }
                    }
                }
            } catch {
                print("Error loading data")
            }
            
        } else {
            let count: Int = UserDefaults.standard.integer(forKey: "Autocount")
            UserDefaults.standard.set(count+1, forKey: "Autocount")
            UserDefaults.standard.synchronize()
            
            let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
            
            newPerson.setValue(Int32(count.advanced(by: 1)), forKey: "id")
            newPerson.setValue("", forKey: "firstName")
            newPerson.setValue("", forKey: "lastName")
            newPerson.setValue("", forKey: "addresses")
            newPerson.setValue("", forKey: "phoneNumbers")
            newPerson.setValue("", forKey: "emails")
            newPerson.setValue(Date(), forKey: "birthDate")
            newPerson.setValue(nil, forKey: "image")
            person = newPerson as? Person
            do {
                try context.save()
            } catch {
                print("Error saving newPerson")
            }
        }
        
    }
    
    @IBAction func but_BackTap(_ sender: Any) {
        
        if ((person?.id) != nil) {
            if (((txt_firstName?.text) != nil) || txt_firstName?.text == "") || (((txt_lastName?.text) != nil) || txt_lastName?.text == "") {
                // person created successfully
                print("person edited successfully")
            } else {
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
                request.returnsObjectsAsFaults = false
                
                request.predicate = NSPredicate(format: "id = %@", String(person!.id))
                
                do {
                    let results = try context.fetch(request)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            
                            if (result.value(forKey: "id") as? String) != nil {
                                context.delete(result)
                                print("discard person successfull")
                            }
                        }
                    }
                } catch {
                    print("Error loading empty person")
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func background_Tap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    // MARK: Text Field Delegates
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {

            if textField.text == "" || textField.text == nil {
                let alert = UIAlertController(title: "Alert", message: "First name or last name is required.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                textField.becomeFirstResponder()
                return
            }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            request.returnsObjectsAsFaults = false
            
            request.predicate = NSPredicate(format: "id = %@", String(person!.id))
            
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {

                        result.setValue(textField.text, forKey: "firstName")
                        
                        do {
                            try context.save()
                            person = result as? Person
                            print("update firstName successfull")
                        } catch {
                            print("update failed")
                        }
                    }
                }
            } catch {
                print("Error loading data")
            }
            
            
        } else if textField.tag == 2 {
            
            if textField.text == "" || textField.text == nil {
                let alert = UIAlertController(title: "Alert", message: "First name or last name is required.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                textField.becomeFirstResponder()
                return
            }

            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            request.returnsObjectsAsFaults = false
            
            request.predicate = NSPredicate(format: "id = %@", String(person!.id))
            
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        result.setValue(textField.text, forKey: "lastName")
                        
                        do {
                            try context.save()
                            person = result as? Person
                            print("update lastName successfull")
                        } catch {
                            print("update failed")
                        }
                    }
                }
            } catch {
                print("Error loading data")
            }
        }
        
        self.view.endEditing(true)
    }
    
    
//    MARK: Date Action
    
    @IBAction func birthDay_Change(_ sender: Any) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "id = %@", String(person!.id))
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                        
                    result.setValue(date_birthDay.date, forKey: "birthDate")
                    
                    do{
                        try context.save()
                        person = result as? Person
                        print("update birthday successfull")
                    } catch {
                        print("update failed")
                    }
                }
            }
        } catch {
            print("Error saving birthDate")
        }
    }
    
    
    // MARK: Button Actions
    
    @IBAction func but_addAddress_Tap(_ sender: Any) {
        
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addPopUpID") as! AddPopUpViewController
        
        popupVC.person = person
        popupVC.option = "address"
        
        self.addChild(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }
    
    @IBAction func but_addNumber_Tap(_ sender: Any) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addPopUpID") as! AddPopUpViewController
        
        popupVC.person = person
        popupVC.option = "number"
        
        self.addChild(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }
    
    @IBAction func but_addEmail_Tap(_ sender: Any) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addPopUpID") as! AddPopUpViewController
        
        popupVC.person = person
        popupVC.option = "email"
        
        self.addChild(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }
    
    //  MARK: Table View Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tableView_Address.tag {
            return person?.addresses?.split(separator: ";").count ?? 0
        }
        else if tableView.tag == tableView_Number.tag {
            return person?.phoneNumbers?.split(separator: ";").count ?? 0
        }
        else if tableView.tag == tableView_Email.tag {
            return person?.emails?.split(separator: ";").count ?? 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == tableView_Address.tag {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
            let addresses = person?.addresses?.split(separator: ";")
            cell.lbl_Address.text = String(addresses?[indexPath.row] ?? "")
            return cell
        }
        else if tableView.tag == tableView_Number.tag {
            let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath) as! NumberTableViewCell
            let numbers = person?.phoneNumbers?.split(separator: ";")
            cell.lbl_Number.text = String(numbers?[indexPath.row] ?? "")
            return cell
        }
        else if tableView.tag == tableView_Email.tag {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! EmailTableViewCell
            let emails = person?.emails?.split(separator: ";")
            cell.lbl_Email.text = String(emails?[indexPath.row] ?? "")
            return cell
        }
        
        return UITableViewCell()
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
