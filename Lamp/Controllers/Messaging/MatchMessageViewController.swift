//
//  MatchMessageViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/22/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class MatchMessageViewController: UIViewController {

    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var keepSwipingButton: UIButton!
    
    @IBOutlet weak var yourProfilePicView: UIImageView!
    @IBOutlet weak var matchProfilePicView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleViewController()
    }

    // MARK: Helpers
    
    @IBAction func keepSwipingButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Styling
    
    func styleViewController() {
        // style of profile picture views
        yourProfilePicView.clipsToBounds = true
        matchProfilePicView.clipsToBounds = true
        
        // button styles
        sendMessageButton.layer.cornerRadius = sendMessageButton.bounds.height / 2
        sendMessageButton.layer.borderWidth = 1
        sendMessageButton.layer.borderColor = UIColor(red: 0.44, green: 0.71, blue: 0.99, alpha: 1).cgColor
        
        keepSwipingButton.layer.cornerRadius = keepSwipingButton.bounds.height / 2
        keepSwipingButton.layer.borderWidth = 1
        keepSwipingButton.layer.borderColor = UIColor(red: 0.44, green: 0.71, blue: 0.99, alpha: 1).cgColor
    }
}
