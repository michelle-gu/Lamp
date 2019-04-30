//
//  MatchMessageViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/22/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MatchMessageViewController: UIViewController {

    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var keepSwipingButton: UIButton!
    
    @IBOutlet weak var yourProfilePicView: UIImageView!
    @IBOutlet weak var matchProfilePicView: UIImageView!
    
    let user = Auth.auth().currentUser?.uid
    var match = ""
    
    // MARK: Properties
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "user-profiles")
        
        // set appropriate Profile pictures to Match Message Card
        setUserProfilePic()
        setMatchProfilePic()
        
        let newChannelId = UUID().uuidString
        
        // Add channel to user-profiles
        let userRef = ref.child(user!).child("channels")
        let chan = [newChannelId : true]
        userRef.updateChildValues(chan)
        
        let matchRef = ref.child(match).child("channels")
        let chan2 = [newChannelId : true]
        matchRef.updateChildValues(chan2)
        
        
        // ADDING TO MESSAGING
        let messagingRef = Database.database().reference(withPath: "messaging")
        
        // Add channel to CHANNELS
        let channelsRef = messagingRef.child("channels")
        let channel = channelsRef.child(newChannelId).child("channel")
        channel.setValue([
            "last-message": "New Match!",
            "time": "",
            "timestamp": "0"
        ])
        
        // Add users to MEMBERS
        let membersRef = messagingRef.child("members")
        let member = membersRef.child(newChannelId)
        member.setValue([
            user : true,
            match : true
        ])

        styleViewController()
    }

    // MARK: Helpers
    
    func setUserProfilePic() {
        let userRef = ref.child(user!)
        let profile = userRef.child("profile")
        
        profile.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            // set channel profile pic
            if let profilePicVal = profileDict["profilePicture"] as? String {
                if profilePicVal != "" {
                    let profilePicURL = URL(string: profilePicVal)
                    self.yourProfilePicView.kf.setImage(with: profilePicURL)
                }
            }
        })
    }

    func setMatchProfilePic() {
        let matchRef = ref.child(match)
        let profile = matchRef.child("profile")
        
        profile.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            // set channel profile pic
            if let profilePicVal = profileDict["profilePicture"] as? String {
                if profilePicVal != "" {
                    let profilePicURL = URL(string: profilePicVal)
                    self.matchProfilePicView.kf.setImage(with: profilePicURL)
                }
            }
        })
    }
    
    // MARK: Actions
    
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
