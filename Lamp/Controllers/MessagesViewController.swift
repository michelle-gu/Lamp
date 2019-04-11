//
//  MessagesViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/25/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // user match list
    var messagedUsers: [String] = ["5RAnK9zEAORdQLJUMRsezwkjD8A3", "O5tkewRsPUQTNBFdq2WMwQTD7Gi2", "iVFU2mH3npgjxvzIndiOT6BDBJ02", "ubCnU8kdafc82CqU5ndWV4vNb1i1"]
    
    // MARK: Properties
    var ref: DatabaseReference!
    
    let customTableViewCellIdentifier = "userCell"
    let goToMessagesSegueId = "goToMessagesSegueId"
    
    var selectedIndex = 0

    @IBOutlet weak var tableView: UITableView!

    // profiles in new matches
    @IBOutlet weak var profile1PicView: UIImageView!
    @IBOutlet weak var profile2PicView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        ref = Database.database().reference().child("user-profiles")
        let userId = messagedUsers[indexPath.row]
        let messagingUser = ref.child(userId).child("profile")
        
        messagingUser.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            let firstName = profileDict["firstName"] as! String
            cell.nameLabel.text = firstName
        })
        
        // grab timestamp from last message
        
        
        // grab last message text from last message
        
        
        return cell
    }
    
    // table cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    // user clicks on a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: goToMessagesSegueId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToMessagesSegueId,
            let controller = segue.destination as? MessageInstanceViewController {
            
        }
    }
    
    
    // styling
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
