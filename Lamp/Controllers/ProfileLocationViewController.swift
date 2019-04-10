//
//  ProfileLocationViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

// current universities
let uniPickerData = [String](arrayLiteral: "University of Texas at Austin", "St. Edwards")

class ProfileLocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Segues
    let openMap = "openMap"
    let showHomePage = "showHomePage"
    
    // MARK: Properties
    let profilesRef = Database.database().reference(withPath: "user-profiles")
    let dbRef = Database.database()
    
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
            "futureLoc": futureLoc,
            "occupation": occupation
        ]
        profile.updateChildValues(values)
        
        // Set default location & uni filters
        let filterValues = [
            "futureLocs": [
                futureLoc: true
            ],
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
        
        let locValues = [
            futureLoc: [
                user: true
            ]
        ]
        dbRef.reference(withPath: "locations").updateChildValues(locValues)

        // Update filter defaults
    }
    
}
