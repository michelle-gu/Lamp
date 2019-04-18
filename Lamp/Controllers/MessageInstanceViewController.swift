//
//  MessageInstanceViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/25/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar

class MessageInstanceViewController: MessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        setUpNavigationBarItems()
    }
    
    private func setUpNavigationBarItems() {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        let image = UIImage(named: "girl-5")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }

}
