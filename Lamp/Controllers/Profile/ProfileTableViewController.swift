//
//  ProfileTableViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 4/24/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ProfileTableViewController: UITableViewController {

    // MARK: - Constants
    let user = Auth.auth().currentUser?.uid
    let userProfilesRef = Database.database().reference(withPath: "user-profiles")
    
    // MARK: - Variables
    var cities: [String] = []

    // MARK: - Outlets
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var futureLocsLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var uniLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var numBedroomsLabel: UILabel!
    @IBOutlet weak var petsLabel: UILabel!
    @IBOutlet weak var smokingLabel: UILabel!
    @IBOutlet weak var otherPrefsLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fbLabel: UILabel!
    @IBOutlet weak var otherContactLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    // MARK: - Functions
    // Get age from birthday string
    func getAgeStr(birthday: String) -> String {
        let now = Date()
        let calendar = Calendar.current
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM/dd/yyyy"
        let birthdayDate = myDateFormatter.date(from: birthday)!
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: birthdayDate, to: now)
        let age = ageComponents.year!
        return String(age)
    }
    
    func setProfileInfo(label: UILabel, text: String) {
        if text == "" {
            label.textColor = UIColor.lightGray
            label.text = "Not specified"
        } else {
            label.textColor = UIColor.black
            label.text = text
        }
    }
    
    func setLocationText() {
        var locationText = ""
        getCities() { (citiesArray) in
            self.cities = citiesArray
            locationText = self.cities.joined(separator: ", ")
            
            self.futureLocsLabel.text = locationText
        }
    }
    
    // populate the cities array with cities currently in Firebase
    func getCities(completion: @escaping ([String]) -> Void) {
        let profileLocs = userProfilesRef.child(user!).child("profile").child("futureLoc")
        profileLocs.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let citiesDict = snapshot.value as? [String : AnyObject] else {
                return completion([])
            }
            
            var citiesArray: [String] = []
            for city in citiesDict {
                if ((city.value as? Bool)!) {
                    citiesArray.append(city.key)
                }
            }
            completion(citiesArray)
        })
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove empty cells at bottom
        tableView.tableFooterView = UIView()
        
        // Format edit button
        let editButtonRadius = profilePicView.bounds.height / 20
        editProfileButton.layer.cornerRadius = editButtonRadius
        editProfileButton.clipsToBounds = true
        editProfileButton.layer.backgroundColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 0.7).cgColor
        
        // TODO: Auto-size Biotext label cell
        
        // Populate data
        let profile = userProfilesRef.child(user!).child("profile")
        profile.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            if let profilePicVal = profileDict["profilePicture"] as? String {
                if profilePicVal != "" {
                    let profilePicURL = URL(string: profilePicVal)
                    self.profilePicView.kf.setImage(with: profilePicURL)
                } else {
                    self.profilePicView.image = UIImage(named: "profile-pic-blank")
                }
            }
            if let nameVal = profileDict["firstName"] as? String,
               let birthdayVal = profileDict["birthday"] as? String {
                self.nameAgeLabel.text = "\(nameVal), \(self.getAgeStr(birthday: birthdayVal))"
            }
            if let genderVal = profileDict["gender"] as? String {
                self.genderLabel.text = genderVal
            }
            if let uniVal = profileDict["uni"] as? String {
                self.uniLabel.text = uniVal
            }
            
            self.setLocationText()
            
            if let occupationVal = profileDict["occupation"] as? String {
                self.occupationLabel.text = occupationVal
            }
            if let bioVal = profileDict["bio"] as? String {
                self.setProfileInfo(label: self.bioLabel, text: bioVal)
            }
            if let budgetVal = profileDict["budget"] as? Int {
                switch budgetVal {
                case 500:
                    self.setProfileInfo(label: self.budgetLabel, text: "< $500")
                case 3000:
                    self.setProfileInfo(label: self.budgetLabel, text: "$3000+")
                default:
                    self.setProfileInfo(label: self.budgetLabel, text: "$\(Int(budgetVal))")
                }
            }
            if let numBedroomsVal = profileDict["numBedrooms"] as? Int {
                switch numBedroomsVal {
                case 0:
                    self.setProfileInfo(label: self.numBedroomsLabel, text: "Studio")
                case 5:
                    self.setProfileInfo(label: self.numBedroomsLabel, text: "5+")
                default:
                    self.setProfileInfo(label: self.numBedroomsLabel, text: "\(Int(numBedroomsVal))")
                }
            }
            if let petsVal = profileDict["pets"] as? String {
                self.setProfileInfo(label: self.petsLabel, text: petsVal)
            }
            if let smokingVal = profileDict["smoking"] as? String {
                self.setProfileInfo(label: self.smokingLabel, text: smokingVal)
            }
            if let otherLifestyleVal = profileDict["otherLifestylePrefs"] as? String {
                self.setProfileInfo(label: self.otherPrefsLabel, text: otherLifestyleVal)
            }
            if let phoneVal = profileDict["phone"] as? String {
                self.setProfileInfo(label: self.phoneLabel, text: phoneVal)
            }
            if let emailVal = profileDict["email"] as? String {
                self.setProfileInfo(label: self.emailLabel, text: emailVal)
            }
            if let facebookVal = profileDict["facebook"] as? String {
                self.setProfileInfo(label: self.fbLabel, text: facebookVal)
            }
            if let otherContactVal = profileDict["otherContact"] as? String {
                self.setProfileInfo(label: self.otherContactLabel, text: otherContactVal)
            }
        })
    }

    // MARK: - Table view data source
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
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
