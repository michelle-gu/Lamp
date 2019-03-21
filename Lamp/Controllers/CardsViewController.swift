//
//  CardsViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // card view styles
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.darkGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowRadius = 8

        // make sure picture adjusts to image view
        profilePic.clipsToBounds = true
        
        // yes & no button styles
        yesButton.layer.shadowColor = UIColor.darkGray.cgColor
        yesButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        yesButton.layer.shadowOpacity = 0.2
        yesButton.layer.shadowRadius = 2
        
        noButton.layer.shadowColor = UIColor.darkGray.cgColor
        noButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        noButton.layer.shadowOpacity = 0.2
        noButton.layer.shadowRadius = 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
