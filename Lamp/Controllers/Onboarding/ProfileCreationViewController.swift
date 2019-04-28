//
//  ProfileCreationViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

let genderPickerData = [String](arrayLiteral: "Female", "Male", "Other", "Prefer not to say")

class ProfileCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Constants
    // Segue Identifiers
    let showLocationInfoScreen = "showLocationInfoScreen"
    // Pickers
    let imagePicker = UIImagePickerController()
    // Firebase References
    let userProfilesRef = Database.database().reference(withPath: "user-profiles")
    let gendersRef = Database.database().reference(withPath: "genders")
    let user = Auth.auth().currentUser?.uid

    // MARK: - Outlets
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var changePictureButton: UIButton!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    // MARK: - Actions
    @IBAction func changePictureButtonPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Remove Current Photo", style: .destructive, handler:
            { action in
                // Remove photo from profile picture view
                self.profilePictureView.image = UIImage(named: "profile-pic-blank")
                // Profile reference
                let profileRef = self.userProfilesRef.child(self.user!).child("profile")

                // Remove photo from Firebase Storage
                let profilePicRef = Storage.storage().reference().child("profilePictures").child("\(self.user!).jpg")
                profilePicRef.delete { error in
                    if let error = error {
                        print(error)
                    } else {
                        // File deleted successfully
                    }
                }

                // Remove profile picture from database
                let values = ["profilePicture": ""]
                profileRef.updateChildValues(values)
        }))
        actionSheet.addAction(UIAlertAction(title: "Import from Facebook", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler:
            { action in
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    // Whole picture, not an edited version
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.cameraCaptureMode = .photo
                    
                    // Present camera as popover
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    self.noCamera()
                }
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler:
            { action in
                // Whole picture, not an edited version
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                
                // Present the picker in a full screen popover
                self.imagePicker.modalPresentationStyle = .popover
                self.present(self.imagePicker, animated: true, completion: nil)
                self.imagePicker.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    // Upon completion of filling in profile fields and Next button is pressed
    @IBAction func nextButtonPressed(_ sender: Any) {
        guard
            let firstName = firstNameTextField.text,
            let birthday = birthdayTextField.text,
            let gender = genderTextField.text,
            //let profilePicture = profilePictureView.image,
            firstName.count > 0,
            birthday.count > 0,
            gender.count > 0,
            isValidBirthday(birthday: birthday)
            else {
                let alert = UIAlertController(
                    title: "Profile Creation Failed",
                    message: "Please fill in all fields. You must be at least 18 years old to use this app.",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        // Create profile using profilePic value from Firebase
        let values = [
            "firstName": firstName,
            "birthday": birthday,
            "gender": gender,
            ]
        let settings = Settings()
        
        let userRef = self.userProfilesRef.child(self.user!)
        userRef.child("profile").updateChildValues(values)
        userRef.updateChildValues(settings.toAnyObject() as! [AnyHashable : Any])

        let genderValues = [
            gender: [
                user: true
            ]
        ]
        gendersRef.updateChildValues(genderValues)
        
    }

    // MARK: - Functions
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // Change UIImage to data
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion(nil)
        }
        
        // upload data to path
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // Handle errors
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // Return URL
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }
    
    // No camera available on device alert
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the selected photo
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // Set profile picture view to the photo
        profilePictureView.image = chosenImage
        
        // Add photo to Firebase Storage
        let imageRef = Storage.storage().reference().child("profilePictures").child("\(self.user!).jpg")
        // No need to remove old photo because this replaces the old photo
        // in Firebase Storage
        uploadImage(chosenImage, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString: String = downloadURL.absoluteString
            let profileRef = self.userProfilesRef.child(self.user!).child("profile")
            let values = ["profilePicture": urlString]
            profileRef.updateChildValues(values)
        }
        
        // Dismiss the popover when done
        dismiss(animated: true, completion: nil)
    }
    
    // Dismiss popover on cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Textfield delegates
        genderTextField.delegate = self
        birthdayTextField.delegate = self
        
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
        
        // Image Picker
        imagePicker.delegate = self
        
        // Pre-populate with values from Firebase
        let profile = userProfilesRef.child(user!).child("profile")
        profile.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let firstNameVal = profileDict["firstName"] as? String {
                self.firstNameTextField?.text = firstNameVal
            }
            if let genderVal = profileDict["gender"] as? String {
                self.genderTextField?.text = genderVal
            }
            if let birthdayVal = profileDict["birthday"] as? String {
                self.birthdayTextField?.text = birthdayVal
            }
            if let profilePicVal = profileDict["profilePicture"] as? String {
                if profilePicVal != "" {
                    let profilePicURL = URL(string: profilePicVal)
                    self.profilePictureView.kf.setImage(with: profilePicURL)
                }
            }
        })
        
    }
    
    // MARK: - Picker delegate
    // when outside of picker is tapped, it will dismiss
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // for date picker
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
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
    
    // Birthday is at least 13 years old
    func isValidBirthday(birthday: String) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM/dd/yyyy"
        let birthdayDate = myDateFormatter.date(from: birthday)!
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: birthdayDate, to: now)
        let age = ageComponents.year!
        return age >= 18
    }
    
    // MARK: - Text Field delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

}
