//
//  ProfileLocationViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase
import Foundation

// current universities
let uniPickerData = [String](arrayLiteral: "University of Texas at Austin", "St Edwards")

class ProfileLocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: - Constants
    let profilesRef = Database.database().reference(withPath: "user-profiles")
    let dbRef = Database.database()
    let citiesRef = Database.database().reference(withPath: "locations")
    let user = Auth.auth().currentUser?.uid
    
    // MARK: Segues
    let openMap = "openMap"
    let showHomePage = "showHomePage"
    
    // MARK: - Variables
    var cities:[String] = []
    
    // MARK: - Outlets
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var uniTextField: UITextField!
    @IBOutlet weak var futureLocTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // TextField Delegates
        futureLocTextField.delegate = self
        uniTextField.delegate = self
        
        // Do any additional setup after loading the view.
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        profilePictureView.clipsToBounds = true
        
        // for university picker
        let uniPicker = UIPickerView()
        uniPicker.delegate = self
        uniTextField.inputView = uniPicker
        
        // Pre-populate with values from Firebase
        let profile = profilesRef.child(user!).child("profile")
        profile.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let uniVal = profileDict["uni"] as? String {
                self.uniTextField?.text = uniVal
            }
            self.getLocationText()
            if let occupationVal = profileDict["occupation"] as? String {
                self.occupationTextField?.text = occupationVal
            }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLocationText()
    }
    
    // MARK: - Database Retrieval
    // update the location text to show user's preferences
    func getLocationText() {
        var locationText = ""
        getCities() { (citiesArray) in
            self.cities = citiesArray
            locationText = self.cities.joined(separator: ", ")
            
            self.futureLocTextField.text = locationText
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
    
    // MARK: - PickerView Delegate
    
    // for uni picker delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // for uni picker delegate
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return uniPickerData.count
    }
    
    // for uni picker delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return uniPickerData[row]
    }
    
    // for uni picker delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        uniTextField.text = uniPickerData[row]
    }
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard
            let uni = uniTextField.text,
            let futureLoc = futureLocTextField.text,
            let occupation = occupationTextField.text,
            uni.count > 0,
            futureLoc.count > 0,
            occupation.count > 0
            //let profilePicture = profilePictureView.image
            else {
                let alert = UIAlertController(
                    title: "Profile Creation Failed",
                    message: "Please fill in all fields.",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        let user = Auth.auth().currentUser?.uid
        
        let profile = profilesRef.child(user!).child("profile")
        let values = [
            "uni": uni,
            "occupation": occupation
        ]
        profile.updateChildValues(values)
        
        let futureLocArr: [String] = futureLoc.components(separatedBy: ", ")
        for loc in futureLocArr {
            print("Pressing done & saving data!")
            // Set future location and default location filter
            let locFilterVal = [
                loc: true // Flowermound, AUstin: true
            ]
            profilesRef.child(user!).child("profile").child("futureLoc").updateChildValues(locFilterVal)
            profilesRef.child(user!).child("settings").child("discovery").child("futureLoc").updateChildValues(locFilterVal)
            
            // Add the user's locations to list of all locations
            let locValues = [
                loc: [
                    user: true
                ]
            ]
            dbRef.reference(withPath: "locations").updateChildValues(locValues)
        }

        
        // Set default uni filter
        let filterValues = [
            "universities": [
                uni: true
            ]
        ]
        profilesRef.child(user!).child("settings").child("discovery").updateChildValues(filterValues)
        
        // Add university
        let uniValues = [
            uni: [
                user: true
            ]
        ]
        dbRef.reference(withPath: "universities").updateChildValues(uniValues)
        

        // Update filter defaults
    }
    
    // MARK: - Text Field delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
