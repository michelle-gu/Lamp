//
//  MessageListViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/25/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseFirestore

class MessageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var channelDict: [String : NSObject] = [:]
    
    // user match list
    private var channelIds: [String] = []
    
    // MARK: Properties
    var ref: DatabaseReference!
    
    let customTableViewCellIdentifier = "userCell"
    let goToMessagesSegueId = "goToMessagesSegueId"
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference(withPath: "user-profiles")
        
        updateChannelIdList()
    }
    
    // MARK: Helpers
    func updateChannelIdList() {
        
        // get current user
        let user = Auth.auth().currentUser?.uid
        let channels = ref.child(user!).child("channels")

        // goes through user's channel list
        channels.queryOrderedByKey().observe(.value, with: { (snapshot) in
            self.channelDict = snapshot.value as? [String : NSObject] ?? [:]
            // adds all channel ids to global list
            for (key, _) in self.channelDict {
                self.channelIds.append(key)
            }
            self.tableView.reloadData()
        })
    }
    
    
    // MARK: Table View Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier, for: indexPath as IndexPath) as! MessageTableViewCell
        
        ref = Database.database().reference().child("messaging").child("channels")
        
        let channelId = channelIds[indexPath.row]
        
        let currentChannel = ref.child(channelId).child("channel")
        
        currentChannel.observe(.value, with: { (snapshot) in
            let channelDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            // set channel title
            let channelName = channelDict["title"] as! String
            cell.nameLabel.text = channelName
            
            let channelMessage = channelDict["last-message"] as! String
            cell.lastMessageLabel.text = channelMessage
            
            let time = channelDict["time"] as! String
            cell.timeLabel.text = time

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
        self.performSegue(withIdentifier: goToMessagesSegueId, sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == goToMessagesSegueId,
//            let controller = segue.destination as? MessageInstanceViewController {
//
//        }
//    }
    
    // MARK: Styling
    
    private func setUpNavigationBarItems() {
        // back to main card page button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "LogoColor")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}
