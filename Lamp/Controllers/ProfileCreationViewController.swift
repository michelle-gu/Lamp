//
//  ProfileCreationViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

let genderPickerData = [String](arrayLiteral: "Female", "Male", "Other")

class ProfileCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Constants
    let showLocationInfoScreen = "showLocationInfoScreen"
    
    // MARK: Properties
    let userProfilesRef = Database.database().reference(withPath: "user-profiles")
    let gendersRef = Database.database().reference(withPath: "genders")

    // MARK: Outlets
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var changePictureButton: UIButton!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // profile picture styling
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        profilePictureView.clipsToBounds = true
        
        // change picture button styling
        changePictureButton.layer.borderWidth = 1
        changePictureButton.layer.cornerRadius = changePictureButton.bounds.height / 2
        changePictureButton.layer.borderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1).cgColor

        // Gender picker setup
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderTextField.inputView = genderPicker
        
        // Birthday Date picker setup
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(ProfileCreationViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileCreationViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        birthdayTextField.inputView = datePicker
    }
    
    // when outside of picker is tapped, it will dismiss
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // for date picker
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    // UI Picker delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of elements
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerData[row]
    }
    
    // Sets gender text field to selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genderPickerData[row]
    }
    
    // Upon completion of filling in profile fields and Next button is pressed
    @IBAction func nextButtonPressed(_ sender: Any) {
        guard
            let firstName = firstNameTextField.text,
            let birthday = birthdayTextField.text,
            let gender = genderTextField.text,
            //let profilePicture = profilePictureView.image,
            firstName.count > 0,
            birthday.count > 0
            else {
                let alert = UIAlertController(
                    title: "Profile Creation Failed",
                    message: "Please fill First Name and birthday fields.",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        let user = Auth.auth().currentUser?.uid
        
        let profile = Profile(firstName: firstName, birthday: birthday, gender: gender, uni: "", futureLoc: "", occupation: "")
        let settings = Settings()
        
        let userRef = self.userProfilesRef.child(user!)
        userRef.updateChildValues(profile.toAnyObject() as! [AnyHashable : Any])
        userRef.updateChildValues(settings.toAnyObject() as! [AnyHashable : Any])
        
        let genderValues = [
            gender: [
                user: true
            ]
        ]
        gendersRef.updateChildValues(genderValues)

    }

}
