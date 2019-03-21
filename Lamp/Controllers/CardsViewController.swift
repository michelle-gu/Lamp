//
//  CardsViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // make sure picture adjusts to image view
        profilePic.clipsToBounds = true
        
        // yes & no button styles
        yesButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
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
