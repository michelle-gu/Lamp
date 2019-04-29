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

class ProfileLocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: - Constants
    // MARK: Database References
    let user = Auth.auth().currentUser?.uid
    let userProfilesRef = Database.database().reference(withPath: "user-profiles")
    let citiesRef = Database.database().reference(withPath: "locations")
    let uniRef = Database.database().reference(withPath: "universities")
    
    // MARK: Pickers
    let imagePicker = UIImagePickerController()
    let uniPicker = UIPickerView()
    
    // MARK: Segues
    let openMap = "openMap"
    let showHomePage = "showHomePage"
    
    // MARK: - Variables
    var cities:[String] = []
    var allCities: [String] = []
    var unis: [String] = []

    // MARK: - Outlets
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var uniTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // TextField Delegates
        uniTextField.delegate = self
        uniTextField.tag = 0
        occupationTextField.delegate = self
        occupationTextField.tag = 0
        
        // Do any additional setup after loading the view.
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        profilePictureView.clipsToBounds = true
        
        // for university picker
        uniPicker.delegate = self
        uniTextField.inputView = uniPicker
        
        // Dismiss pickers on view tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileLocationViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        self.mapButton.setTitle(" Where are you moving?", for: .normal)
        self.mapButton.setTitleColor(UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1), for: .normal)
        self.mapButton.layer.borderWidth = 0.50
        self.mapButton.layer.cornerRadius = self.mapButton.bounds.height / 5
        self.mapButton.layer.borderColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1).cgColor
        
        // populate the uni and job values from Firebase
        let profile = userProfilesRef.child(user!).child("profile")
        profile.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let uniVal = profileDict["uni"] as? String {
                self.uniTextField?.text = uniVal
            }
            
            if let occupationVal = profileDict["occupation"] as? String {
                self.occupationTextField?.text = occupationVal
            }
            
            if let profilePicVal = profileDict["profilePicture"] as? String {
                if profilePicVal != "" {
                    let profilePicURL = URL(string: profilePicVal)
                    self.profilePictureView.kf.setImage(with: profilePicURL)
                }
            }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Populate the future location value from Firebase
        getLocationText()
        
        // Populate genders, unis, cities, and all cities arrays
        getUniversities() { (unisArray) in
            self.unis = unisArray
        }
        
        getAllCities() { (citiesArray) in
            self.allCities = citiesArray
        }
    }
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard
            let uni = uniTextField.text,
            let futureLoc = mapButton.titleLabel?.text,
            let occupation = occupationTextField.text,
            uni.count > 0,
            futureLoc != " Where are you moving?",
            occupation.count > 0
            else {
                let alert = UIAlertController(
                    title: "Profile Creation Failed",
                    message: "Please fill in all fields.",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        let profile = userProfilesRef.child(user!).child("profile")
        let values = [
            "uni": uni,
            "occupation": occupation
        ]
        profile.updateChildValues(values)
        
        // Update futureLoc value
        let userSettingsRef = userProfilesRef.child(user!).child("settings")
        let futureLocArr: [String] = futureLoc.components(separatedBy: ", ")
        for city in allCities {
            if futureLocArr.contains(city) {
                // Set future location and default location filter
                profile.child("futureLoc").child(city).setValue(true)
                userSettingsRef.child("discovery").child("futureLoc").child(city).setValue(true)
                
                // Add the user's locations to list of all locations
                citiesRef.child(city).child(user!).setValue(true)
            } else {
                profile.child("futureLoc").child(city).setValue(false)
                userSettingsRef.child("discovery").child("futureLoc").child(city).setValue(false)
                citiesRef.child(city).child(user!).setValue(false)
            }
        }
        
        // Add user's university to universities and set others to false
        // Update filter settings
        for university in unis {
            if university == uni {
                uniRef.child(university).child(user!).setValue(true)
                userSettingsRef.child("discovery").child("universities").child(university).setValue(true)
            } else {
                uniRef.child(university).child(user!).setValue(false)
                userSettingsRef.child("discovery").child("universities").child(university).setValue(false)
            }
        }
    }
    
    // MARK: - PickerView Delegate
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // for uni picker delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // for uni picker delegate
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case uniPicker:
            return unis.count + 2
        default:
            return 0
        }
    }
    
    // for uni picker delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case uniPicker:
            switch row {
            case 0:
                return "- Choose a university -"
            case unis.count + 1:
                return "- Add a university -"
            default:
                return unis[row - 1]
            }
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case uniPicker:
            switch row {
            case 0:
                uniTextField.text = ""
            case unis.count + 1:
                var newUni: String = ""
                let alert = UIAlertController(
                    title: "Add a University",
                    message: "Unable to find your uni? Add it here! (Please ensure your university is not already in the list with a different spelling.)",
                    preferredStyle: .alert)
                
                alert.addTextField { (textField) in
                    textField.placeholder = "New University Name"
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                    newUni = alert!.textFields![0].text ?? ""
                    
                    if newUni.contains(".") ||
                        newUni.contains("$") ||
                        newUni.contains("[") ||
                        newUni.contains("]") ||
                        newUni.contains("#") {
                        let invalidCharsAlert = UIAlertController(title: "Failed to Add University", message: "\"\(newUni)\" contains invalid characters \'.$[]#\'.", preferredStyle: .alert)
                        invalidCharsAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(invalidCharsAlert, animated: true, completion: nil)

                    } else {
                        let confirmUniAlert = UIAlertController(title: "Add a University", message: "Are you sure you want to add \"\(newUni)\"?", preferredStyle: .alert)
                        confirmUniAlert.addAction(UIAlertAction(title: "No", style: .cancel))
                        confirmUniAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                            
                            if newUni != "" {
                                print("Adding new uni: ", newUni)
                                if !self.unis.contains(newUni) {
                                    self.unis.append(newUni)
                                    self.unis.sort()
                                }
                                self.uniPicker.reloadComponent(0)
                                let index = self.unis.firstIndex(of: newUni) ?? self.unis.count
                                print("Index for new uni: ", index + 1)
                                self.uniPicker.selectRow(index + 1, inComponent: 0, animated: true)
                                self.uniTextField.text = newUni
                            }
                        }))
                        self.present(confirmUniAlert, animated: true, completion: nil)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            default:
                uniTextField.text = unis[row - 1]
            }
        default:
            return
        }
    }
    // MARK: - Text Field delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == uniTextField {
            return false
        }
        return true
    }
    
    // Dismiss keyboard on tap
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            doneButton.sendActions(for: .touchUpInside)
        }
        // Do not add a line break
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Database Retrieval
    // update the location text to show user's preferences
    func getLocationText() {
        var locationText = ""
        getCities() { (citiesArray) in
            self.cities = citiesArray
            locationText = self.cities.joined(separator: ", ")
            if (locationText.isEmpty == false) {
                self.mapButton.setTitle(locationText, for: .normal)
                self.mapButton.setTitleColor(UIColor.black, for: .normal)
            }
            
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
                citiesArray.append(city.key)
            }
            completion(citiesArray)
        })
    }
    
    // Retrieve a list of universities from Firebase
    func getUniversities(completion: @escaping ([String]) -> Void) {
        uniRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let unisDict = snapshot.value as? [String : AnyObject] else {
                return completion([])
            }
            
            var unisArray: [String] = []
            for uni in unisDict {
                unisArray.append(uni.key)
            }
            unisArray.sort()
            completion(unisArray)
        })
    }
    
    // Retrieve a list of genders from Firebase
    func getAllCities(completion: @escaping ([String]) -> Void) {
        citiesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let citiesDict = snapshot.value as? [String : AnyObject] else {
                return completion([])
            }
            
            var citiesArray: [String] = []
            for city in citiesDict {
                citiesArray.append(city.key)
            }
            citiesArray.sort()
            completion(citiesArray)
        })
    }
    
}
