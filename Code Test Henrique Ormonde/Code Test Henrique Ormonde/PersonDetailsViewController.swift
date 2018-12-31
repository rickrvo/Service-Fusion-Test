//
//  PersonDetailsViewController.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 20/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    var person: Person!
    
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if person.image != nil {
            img_Avatar.image = UIImage(data: person.image ?? (UIImage(named: "default_avatar")?.pngData())!)
        }
    }
    
    @IBAction func back_Tap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //    MARK: Table View Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleDetailCell", for: indexPath) as! TitleDetailTableViewCell
            cell.lbl_Title.text = "First Name"
            cell.lbl_Info.text = person.firstName
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleDetailCell", for: indexPath) as! TitleDetailTableViewCell
            cell.lbl_Title.text = "Last Name"
            cell.lbl_Info.text = person.lastName
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleDetailCell", for: indexPath) as! TitleDetailTableViewCell
            cell.lbl_Title.text = "Phone Numbers"
            cell.lbl_Info.text = person.phoneNumbers?.replacingOccurrences(of: ";", with: "\r\n")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleDetailCell", for: indexPath) as! TitleDetailTableViewCell
            cell.lbl_Title.text = "Addresses"
            cell.lbl_Info.text = person.addresses?.replacingOccurrences(of: ";", with: "\r\n")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleDetailCell", for: indexPath) as! TitleDetailTableViewCell
            cell.lbl_Title.text = "Emails"
            cell.lbl_Info.text = person.emails?.replacingOccurrences(of: ";", with: "\r\n")
            return cell
        default:
            return DetailTableViewCell()
        }
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "personEditSegue"
        {
            if let destinationVC = segue.destination as? EditPersonViewController {
                destinationVC.person = person
            }
        }
    }
}
