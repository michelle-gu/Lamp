//
//  CardView.swift
//  Lamp
//
//  Created by Maria Ocanas on 4/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

// Protocol for User Profile VC Delegate
protocol UserProfileVCDelegate: AnyObject {
    // Send the UID over
    func didPressInfoButton(uid: String)
}
class CardView: UIView, XibCreatable {

    // MARK: - Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    //    @IBOutlet weak var subLabel: UILabel!
    
    // MARK: - Variables
    var uid: String = String()
    weak var delegate: UserProfileVCDelegate?
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        self.delegate?.didPressInfoButton(uid: uid)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 8
        
        infoButton.layer.cornerRadius = 0.5 * infoButton.bounds.size.width
        
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
    }
 

}
