//
//  DiscoveryTableViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 4/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import RangeUISlider
import Firebase

class DiscoveryTableViewController: UITableViewController, RangeUISliderDelegate {
    
    // MARK: Constants
    let ref = Database.database().reference(withPath: "user-profiles")
    let user = Auth.auth().currentUser?.uid

    // MARK: Outlets
    @IBOutlet weak var maxDistanceSlider: UISlider!
    @IBOutlet weak var ageRangeSlider: RangeUISlider!
    @IBOutlet weak var showMyProfileSwitch: UISwitch!
    @IBOutlet weak var universitiesListLabel: UILabel!
    @IBOutlet weak var futureLocationsListLabel: UILabel!
    @IBOutlet weak var genderListLabel: UILabel!
    @IBOutlet weak var maxDistanceValueLabel: UILabel!
    @IBOutlet weak var minAgeLabel: UILabel!
    @IBOutlet weak var maxAgeLabel: UILabel!
    
    // MARK: Actions
    func rangeIsChanging(minValueSelected: CGFloat, maxValueSelected: CGFloat, slider: RangeUISlider) {
        minAgeLabel.text = "\(Int(minValueSelected))"
        maxAgeLabel.text = "\(Int(maxValueSelected))"
    }
    func rangeChangeFinished(minValueSelected: CGFloat, maxValueSelected: CGFloat, slider: RangeUISlider) {
        let discoverySettingsRef = ref.child(user!).child("settings").child("discovery")
        let values = ["minAge": minValueSelected,
                      "maxAge": maxValueSelected]
        discoverySettingsRef.updateChildValues(values)
    }
    
    @IBAction func maxDistanceSliderChanged(_ sender: Any) {
        print("Moved max dist slider")
        let maxDistance = maxDistanceSlider.value
        print("Slider value: ", maxDistance)
        let discoverySettingsRef = ref.child(user!).child("settings").child("discovery")
        let values = ["maxDistance": maxDistance]
        maxDistanceValueLabel.text = "\(Int(maxDistance))"
        discoverySettingsRef.updateChildValues(values)
    }
    
    @IBAction func showMyProfileToggled(_ sender: Any) {
        print("Toggled new match switch")
        let showMyProfile = showMyProfileSwitch.isOn
        print("Toggle value: ", showMyProfile)
        let discoverySettingsRef = ref.child(user!).child("settings").child("discovery")
        let values = ["showProfile": showMyProfile]
        discoverySettingsRef.updateChildValues(values)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove empty cells at bottom
        tableView.tableFooterView = UIView()
        ageRangeSlider.delegate = self
    }

    // MARK: Table view data source
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Location Filters"
        case 1:
            return "Other Filters"
        case 2:
            return "Visibility"
        default:
            return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell: UITableViewCell
//
//        switch indexPath.section {
//        case 0:
//            switch indexPath.row {
//            case 0:
//                cell = tableView.dequeueReusableCell(withIdentifier: "futureLocationCellIdentifier", for: indexPath)
//            case 1:
//                cell = tableView.dequeueReusableCell(withIdentifier: "maxDistanceCellIdentifier", for: indexPath)
//            default:
//                cell = UITableViewCell()
//            }
//        case 1:
//            switch indexPath.row {
//            case 0:
//                cell = tableView.dequeueReusableCell(withIdentifier: "universitiesCellIdentifier", for: indexPath)
//            case 1:
//                cell = tableView.dequeueReusableCell(withIdentifier: "genderCellIdentifier", for: indexPath)
//            case 2:
//                cell = tableView.dequeueReusableCell(withIdentifier: "ageRangeCellIdentifier", for: indexPath)
//            default:
//                cell = UITableViewCell()
//            }
//        case 2:
//            switch indexPath.row {
//            case 0:
//                cell = tableView.dequeueReusableCell(withIdentifier: "showMyProfileCellIdentifier", for: indexPath)
//            default:
//                cell = UITableViewCell()
//            }
//        default:
//            cell = UITableViewCell()
//        }
//
//        return cell
//    }

}
