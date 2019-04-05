//
//  AccountViewController.swift
//  Lamp
//
//  Created by Maria Ocanas on 3/26/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Constants
    let accountSettings = ["Change Password", "Connect with Facebook", "Connect with Google+", "Delete Account"]
    let accountCellIdentifier = "AccountCellIdentifier"
    let changePasswordSegueIdentifier = "changePasswordSegueIdentifier"
    let unwindToLoginSegueIdentifier = "unwindToLoginSegueIdentifier"

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
        }
        
        switch indexPath.row {
        case 0: // Change password
            let segueIdentifier = "changePasswordSegueIdentifier"
            performSegue(withIdentifier: segueIdentifier, sender: self)
        case 1:
            break
        case 2:
            break
        case 3: // Delete account
            // Prompt the user to re-provide their sign-in credentials
            let alert = UIAlertController(
                title: "Delete Account?",
                message: "Are you sure? This will permanently delete your account. If so, please enter your password.",
                preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Password"
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak alert] (_) in
                let password = alert!.textFields![0] // Force unwrapping because we know it exists.
                let user = Auth.auth().currentUser
                let credential: AuthCredential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: password.text!)
                user?.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
                    if let error = error {
                        // An error happened.
                        let alert = UIAlertController(
                            title: "Password Incorrect",
                            message: error.localizedDescription,
                            preferredStyle: .alert)
    
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("User re-authenticated. Attempting to delete account and return to login.")
                        user?.delete { error in
                            if let error = error {
                                // An error happened.
                                print("Account deletion failed.")
                                let alert = UIAlertController(
                                    title: "Account Deletion Failed",
                                    message: error.localizedDescription,
                                    preferredStyle: .alert)

                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(alert, animated: true, completion: nil)
                                return
                            } else {
                                print("Account deleted.")
                                self.performSegue(withIdentifier: "unwindToLoginSegueIdentifier", sender: self)
                            }
                        }
                    }
                })
            }))
            self.present(alert, animated: true, completion: nil)
        default:
            print("Shouldn't get here!")
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
