//
//  CardView.swift
//  Lamp
//
//  Created by Maria Ocanas on 4/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class CardView: UIView, XibCreatable {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    //    @IBOutlet weak var subLabel: UILabel!
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 8
        
        infoButton.layer.shadowColor = UIColor.darkGray.cgColor
        infoButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        infoButton.layer.shadowOpacity = 0.2
        infoButton.layer.shadowRadius = 2
        infoButton.layer.cornerRadius = 0.5 * infoButton.bounds.size.width
    }
 

}
