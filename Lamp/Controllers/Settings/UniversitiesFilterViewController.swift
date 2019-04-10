//
//  UniversitiesFilterViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 4/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class UniversitiesFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var selectAllSelected: Bool = false
    
    // MARK: Constants
    let profilesRef = Database.database().reference(withPath: "user-profiles")
    let universitiesRef = Database.database().reference(withPath: "universities")
    let universityCellIdentifier = "universityCellIdentifier"
    let numUniversities = 2
    let universitiesArray = ["University of Texas at Austin", "Another School"]
    
    // MARK: TableView stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numUniversities + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: universityCellIdentifier, for: indexPath)
            cell.textLabel?.text = "Select All"
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: universityCellIdentifier, for: indexPath)
            // Set cell label
            cell.textLabel?.text = universitiesArray[indexPath.row - 1]
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
            for row in 1...numUniversities {
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
        
        // Deselecting cell, select all not possible anymore!
        selectAllSelected = false
        let indexPathForSelectAll = IndexPath(row: 0, section: 0)
        let selectAllCell = tableView.cellForRow(at: indexPathForSelectAll)
        selectAllCell!.isSelected = false
        selectAllCell!.accessoryType = .none
        
        
        if indexPath.row == 0 { // Select all
            // Deselect all
            for row in 1...numUniversities {
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
        
        var universitiesSelected: [String] = []
        for row in 1...numUniversities {
            let indexPathForRow = IndexPath(row: row, section: 0)
            let cell = tableView.cellForRow(at: indexPathForRow)
            if (cell?.isSelected)! {
                let uni: String = (cell?.textLabel!.text)!
                universitiesSelected.append(uni)
            }
        }
        
        for uni in universitiesArray {
            let values: [String: Bool]
            if universitiesSelected.contains(uni) {
                values = [
                    uni: true
                ]
            } else {
                values = [
                    uni: false
                ]
            }
            discoverySettingsRef.child("universities").updateChildValues(values)
        }
    }
    
}
