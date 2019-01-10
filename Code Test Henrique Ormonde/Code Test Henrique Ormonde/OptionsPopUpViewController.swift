//
//  OptionsPopUpViewController.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 05/01/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import UIKit
import CoreData
import Contacts

protocol OptionsPopUpViewControllerDelegate: class {
    func backupImportedSuccessfully()
}

class OptionsPopUpViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var viewBackgroundTransparent: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var but_Export: UIButton!
    @IBOutlet weak var but_Import: UIButton!
    
    var context: NSManagedObjectContext!
    weak var delegate: OptionsPopUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.context = appDelegate.persistentContainer.viewContext
        
        self.showAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.height * 2)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(translationX: 0.0, y: -self.view.frame.height)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.height)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func outside_Tap(_ sender: Any) {
        self.removeAnimate()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == viewBackgroundTransparent {
            return true
        }
        return false
    }
    
    @IBAction func but_Export_Tap(_ sender: Any) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
//                var jsonStr:String = ""
                var peopleList: [CNContact] = []
                for result in results as! [NSManagedObject] {
//                    let peep:Person = (result as! Person)
//                    let json = peep.toJSON()
//                    jsonStr.append(json!)
                    peopleList.append(result.toContact()!)
                }
                
                
                let fileName = "Contacts.vcf"
                let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                let data: NSData?
                try data = CNContactVCardSerialization.data(with: peopleList) as NSData
                
//                try jsonStr.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                try data?.write(to: path!, options: .atomic)
                
                let vc = UIActivityViewController(activityItems: [path as Any], applicationActivities: [])
                vc.excludedActivityTypes = [
                    UIActivity.ActivityType.assignToContact,
                    UIActivity.ActivityType.saveToCameraRoll,
                    UIActivity.ActivityType.postToFlickr,
                    UIActivity.ActivityType.postToVimeo,
                    UIActivity.ActivityType.postToTencentWeibo,
                    UIActivity.ActivityType.postToTwitter,
                    UIActivity.ActivityType.postToFacebook,
                    UIActivity.ActivityType.openInIBooks
                ]
                present(vc, animated: true, completion: nil)
            }
        } catch {
            print("Error loading people list and creating JSON")
        }
    }
    
    @IBAction func but_Import_Tap(_ sender: Any) {
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
