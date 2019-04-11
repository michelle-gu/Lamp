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
let uniPickerData = [String](arrayLiteral: "University of Texas at Austin", "St. Edwards")

class ProfileLocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Segues
    let openMap = "openMap"
    let showHomePage = "showHomePage"
    
    // MARK: Properties
    let profilesRef = Database.database().reference(withPath: "user-profiles")
    let dbRef = Database.database()
    let citiesRef = Database.database().reference(withPath: "locations")
    let user = Auth.auth().currentUser?.uid
    var cities:[String] = []
    
    // MARK: Outlets
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var uniTextField: UITextField!
    @IBOutlet weak var futureLocTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        profilePictureView.clipsToBounds = true
        
        // for university picker
        let uniPicker = UIPickerView()
        uniPicker.delegate = self
        uniTextField.inputView = uniPicker
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLocationText()
    }
    
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
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard
            let uni = uniTextField.text,
            let futureLoc = futureLocTextField.text,
            let occupation = occupationTextField.text
            //let profilePicture = profilePictureView.image
            else {
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
        print(futureLocArr)
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
    
}
