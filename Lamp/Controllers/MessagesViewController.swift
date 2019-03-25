//
//  MessagesViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/25/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {

    // profiles in new matches
    @IBOutlet weak var profile1PicView: UIImageView!
    @IBOutlet weak var profile2PicView: UIImageView!
    
    // profiles in messages
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // profile picture styling
        let profileBorderRadius = profile1PicView.bounds.height / 2
        profile1PicView.layer.cornerRadius = profileBorderRadius
        profile2PicView.layer.cornerRadius = profileBorderRadius
        profile1PicView.clipsToBounds = true
        profile2PicView.clipsToBounds = true
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        // back to main card page
//        let logo = UIImage(named: "LogoColor")
//        let lampLogo = UIButton(type: .system)
//        lampLogo.setImage(logo, for: .normal)
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lampLogo)
//        
//    }
    

}
