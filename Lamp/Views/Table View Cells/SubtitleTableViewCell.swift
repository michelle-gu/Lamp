//
//  SubtitleTableViewCell.swift
//  Lamp
//
//  Created by Maria Ocanas on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    
    static let identifier = "SubtitleTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
