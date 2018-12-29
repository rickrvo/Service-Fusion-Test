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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func but_BackTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func savePerson() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
        let context = appDelegate.persistentContainer.viewContext
    
        //        Add People to phonebook
    
        let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
    
        newPerson.setValue("Rick", forKey: "firstName")
    
        do {
            try context.save()
    
            print("saved")
    
        } catch {
            print("There was an error")
        }
        
        //        Get People
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.returnsObjectsAsFaults = false
        
        //        request.predicate = NSPredicate(format: "firstName = %@", "Rick")
        
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let userName = result.value(forKey: "firstName") as? String {
                        print(userName)
    //                        To update value
                        result.setValue("Rick2", forKey: "firstName")

                        do{
                            try context.save()
                        } catch {
                            print("update failed")
                        }
                    }
                }
            }
        } catch {
            print("Error loading data")
        }
    }
    
    // MARK: Text Field Delegates
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
            
            newPerson.setValue("Rick", forKey: "firstName")
            
        } else {
            
        }
    }
    
    
    // MARK: Button Actions
    
    @IBAction func but_addAddress_Tap(_ sender: Any) {
        
    }
    
    @IBAction func but_addNumber_Tap(_ sender: Any) {
        
    }
    
    @IBAction func but_addEmail_Tap(_ sender: Any) {
        
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
