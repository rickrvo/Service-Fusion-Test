//
//  AddPopUpViewController.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 30/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit
import CoreData

class AddPopUpViewController: UIViewController {

    var person: Person!
    var option: String!
    
    @IBOutlet weak var view_backGround: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_value: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if option == "address" {
            lbl_title.text = "Type in the new address"
        } else if option == "number" {
            lbl_title.text = "Type in the new phone number"
        }else if option == "email" {
            lbl_title.text = "Type in the new email"
        }
        
        self.showAnimate()
    }
    
    
    @IBAction func cancel_Tap(_ sender: Any) {
        self.removeAnimate()
    }
    
    @IBAction func add_Tap(_ sender: Any) {
        
        if txt_value.text == "" || txt_value.text == nil {
            let alert = UIAlertController(title: "Not added", message: "You cannot add an empty field.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "id = %@", String(person!.id))
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if option == "address" {
                        if (result.value(forKey: "addresses") as? String) != nil {
                            do {
                                if person?.addresses == nil || person?.addresses == "" {
                                    result.setValue(txt_value.text, forKey: "addresses")
                                }
                                else {
                                    let adrstr = (person?.addresses)! + ";" + (txt_value?.text!)!
                                    result.setValue(adrstr, forKey: "addresses")
                                }
                                try context.save()
                                
                            } catch {
                                print("error adding address")
                            }
                            print("add value successfull")
                        }
                    } else if option == "number" {
                        if (result.value(forKey: "phoneNumbers") as? String) != nil {
                            do {
                                if person?.phoneNumbers == nil || person?.phoneNumbers == "" {
                                    result.setValue(txt_value.text, forKey: "phoneNumbers")
                                }
                                else {
                                    let adrstr = (person?.phoneNumbers)! + ";" + (txt_value?.text!)!
                                    result.setValue(adrstr, forKey: "phoneNumbers")
                                }
                                try context.save()
                                
                            } catch {
                                print("error adding phoneNumbers")
                            }
                            print("add value successfull")
                        }
                    } else if option == "email" {
                        if (result.value(forKey: "emails") as? String) != nil {
                            do {
                                if person?.emails == nil || person?.emails == "" {
                                    result.setValue(txt_value.text, forKey: "emails")
                                }
                                else {
                                    let adrstr = (person?.emails)! + ";" + (txt_value?.text!)!
                                    result.setValue(adrstr, forKey: "emails")
                                }
                                try context.save()
                                
                            } catch {
                                print("error adding emails")
                            }
                            print("add value successfull")
                        }
                    }
                }
            }
        } catch {
            print("Error loading empty person")
        }
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func background_Tap(_ sender: Any) {
        self.removeAnimate()
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