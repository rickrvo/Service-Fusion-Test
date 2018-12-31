//
//  TitleDetailTableViewCell.swift
//  Code Test Henrique Ormonde
//
//  Created by Rick on 21/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit

class TitleDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Info: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 80))
        
    }

}
