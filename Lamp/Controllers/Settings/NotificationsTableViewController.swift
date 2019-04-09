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
    let ref = Database.database().reference(withPath: "user-profiles")
    
    // MARK: Outlets
    @IBOutlet weak var newMessagesSwitch: UISwitch!
    @IBOutlet weak var newMatchesSwitch: UISwitch!
    
    // MARK: Actions
    @IBAction func newMessageToggle(_ sender: Any) {
        print("Toggled new msg switch")
        let notifyForNewMessages = newMessagesSwitch.isOn
        print("Toggle value: ", notifyForNewMessages)
        let user = Auth.auth().currentUser?.uid
        let notificationsSettingsRef = ref.child(user!).child("settings").child("notifications")
        let values = ["newMessages": notifyForNewMessages]
        notificationsSettingsRef.updateChildValues(values)
    }
    
    @IBAction func newMatchesToggle(_ sender: Any) {
        print("Toggled new match switch")
        let notifyForNewMatches = newMatchesSwitch.isOn
        print("Toggle value: ", notifyForNewMatches)
        let user = Auth.auth().currentUser?.uid
        let notificationsSettingsRef = ref.child(user!).child("settings").child("notifications")
        let values = ["newMatches": notifyForNewMatches]
        notificationsSettingsRef.updateChildValues(values)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do not allow cell selection
        tableView.allowsSelection = false
        // Remove empty cells at bottom
        tableView.tableFooterView = UIView()
    }

    // MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

}
