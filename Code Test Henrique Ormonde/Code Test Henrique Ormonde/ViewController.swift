//
//  ViewController.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 19/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var peopleTableView: UITableView!
    @IBOutlet weak var but_MoreOptions: UIButton!
    @IBOutlet weak var but_AddPerson: UIButton!
    @IBOutlet weak var txt_Search: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        
        request.predicate = NSPredicate(format: "firstName = %@", "Rick")
        
        
        request.returnsObjectsAsFaults = false
        
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


    
    //    MARK: Table View Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

