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
    let genderArray = ["Female", "Male", "Other", "Prefer not to say"]
    let user = Auth.auth().currentUser?.uid
    
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
            // Set cell label
            cell.textLabel?.text = genderArray[indexPath.row - 1]
        }
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
        } else {
            var allSelected: Bool = true
            for row in 1...numGenders {
                let indexPathForRow = IndexPath(row: row, section: 0)
                let otherCell = tableView.cellForRow(at: indexPathForRow)
                if otherCell?.accessoryType != UITableViewCell.AccessoryType.checkmark {
                    allSelected = false
                    break
                }
            }

            if allSelected { // Tick selectAll cell
                selectAllSelected = true
                let indexPathForRow = IndexPath(row: 0, section: 0)
                let selectAllCell = tableView.cellForRow(at: indexPathForRow)
                selectAllCell!.isSelected = true
                selectAllCell!.accessoryType = .checkmark
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Unheck the selected row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        
        // Deselecting cell, select all not possible anymore!
        selectAllSelected = false
        let indexPathForSelectAll = IndexPath(row: 0, section: 0)
        let selectAllCell = tableView.cellForRow(at: indexPathForSelectAll)
        selectAllCell!.isSelected = false
        selectAllCell!.accessoryType = .none
        
        if indexPath.row == 0 { // Select all
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
        
        // Retrieve initially selected genders from Firebase
        let discoverySettingsRef = profilesRef.child(user!).child("settings").child("discovery")
        discoverySettingsRef.observe(.value, with: { (snapshot) in
            // Read snapshot
            let discoverySettingsDict = snapshot.value as? [String : AnyObject] ?? [:]

            // Build initially selected genders array
            let genderData = discoverySettingsDict["genders"] as? [String: AnyObject] ?? [:]
            var initiallySelectedGenders: [String] = []
            for gender in genderData {
                if gender.value.boolValue { // true
                    initiallySelectedGenders.append(gender.key)
                }
            }
            
            // Check initially selected cells
            var allInitiallySelected: Bool = true
            // Loop through all cells
            for i in 1...self.numGenders {
                let indexPathForRow = IndexPath(row: i, section: 0)
                let cell = self.tableView.cellForRow(at: indexPathForRow)
                if initiallySelectedGenders.contains((cell?.textLabel?.text)!) {
                    cell!.accessoryType = .checkmark
                } else {
                    cell!.accessoryType = .none
                    allInitiallySelected = false
                }
            }
            // Select All cell
            if allInitiallySelected {
                let indexPathForRow = IndexPath(row: 0, section: 0)
                let cell = self.tableView.cellForRow(at: indexPathForRow)
                cell!.accessoryType = .checkmark
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Update Firebase with genders
        let discoverySettingsRef = profilesRef.child(user!).child("settings").child("discovery")

        var gendersSelected: [String] = []
        for row in 1...numGenders {
            let indexPathForRow = IndexPath(row: row, section: 0)
            let cell = tableView.cellForRow(at: indexPathForRow)
            if cell?.accessoryType == .checkmark {
                let gender: String = (cell?.textLabel!.text)!
                gendersSelected.append(gender)
            }
        }

        for gender in genderArray {
            let values: [String: Bool]
            if gendersSelected.contains(gender) {
                values = [
                    gender: true
                ]
                gendersRef.child(gender).child(user!).setValue(true)
            } else {
                values = [
                    gender: false
                ]
                gendersRef.child(gender).child(user!).setValue(false)
            }
            discoverySettingsRef.child("genders").updateChildValues(values)
        }
    }
    
}
