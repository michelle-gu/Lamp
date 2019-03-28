//
//  BudgetTableViewCell.swift
//  Lamp
//
//  Created by Michelle Gu on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var budgetTitleLabel: UILabel!
    @IBOutlet weak var budgetTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
