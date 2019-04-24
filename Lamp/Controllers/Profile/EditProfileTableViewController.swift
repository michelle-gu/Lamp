//
//  EditProfileTableViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 4/24/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Constants
    let user = Auth.auth().currentUser?.uid
    let userProfilesRef = Database.database().reference(withPath: "user-profiles")
    
    // MARK: - Outlets
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var universityField: UITextField!
    @IBOutlet weak var futureLocationField: UITextField!
    @IBOutlet weak var occupationField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    @IBOutlet weak var budgetField: UITextField!
    @IBOutlet weak var numBedroomsField: UITextField!
    @IBOutlet weak var petsField: UITextField!
    @IBOutlet weak var smokingField: UITextField!
    @IBOutlet weak var otherPreferencesField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var facebookField: UITextField!
    @IBOutlet weak var otherContactField: UITextField!
    
    // MARK: - Actions
    @IBAction func changeProfilePicPressed(_ sender: Any) {
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
    }
    
    
    // MARK: - Functions
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates
        nameField.delegate = self

        // Remove empty cells at bottom
        tableView.tableFooterView = UIView()

        // TODO: Populate data
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 17)
        myLabel.font = UIFont(name: "Avenir-Heavy", size: 17)
        
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1) // Use default
        headerView.addSubview(myLabel)
        
        return headerView
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        case 2:
            return 1
        case 3:
            return 5
        case 4:
            return 4
        default:
            return 0
        }
    }

}
