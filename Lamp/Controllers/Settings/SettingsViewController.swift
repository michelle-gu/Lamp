//
//  SettingsViewController.swift
//  Lamp
//
//  Created by Maria Ocanas on 3/26/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

public let settings = ["Account", "Notifications", "Discovery"]

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Constants
    let unwindToLoginSegueIdentifier = "unwindToLoginSegueIdentifier"
    let settingsCellIdentifier = "settingsCellIdentifier"

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("Logged out")
            self.performSegue(withIdentifier: "unwindToLoginSegueIdentifier", sender: self)

        } catch (let error) {
            print("Logged out error")
            // FIXME: Test if this works
            let alert = UIAlertController(
                title: "Log Out Failed",
                message: error.localizedDescription,
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Properties
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = settings[row]
        
        cell.textLabel?.font = UIFont(name: "Avenir", size: 17)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var segueIdentifier = ""
        if settings[indexPath.row] == "Account"{
            segueIdentifier = "accountSegueIdentifier"
        }
        else if settings[indexPath.row] == "Notifications"{
            segueIdentifier = "notificationsSegueIdentifier"
        }
        else if settings[indexPath.row] == "Discovery"{
            segueIdentifier = "discoverySegueIdentifier"
        }
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
}
