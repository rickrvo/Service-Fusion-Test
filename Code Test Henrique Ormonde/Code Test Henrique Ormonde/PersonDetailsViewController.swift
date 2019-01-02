//
//  PersonDetailsViewController.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 20/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditPersonViewControllerDelegate {
    
    var person: Person!
    weak var delegate: EditPersonViewControllerDelegate?
    
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        img_Avatar.image = UIImage(data: person.image ?? (UIImage(named: "default_avatar")?.pngData())!)
    }
    
    @IBAction func back_Tap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //    MARK: Table View Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(integerLiteral: 8)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
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
            cell.lbl_Title.text = "Emails"
            cell.lbl_Info.text = person.emails?.replacingOccurrences(of: ";", with: "\r\n")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleDetailCell", for: indexPath) as! TitleDetailTableViewCell
            cell.lbl_Title.text = "Addresses"
            cell.lbl_Info.text = person.addresses?.replacingOccurrences(of: ";", with: "\r\n")
            return cell
        
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleDetailCell", for: indexPath) as! TitleDetailTableViewCell
            cell.lbl_Title.text = "Birthday"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            // US English Locale (en_US)
            dateFormatter.locale = Locale(identifier: "en_US")
            let components = Calendar.current.dateComponents([.year], from: person.birthDate ?? Date(), to: Date())
            
            cell.lbl_Info.text = dateFormatter.string(from: person.birthDate ?? Date()) + "   -   " + "\(String(components.year!)) years old"
            return cell
        default:
            return DetailTableViewCell()
        }
        
    }
    
    // MARK: - Edit Person Delegate
    
    func userUpdated(contact: Person) {
        tableView.reloadData()
        self.person = contact
        img_Avatar.image = UIImage(data: person.image ?? (UIImage(named: "default_avatar")?.pngData())!)
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
