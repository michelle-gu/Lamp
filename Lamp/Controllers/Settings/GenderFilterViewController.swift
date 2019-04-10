//
//  GenderFilterViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 4/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class GenderFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var selectAllSelected: Bool = false
    
    // MARK: Constants
    let profilesRef = Database.database().reference(withPath: "user-profiles")
    let gendersRef = Database.database().reference(withPath: "genders")
    let genderCellIdentifier = "genderCellIdentifier"
    let numGenders = 4
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numGenders + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: genderCellIdentifier, for: indexPath)
            cell.textLabel?.text = "Select All"
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: genderCellIdentifier, for: indexPath)
            // Set data
            gendersRef.observe(.value, with: { (snapshot) in
                let genderDict = snapshot.value as? [String : AnyObject] ?? [:]
                let genderKeyArray = Array(genderDict.keys).sorted()
                var genderArray: [String] = []
                for gender in genderKeyArray {
                    //let genderStr = genderDict[gender]!["title"]
                    genderArray.append("")
                }
                cell.textLabel?.text = genderArray[indexPath.row - 1]
            })
        }
//        cell.selectionStyl÷e = .whi
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check the selected row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        if indexPath.row == 0 {
            selectAllSelected = true
            // Select all
            for row in 1...numGenders {
                let indexPathForRow = IndexPath(row: row, section: 0)
                let otherCell = tableView.cellForRow(at: indexPathForRow)
                otherCell!.isSelected = true
                otherCell!.accessoryType = .checkmark
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Unheck the selected row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        if indexPath.row == 0 { // Select all
            selectAllSelected = false
            // Deselect all
            for row in 1...numGenders {
                let indexPathForRow = IndexPath(row: row, section: 0)
                let otherCell = tableView.cellForRow(at: indexPathForRow)
                otherCell!.isSelected = false
                otherCell!.accessoryType = .none
            }
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Update Firebase with genders
        let user = Auth.auth().currentUser?.uid
        let discoverySettingsRef = profilesRef.child(user!).child("settings").child("discovery")

        var gendersSelected: [String] = []
        for row in 1...numGenders {
            let indexPathForRow = IndexPath(row: row, section: 0)
            let cell = tableView.cellForRow(at: indexPathForRow)
            if (cell?.isSelected)! {
                let gender: String = (cell?.textLabel!.text)!
                gendersSelected.append(gender)
            }
        }
        print ("Selected genders: ", gendersSelected)
        let values = ["genders": gendersSelected]
        discoverySettingsRef.updateChildValues(values)
    }
    
}
