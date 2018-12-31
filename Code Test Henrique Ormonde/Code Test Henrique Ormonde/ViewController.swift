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
    @IBOutlet weak var lbl_NoContacts: UILabel!
    
    var peopleList: [Person]!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        Get People List
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            peopleList.removeAll()
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    peopleList?.append(result as! Person)
                }
                peopleTableView.reloadData()
                peopleTableView.isHidden = false
                lbl_NoContacts.isHidden = true
            }
            if results.count == 0 {
                lbl_NoContacts.isHidden = false
                peopleTableView.isHidden = true
            }
        } catch {
            print("Error loading people list")
        }
    }

    
    //    MARK: Button Actions
    
    @IBAction func addPersonTap(_ sender: Any) {
        if(!isChangingView) {
            isChangingView = true
            
            self.performSegue(withIdentifier: "addPersonSegue", sender: nil)
            
            isChangingView = false
        }
    }
    
    @IBAction func optionsTap(_ sender: Any) {
    }
    
    
    //    MARK: Table View Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        
        cell.lbl_Name.text = peopleList[indexPath.row].firstName! + " " + peopleList[indexPath.row].lastName!
        cell.img_Avatar.image = UIImage(data: peopleList[indexPath.row].image ?? (UIImage(named: "default_avatar")?.pngData())!)
        
        return cell
    }
    
    var isChangingView : Bool = false
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!isChangingView) {
            isChangingView = true
            
            let person = peopleList[indexPath.row]
            self.performSegue(withIdentifier: "personSegue", sender: person)
            
            isChangingView = false
        }
    }
    
    //   MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
//        loaderActivity.isHidden = true
        if segue.identifier == "personSegue"
        {
            if let destinationVC = segue.destination as? PersonDetailsViewController {
                destinationVC.person = sender as? Person
            }
        }
        
        if segue.identifier == "addPersonSegue"
        {
            if let destinationVC = segue.destination as? EditPersonViewController {
                destinationVC.person = nil
            }
        }
    }
}

