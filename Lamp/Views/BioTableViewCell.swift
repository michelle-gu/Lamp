//
//  BioTableViewCell.swift
//  Lamp
//
//  Created by Michelle Gu on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class BioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bioTitleLabel: UILabel!
    @IBOutlet weak var bioTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
