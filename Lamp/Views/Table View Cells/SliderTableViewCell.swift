//
//  SliderTableViewCell.swift
//  Lamp
//
//  Created by Maria Ocanas on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {
    
    static let identifier = "SliderTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
