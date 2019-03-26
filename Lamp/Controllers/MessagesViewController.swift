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
    @IBOutlet weak var profileM1PicView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUpNavigationBarItems()

        // profile picture styling
        let profileBorderRadius = profile1PicView.bounds.height / 2
        profile1PicView.layer.cornerRadius = profileBorderRadius
        profile2PicView.layer.cornerRadius = profileBorderRadius
        profile1PicView.clipsToBounds = true
        profile2PicView.clipsToBounds = true
        
        // message profile picture styling
        let messageProfileBorderRadius = profileM1PicView.bounds.height / 2
        profileM1PicView.layer.cornerRadius = messageProfileBorderRadius
        profileM1PicView.clipsToBounds = true
    }
    
    private func setUpNavigationBarItems() {
        // back to main card page button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "LogoColor")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
    }
    

}
