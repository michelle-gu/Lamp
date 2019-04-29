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
import Kingfisher

class MessageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageSentDelegate {
    
    var channelDict: [String : NSObject] = [:]
    var membersDict: [String : NSObject] = [:]

    // user match list
    private var channelIds: [String] = []
    private var memberIds: [String] = []

    // MARK: Properties
    var ref: DatabaseReference!
    
    let customTableViewCellIdentifier = "userCell"
    let goToMessagesSegueId = "goToMessagesSegueId"
    
    var channelIndex: NSIndexPath = NSIndexPath()
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference(withPath: "user-profiles")
        
        updateChannelIdList()
    }
    
    // MARK: Message Delegate
    
    // update specific channels message
    func updateChannelInfo(lastMessage: Message, channelId: String) {        
        // convert date to time HH:mm aa
        let time = convertTime(timestamp: lastMessage.sentDate)
        
        // write to database
        ref = Database.database().reference(withPath: "messaging").child("channels")
        let channel = ref.child(channelId).child("channel")
        
        channel.updateChildValues(["last-message" : lastMessage.content])
        channel.updateChildValues(["time" : time])

        // load table again
        
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
    
    func convertTime(timestamp: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        
        return timeFormatter.string(from: timestamp)
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
        
        ref = Database.database().reference().child("messaging")
        
        let channelId = channelIds[indexPath.row]
        
        // set channel detailed attributes (last message, time)
        let currentChannel = ref.child("channels").child(channelId).child("channel")
        currentChannel.observe(.value, with: { (snapshot) in
            let channelDict = snapshot.value as? [String : AnyObject] ?? [:]
            // set channel last message
            let channelMessage = channelDict["last-message"] as! String
            cell.lastMessageLabel.text = channelMessage
            // set channel timestamp
            let time = channelDict["time"] as! String
            cell.timeLabel.text = time
        })
        
        // find match id
        let currentUserId = Auth.auth().currentUser?.uid
        let members = ref.child("members").child(channelId)
        
        // goes through members of channel
        members.queryOrderedByKey().observe(.value, with: { (snapshot) in
            self.membersDict = snapshot.value as? [String : NSObject] ?? [:]
            
            // loop through all members (two) ids to dict
            var matchUserId = "nil"
            for (key, _) in self.membersDict {
                if key != currentUserId {
                    matchUserId = key
                }
            }
            
            // set channel details to match user info (profile pic, title)
            let matchProfileRef = Database.database().reference().child("user-profiles").child(matchUserId).child("profile")
            matchProfileRef.observe(.value, with: { (snapshot) in
                let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
                
                // set channel title
                let matchName = profileDict["firstName"] as! String
                cell.nameLabel.text = matchName
                
                // set channel profile pic
                if let profilePicVal = profileDict["profilePicture"] as? String {
                    if profilePicVal != "" {
                        let profilePicURL = URL(string: profilePicVal)
                        cell.profileImageView.kf.setImage(with: profilePicURL)
                    }
                }
            })
        })
        
        return cell
    }
    
    // table cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    // user clicks on a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.channelIndex = indexPath as NSIndexPath
        self.performSegue(withIdentifier: goToMessagesSegueId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let controller = nav.topViewController as? MessageInstanceViewController {
            controller.messageDelegate = self
            controller.channelId = channelIds[channelIndex.row]
        }
    }
    
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
