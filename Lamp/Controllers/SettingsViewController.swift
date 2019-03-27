//
//  SettingsViewController.swift
//  Lamp
//
//  Created by Maria Ocanas on 3/26/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

public let settings = ["Account", "Notifications", "Discovery"]

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var segueIdentifier = ""
    let settingsCellIdentifier = "settingsCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = settings[row]
        
        cell.textLabel?.font = UIFont(name: "Avenir", size: 25)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
