//
//  ViewController.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 19/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit
import CoreData
import Contacts


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, OptionsPopUpViewControllerDelegate {
    
    @IBOutlet weak var peopleTableView: UITableView!
    @IBOutlet weak var but_MoreOptions: UIButton!
    @IBOutlet weak var but_AddPerson: UIButton!
    @IBOutlet weak var txt_Search: UITextField!
    @IBOutlet weak var lbl_NoContacts: UILabel!
    @IBOutlet weak var lbl_NoResults: UILabel!
    
    var peopleList: [Person]!
    var peopleListSearch: [Person]!
    var context: NSManagedObjectContext!
    
    var isSearchMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.context = appDelegate.persistentContainer.viewContext
        
        self.txt_Search.addTarget(self, action: #selector(searchFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        Get People List
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if peopleList == nil {
                peopleList = [Person]()
            } else {
                peopleList.removeAll()
            }
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

    
    //    MARK: - Button Actions
    
    @IBAction func addPersonTap(_ sender: Any) {
        self.view.endEditing(true)
        if(!isChangingView) {
            isChangingView = true
            
            self.performSegue(withIdentifier: "addPersonSegue", sender: nil)
            
            isChangingView = false
        }
    }
    
    @IBAction func optionsTap(_ sender: Any) {
        self.view.endEditing(true)
        if(!isChangingView) {
            isChangingView = true
            
            let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "optionsPopUpID") as! OptionsPopUpViewController
            
            popupVC.delegate = self
            
            self.addChild(popupVC)
            popupVC.view.frame = self.view.frame
            self.view.addSubview(popupVC.view)
            popupVC.didMove(toParent: self)
            
            isChangingView = false
        }
    }
    
    
    //    MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode == false {
            return peopleList?.count ?? 0
        } else {
            return peopleListSearch?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        
        if isSearchMode == false {
            cell.lbl_Name.text = peopleList[indexPath.row].firstName! + " " + peopleList[indexPath.row].lastName!
            cell.img_Avatar.image = UIImage(data: peopleList[indexPath.row].image ?? (UIImage(named: "default_avatar")?.pngData())!)
        } else {
            cell.lbl_Name.text = peopleListSearch[indexPath.row].firstName! + " " + peopleListSearch[indexPath.row].lastName!
            cell.img_Avatar.image = UIImage(data: peopleListSearch[indexPath.row].image ?? (UIImage(named: "default_avatar")?.pngData())!)
        }
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let TrashAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            request.returnsObjectsAsFaults = false
            
            request.predicate = NSPredicate(format: "id == %i", self.peopleList[indexPath.row].id)
            
            do {
                let results = try self.context.fetch(request)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        if (result.value(forKey: "id") as? Int32) != nil {
                            self.context.delete(result)
                            self.peopleList.remove(at: indexPath.row)
//                            self.peopleTableView.reloadData()
                            do {
                                try self.context.save()
                                print("discard person successfull")
                            } catch {
                                print("Error deleting person")
                            }
                        }
                    }
                }
            } catch {
                print("Error loading empty person")
            }
            
            success(true)
        })
        TrashAction.image = UIImage(named: "Trash")
        TrashAction.backgroundColor = .red
        
        // Write action code for the More
        let ShareAction = UIContextualAction(style: .normal, title:  "Share", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            request.returnsObjectsAsFaults = false
            
            request.predicate = NSPredicate(format: "id == %i", self.peopleList[indexPath.row].id)
            
            do {
                let results = try self.context.fetch(request)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        // Creating a mutable object to add to the contact
                        let contact = result.toContact()
                        
                        
//                        Share Contact
                        let fileManager = FileManager.default
                        let cacheDirectory = try! fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        
                        let fileLocation = cacheDirectory.appendingPathComponent("\(CNContactFormatter().string(from: contact!)!).vcf")
                        
                        let contactData = try! CNContactVCardSerialization.data(with: [contact!])
                        do {
                            try contactData.write(to: fileLocation.absoluteURL, options: .atomicWrite)
                        } catch {
                            print("Error saving contact to share")
                        }
                        
                        let activityVC = UIActivityViewController(activityItems: [fileLocation], applicationActivities: nil)
                        activityVC.popoverPresentationController?.sourceView = self.view
                        self.present(activityVC, animated: true, completion: nil)

                        
//                        // Saving the newly created contact
//                        let store = CNContactStore()
//                        let saveRequest = CNSaveRequest()
//                        saveRequest.add(contact, toContainerWithIdentifier:nil)
//                        try! store.execute(saveRequest)
//                        
//                        if (result.value(forKey: "id") as? String) != nil {
//                            self.context.delete(result)
//                            self.peopleList.remove(at: indexPath.row)
//                            //                            self.peopleTableView.reloadData()
//                            print("discard person successfull")
//                        }
                    }
                }
            } catch {
                print("Error loading empty person")
            }
            
            success(true)
        })
        ShareAction.image = UIImage(named: "Share")
        ShareAction.backgroundColor = .gray
        
        
        return UISwipeActionsConfiguration(actions: [TrashAction,ShareAction])
    }
    
    
    //   MARK: - Options Popup Delegates
    
    @objc func backupImportedSuccessfully() {
        self.viewDidAppear(false)
    }
    
    
    //   MARK: - Search Functions
    
    @objc func searchFieldDidChange(_ textField: UITextField) {
        if txt_Search.text == "" {
            isSearchMode = false
            lbl_NoResults.isHidden = true
            if peopleList.count > 0 {
                lbl_NoContacts.isHidden = true
            } else {
                lbl_NoContacts.isHidden = false
                peopleTableView.isHidden = true
            }
            self.view.updateConstraintsIfNeeded()
        } else {
            isSearchMode = true
            lbl_NoContacts.isHidden = true
            peopleTableView.isHidden = false
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "(firstName CONTAINS[c] %@) OR (lastName CONTAINS[c] %@) OR (phoneNumbers CONTAINS[c] %@) OR (emails CONTAINS[c] %@) OR (addresses CONTAINS[c] %@)", self.txt_Search.text!, self.txt_Search.text!, self.txt_Search.text!, self.txt_Search.text!, self.txt_Search.text!)
            
            do {
                let results = try context.fetch(request)
                if peopleListSearch == nil {
                    peopleListSearch = [Person]()
                } else {
                    peopleListSearch.removeAll()
                }
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        peopleListSearch?.append(result as! Person)
                    }
                    lbl_NoResults.isHidden = true
                } else {
                    lbl_NoResults.isHidden = false
                }
            } catch {
                print("Error loading people list")
            }
        }
        peopleTableView.reloadData()
    }
    
    @IBAction func background_Tap(_ sender: Any) {
        self.view.endEditing(true)
//        peopleTableView.reloadData()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.view {
            return true
        }
        return false
    }
    
    // MARK: - Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        peopleTableView.reloadData()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.contains(";"))! {
            let alert = UIAlertController(title: "Invalid input", message: "Invalid character: ;", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: {
                textField.becomeFirstResponder()
            })
            return
        }
        
        self.view.endEditing(true)
        if txt_Search.text == "" {
            isSearchMode = false
        }
        peopleTableView.reloadData()
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

