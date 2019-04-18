//
//  ProfileViewController.swift
//  Lamp
//
//  Created by Pearl Xie on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Constants
    let bioTableViewCellIdentifier = "bioCellIdentifier"
    let budgetTableViewCellIdentifier = "budgetCellIdentifier"
    let lifestylePrefsTableViewCellIdentifier = "lifestylePrefsCellIdentifier"
    let contactInfoTableViewCellIdentifier = "contactInfoCellIdentifier"
    
    // MARK: Firebase Properties
    let profilesRef = Database.database().reference(withPath: "user-profiles")
    let user = Auth.auth().currentUser?.uid
    
    // MARK: Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var futureLocationLabel: UILabel!
    @IBOutlet weak var uniLabel: UILabel!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: Properties
    var ref: DatabaseReference!
    var cities:[String] = []

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // TODO: Make cell rows unselectable
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = Auth.auth().currentUser?.uid
        let profile = ref.child(user!).child("profile")
                
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: bioTableViewCellIdentifier, for: indexPath) as! BioTableViewCell
            // Set data
            profile.observe(.value, with: { (snapshot) in
                let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
                cell.bioTextLabel?.text = profileDict["bio"] as? String
            })
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: budgetTableViewCellIdentifier, for: indexPath) as! BudgetTableViewCell
            // Set data
            profile.observe(.value, with: { (snapshot) in
                let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
                cell.budgetTextLabel?.text = profileDict["budget"] as? String
            })
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: lifestylePrefsTableViewCellIdentifier, for: indexPath) as! LifestylePreferencesTableViewCell
            // Set data
            profile.observe(.value, with: { (snapshot) in
                let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
                cell.numBedroomsLabel?.text = profileDict["numBedrooms"] as? String
                cell.petsLabel?.text = profileDict["pets"] as? String
                cell.smokingLabel?.text = profileDict["smoking"] as? String
                cell.otherLabel?.text = profileDict["otherLifestylePrefs"] as? String
            })
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: contactInfoTableViewCellIdentifier, for: indexPath) as! ContactInfoTableViewCell
            // Set data
            profile.observe(.value, with: { (snapshot) in
                let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
                cell.phoneLabel?.text = profileDict["phone"] as? String
                cell.emailLabel?.text = profileDict["email"] as? String
                cell.facebookLabel?.text = profileDict["facebook"] as? String
                cell.otherLabel?.text = profileDict["otherContact"] as? String
            })
            return cell
        }
    }

    
    // MARK: Actions
    @IBAction func editButtonDidTouch(_ sender: Any) {
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.rowHeight = 155
        profileTableView.reloadData()
        
        // TODO: Fix row height to automatically size/hardcode each row
        
        ref = Database.database().reference(withPath: "user-profiles")
        let user = Auth.auth().currentUser?.uid
        let profile = ref.child(user!).child("profile")
        profile.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.occupationLabel.text = profileDict["occupation"] as? String
            
            /*var locArr: [String] = []
            for city in profileDict["futureLoc"] as! [String: Bool] {
                locArr.append(city.key)
            }
            let futureLocStr = locArr.joined(separator: ", ")
            
            self.futureLocationLabel.text = futureLocStr*/
            self.uniLabel.text = profileDict["uni"] as? String
            if let nameAge = profileDict["firstName"] as? String,
                let birthday = profileDict["birthday"] as? String {
                self.nameAgeLabel.text = "\(nameAge), \(self.getAgeStr(birthday: birthday))"
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLocationText()
    }
    
    // MARK: - Database Retrieval
    // update the location text to show user's preferences
    func setLocationText() {
        var locationText = ""
        getCities() { (citiesArray) in
            self.cities = citiesArray
            locationText = self.cities.joined(separator: ", ")
            
            self.futureLocationLabel.text = locationText
        }
    }
    
    // populate the cities array with cities currently in Firebase
    func getCities(completion: @escaping ([String]) -> Void) {
        let profileLocs = profilesRef.child(user!).child("profile").child("futureLoc")
        profileLocs.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let citiesDict = snapshot.value as? [String : AnyObject] else {
                return completion([])
            }
            
            var citiesArray: [String] = []
            for city in citiesDict {
                citiesArray.append(city.key)
            }
            completion(citiesArray)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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
    
}
