//
//  BasicProfileTableViewCell.swift
//  Lamp
//
//  Created by Michelle Gu on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class BasicProfileTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
