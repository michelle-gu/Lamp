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
    let user = Auth.auth().currentUser?.uid
    let userProfilesRef = Database.database().reference(withPath: "user-profiles")
    let selectGenderSegueIdentifier = "selectGenderSegueIdentifier"
    let selectUniversitiesSegueIdentifier = "selectUniversitiesSegueIdentifier"
    let selectFutureLocationSegueIdentifier = "selectFutureLocationSegueIdentifier"

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
        let discoverySettingsRef = userProfilesRef.child(user!).child("settings").child("discovery")
        let values = ["ageMin": minValueSelected,
                      "ageMax": maxValueSelected]
        discoverySettingsRef.updateChildValues(values)
    }
    
    @IBAction func maxDistanceSliderChanged(_ sender: Any) {
        let maxDistance = maxDistanceSlider.value
        let discoverySettingsRef = userProfilesRef.child(user!).child("settings").child("discovery")
        let values = ["maxDistance": maxDistance]
        maxDistanceValueLabel.text = "\(Int(maxDistance))"
        discoverySettingsRef.updateChildValues(values)
    }
    
    @IBAction func showMyProfileToggled(_ sender: Any) {
        let showMyProfile = showMyProfileSwitch.isOn
        let discoverySettingsRef = userProfilesRef.child(user!).child("settings").child("discovery")
        let values = ["showProfile": showMyProfile]
        discoverySettingsRef.updateChildValues(values)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove empty cells at bottom
        tableView.tableFooterView = UIView()
        // Set age range slider delegate
        ageRangeSlider.delegate = self
        ageRangeSlider.scaleMinValue = 0
        ageRangeSlider.scaleMaxValue = 50
        
        // Retrieve discovery settings values from Firebase
        let discoverySettingsRef = userProfilesRef.child(user!).child("settings").child("discovery")
        discoverySettingsRef.observe(.value, with: { (snapshot) in
            // Read snapshot
            let discoverySettingsDict = snapshot.value as? [String : AnyObject] ?? [:]
            // If value exists, pre-populate newMessages switch
            if let maxDistanceVal = discoverySettingsDict["maxDistance"] as? Float {
                self.maxDistanceSlider?.value = maxDistanceVal
                self.maxDistanceValueLabel?.text = "\(Int(maxDistanceVal))"
            }
            // If value exists, pre-populate newMatches switch
            if let minAgeVal = discoverySettingsDict["ageMin"] as? CGFloat {
                self.ageRangeSlider?.defaultValueLeftKnob = minAgeVal
                self.minAgeLabel?.text = "\(Int(minAgeVal))"
            }
            // If value exists, pre-populate newMatches switch
            if let maxAgeVal = discoverySettingsDict["ageMax"] as? CGFloat {
                self.ageRangeSlider?.defaultValueRightKnob = maxAgeVal
                self.maxAgeLabel?.text = "\(Int(maxAgeVal))"
            }
            // If value exists, pre-populate newMessages switch
            if let showProfileVal = discoverySettingsDict["showProfile"] as? Bool {
                self.showMyProfileSwitch?.isOn = showProfileVal
            }
        
            // Set subtitles for Future Loc, Uni, Gender
            let futureLocData = discoverySettingsDict["futureLoc"] as? [String: AnyObject] ?? [:]
            var futureLocSubtitleArr: [String] = []
            for futureLoc in futureLocData {
                if futureLoc.value.boolValue { // true
                    futureLocSubtitleArr.append(futureLoc.key)
                }
            }
            let futureLocSubtitleStr: String = futureLocSubtitleArr.joined(separator: ", ")
            self.futureLocationsListLabel.text = futureLocSubtitleStr
            
            
            let universityData = discoverySettingsDict["universities"] as? [String: AnyObject] ?? [:]
            var universitySubtitleArr: [String] = []
            for university in universityData {
                if university.value.boolValue { // true
                    universitySubtitleArr.append(university.key)
                }
            }
            let universitySubtitleStr: String = universitySubtitleArr.joined(separator: ", ")
            self.universitiesListLabel.text = universitySubtitleStr
            
            let genderData = discoverySettingsDict["genders"] as? [String: AnyObject] ?? [:]
            var genderSubtitleArr: [String] = []
            for gender in genderData {
                if gender.value.boolValue { // true
                    genderSubtitleArr.append(gender.key)
                }
            }
            let genderSubtitleStr: String = genderSubtitleArr.joined(separator: ", ")
            self.genderListLabel.text = genderSubtitleStr
        })
    }

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 17)
        myLabel.font = UIFont(name: "Avenir-Heavy", size: 17)
        
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 0.1)
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

}
