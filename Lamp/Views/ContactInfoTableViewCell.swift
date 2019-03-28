//
//  ContactInfoTableViewCell.swift
//  Lamp
//
//  Created by Michelle Gu on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class ContactInfoTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var contactInfoTitle: UILabel!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var facebookTitle: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var otherTitle: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
