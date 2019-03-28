//
//  LifestylePreferencesTableViewCell.swift
//  Lamp
//
//  Created by Michelle Gu on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class LifestylePreferencesTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var lifestylePrefTitle: UILabel!
    @IBOutlet weak var numBedroomsTitle: UILabel!
    @IBOutlet weak var numBedroomsLabel: UILabel!
    @IBOutlet weak var petsTitle: UILabel!
    @IBOutlet weak var petsLabel: UILabel!
    @IBOutlet weak var smokingTitle: UILabel!
    @IBOutlet weak var smokingLabel: UILabel!
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
