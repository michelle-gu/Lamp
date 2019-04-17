//
//  NotificationsTableViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 4/6/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class NotificationsTableViewController: UITableViewController {
    
    // MARK: Constants
    let user = Auth.auth().currentUser?.uid
    let userProfilesRef = Database.database().reference(withPath: "user-profiles")
    
    // MARK: Outlets
    @IBOutlet weak var newMessagesSwitch: UISwitch!
    @IBOutlet weak var newMatchesSwitch: UISwitch!
    
    // MARK: Actions
    @IBAction func newMessageToggle(_ sender: Any) {
        let notifyForNewMessages = newMessagesSwitch.isOn
        let values = ["newMessages": notifyForNewMessages]
        let notificationsSettingsRef = userProfilesRef.child(user!).child("settings").child("notifications")
        notificationsSettingsRef.updateChildValues(values)
    }
    
    @IBAction func newMatchesToggle(_ sender: Any) {
        let notifyForNewMatches = newMatchesSwitch.isOn
        let values = ["newMatches": notifyForNewMatches]
        let notificationsSettingsRef = userProfilesRef.child(user!).child("settings").child("notifications")
        notificationsSettingsRef.updateChildValues(values)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do not allow cell selection
        tableView.allowsSelection = false
        // Remove empty cells at bottom
        tableView.tableFooterView = UIView()
        
        // Retrieve notifications settings values from Firebase
        let notificationsSettingsRef = userProfilesRef.child(user!).child("settings").child("notifications")
        notificationsSettingsRef.observe(.value, with: { (snapshot) in
            // Read snapshot
            let notificationsSettingsDict = snapshot.value as? [String : AnyObject] ?? [:]
            // If value exists, pre-populate newMessages switch
            if let newMessagesVal = notificationsSettingsDict["newMessages"] as? Bool {
                self.newMessagesSwitch?.isOn = newMessagesVal
            }
            // If value exists, pre-populate newMatches switch
            if let newMatchesVal = notificationsSettingsDict["newMatches"] as? Bool {
                self.newMatchesSwitch?.isOn = newMatchesVal
            }
        })
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

}
