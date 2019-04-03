//
//  AccountViewController.swift
//  Lamp
//
//  Created by Maria Ocanas on 3/26/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Constants
    let accountSettings = ["Change Password", "Connect with Facebook", "Connect with Google+", "Delete Account"]
    let accountCellIdentifier = "AccountCellIdentifier"
    let changePasswordSegueIdentifier = "changePasswordSegueIdentifier"

    // MARK: Properties
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: accountCellIdentifier, for: indexPath as IndexPath)
            
            let row = indexPath.row
            cell.textLabel?.text = accountSettings[row]
        if accountSettings[row] == "Change Password"{
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
            cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if accountSettings[indexPath.row] == "Change Password"{
            let segueIdentifier = "changePasswordSegueIdentifier"
            performSegue(withIdentifier: segueIdentifier, sender: self)
        }
        
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
