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
    var numUniversities = 1
    var universitiesArray = [" "]
    
    // MARK: Constants
    let profilesRef = Database.database().reference(withPath: "user-profiles")
    let universitiesRef = Database.database().reference(withPath: "universities")
    let universityCellIdentifier = "universityCellIdentifier"
    let user = Auth.auth().currentUser?.uid
    
    // MARK: TableView Delegate
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
        } else {
            var allSelected: Bool = true
            for row in 1...numUniversities {
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
            for row in 1...numUniversities {
                let indexPathForRow = IndexPath(row: row, section: 0)
                let otherCell = tableView.cellForRow(at: indexPathForRow)
                otherCell!.isSelected = false
                otherCell!.accessoryType = .none
            }
        }
    }
    
    // MARK: Function
    static func getUniArray(completion: @escaping ([String]) -> Void) {
        let uniRef = Database.database().reference(withPath: "universities")

        uniRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let uniDict = snapshot.value as? [String : AnyObject] else {
                return completion([])
            }
            var uniArray: [String] = []
            for uni in uniDict {
                uniArray.append(uni.key)
            }
            completion(uniArray)
        })
    }

    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        UniversitiesFilterViewController.getUniArray() { (uniArray) in
            self.universitiesArray = uniArray
            self.numUniversities = uniArray.count
            self.tableView.reloadData()
            
            // Retrieve initially selected unis from Firebase
            let discoverySettingsRef = self.profilesRef.child(self.user!).child("settings").child("discovery")
            discoverySettingsRef.observe(.value, with: { (snapshot) in
                // Read snapshot
                let discoverySettingsDict = snapshot.value as? [String : AnyObject] ?? [:]
                
                // Build initially selected universities array
                let uniData = discoverySettingsDict["universities"] as? [String: AnyObject] ?? [:]
                var initiallySelectedUnis: [String] = []
                for uni in uniData {
                    if uni.value.boolValue { // true
                        initiallySelectedUnis.append(uni.key)
                    }
                }
                
                // Check initially selected cells
                var allInitiallySelected: Bool = true
                // Loop through all cells
                for i in 1...self.numUniversities {
                    let indexPathForRow = IndexPath(row: i, section: 0)
                    let cell = self.tableView.cellForRow(at: indexPathForRow)
                    if initiallySelectedUnis.contains((cell?.textLabel?.text)!) {
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
    }
    
    // Update Firebase discovery settings universities
    override func viewWillDisappear(_ animated: Bool) {
        let discoverySettingsRef = profilesRef.child(user!).child("settings").child("discovery")
        
        // Update selected universities array
        var universitiesSelected: [String] = []
        for row in 1...numUniversities {
            let indexPathForRow = IndexPath(row: row, section: 0)
            let cell = tableView.cellForRow(at: indexPathForRow)
            if cell?.accessoryType == .checkmark {
                let uni: String = (cell?.textLabel!.text)!
                universitiesSelected.append(uni)
            }
        }
        
        // Update discovery settings data
        for uni in universitiesArray {
            if universitiesSelected.contains(uni) {
                discoverySettingsRef.child("universities").child(uni).setValue(true)
            } else {
                discoverySettingsRef.child("universities").child(uni).setValue(false)
            }
        }
    }
    
}
