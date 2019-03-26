//
//  MessageInstanceViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/25/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class MessageInstanceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBarItems()
    }
    
    private func setUpNavigationBarItems() {
        
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let image = UIImage(named: "girl-5")
        imageView.image = image
        
        navigationItem.titleView = imageView
        
        
    }

}
