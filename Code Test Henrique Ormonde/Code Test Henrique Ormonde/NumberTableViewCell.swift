//
//  NumberTableViewCell.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 28/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit

class NumberTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Number: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
