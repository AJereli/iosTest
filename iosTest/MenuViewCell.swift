//
//  MenuViewCell.swift
//  iosTest
//
//  Created by User on 29/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {

    @IBOutlet weak var menuItemLabel: UILabel!
    @IBOutlet weak var menuItemSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}