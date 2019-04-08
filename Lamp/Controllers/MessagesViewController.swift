//
//  MessagesViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/25/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import CoreData

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // user match list
    var messagedUsers: [Profile] = []
    
    let customTableViewCellIdentifier = "userCell"

    @IBOutlet weak var tableView: UITableView!

    // profiles in new matches
    @IBOutlet weak var profile1PicView: UIImageView!
    @IBOutlet weak var profile2PicView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        messagedUsers.append(Profile(firstName: "Lindsey", birthday: "", gender: "", uni: "", futureLoc: "", occupation: ""))
        
        //setUpNavigationBarItems()
        // profile picture styling
        
        styleElements()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier, for: indexPath as IndexPath) as! MessagesTableViewCell
        
        let user = messagedUsers[indexPath.row]
        
        cell.nameLabel.text = user.firstName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    
    private func styleElements() {
        let profileBorderRadius = profile1PicView.bounds.height / 2
        profile1PicView.layer.cornerRadius = profileBorderRadius
        profile2PicView.layer.cornerRadius = profileBorderRadius
        profile1PicView.clipsToBounds = true
        profile2PicView.clipsToBounds = true
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
