//
//  EditProfileTableViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 4/24/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    // MARK: - Constants
    let user = Auth.auth().currentUser?.uid
    let userProfilesRef = Database.database().reference(withPath: "user-profiles")
    let citiesRef = Database.database().reference(withPath: "locations")
    let imagePicker = UIImagePickerController()

    // MARK: - Variables
    var cities: [String] = []
    
    // MARK: - Outlets
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var universityField: UITextField!
    @IBOutlet weak var futureLocationField: UITextField!
    @IBOutlet weak var occupationField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    @IBOutlet weak var budgetField: UITextField!
    @IBOutlet weak var numBedroomsField: UITextField!
    @IBOutlet weak var petsField: UITextField!
    @IBOutlet weak var smokingField: UITextField!
    @IBOutlet weak var otherPreferencesField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var facebookField: UITextField!
    @IBOutlet weak var otherContactField: UITextField!
    
    // MARK: - Actions
    @IBAction func changeProfilePicPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Remove Current Photo", style: .destructive, handler:
            { action in
                // Remove photo from profile picture view
                self.profilePicView.image = UIImage(named: "profile-pic-blank")
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
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard
            let name = nameField.text,
            let gender = genderField.text,
            let birthday = birthdayField.text,
            let university = universityField.text,
            let futureLoc = futureLocationField.text,
            let occupation = occupationField.text,
            let bio = bioField.text,
            let budget = budgetField.text,
            let numBedrooms = numBedroomsField.text,
            let pets = petsField.text,
            let smoking = smokingField.text,
            let otherLifestylePrefs = otherPreferencesField.text,
            let phone = phoneField.text,
            let email = emailField.text,
            let facebook = facebookField.text,
            let otherContact = otherContactField.text
            else {
                return
        }
        
        // Update all but futureLoc val
        let profile = userProfilesRef.child(user!).child("profile")
        let values = [
            // Basic Info
            "firstName": name,
            "gender": gender,
            "birthday": birthday,
            "uni": university,
            "occupation": occupation,
            "bio": bio,
            // Living Prefs
            "budget": budget,
            "numBedrooms": numBedrooms,
            "pets": pets,
            "smoking": smoking,
            "otherLifestylePrefs": otherLifestylePrefs,
            // Contact Info
            "phone": phone,
            "email": email,
            "facebook": facebook,
            "otherContact": otherContact
            ] as [String : Any]
        profile.updateChildValues(values)

        // Update futureLoc value
        let userSettingsRef = userProfilesRef.child(user!).child("settings")
        let futureLocArr: [String] = futureLoc.components(separatedBy: ", ")
        for loc in futureLocArr {
            print("Pressing done & saving data!")
            // Set future location and default location filter
            let locFilterVal = [
                loc: true
            ]
            profile.child("futureLoc").updateChildValues(locFilterVal)
            userSettingsRef.child("discovery").child("futureLoc").updateChildValues(locFilterVal)

            // Add the user's locations to list of all locations
            let locValues = [
                loc: [
                    user: true
                ]
            ]
            citiesRef.updateChildValues(locValues)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Functions
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
        profilePicView.image = chosenImage
        
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
    
    // Dismiss keyboard on tap
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        return age >= 13
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates
        nameField.delegate = self
        // TODO: Textfield delegates
        imagePicker.delegate = self
        // TODO: Add Bio text placeholder
        
        // TODO: Add pickers for Birthday, Gender, Uni, etc.

        // Remove empty cells at bottom
        tableView.tableFooterView = UIView()
        
        // Format profile picture view
        let borderRadius = profilePicView.bounds.height / 2
        profilePicView.layer.cornerRadius = borderRadius
        profilePicView.clipsToBounds = true

        // Populate data
        let profile = userProfilesRef.child(user!).child("profile")
        profile.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            if let profilePicVal = profileDict["profilePicture"] as? String {
                if profilePicVal != "" {
                    let profilePicURL = URL(string: profilePicVal)
                    self.profilePicView.kf.setImage(with: profilePicURL)
                }
            }
            if let nameVal = profileDict["firstName"] as? String {
                self.nameField.text = nameVal
            }
            if let genderVal = profileDict["gender"] as? String {
                self.genderField.text = genderVal
            }
            if let birthdayVal = profileDict["birthday"] as? String {
                self.birthdayField.text = birthdayVal
            }
            if let uniVal = profileDict["uni"] as? String {
                self.universityField.text = uniVal
            }
            self.setLocationText()
            if let occupationVal = profileDict["occupation"] as? String {
                self.occupationField.text = occupationVal
            }
            if let bioVal = profileDict["bio"] as? String {
                self.bioField.text = bioVal
                // TODO: Set Bio text w/ placeholder
//                 if self.bioText.text != "" {
//                self.bioText.textColor = UIColor.black
//            }
            }
            if let budgetVal = profileDict["budget"] as? String {
                self.budgetField.text = budgetVal
            }
            if let numBedroomsVal = profileDict["numBedrooms"] as? String {
                self.numBedroomsField.text = numBedroomsVal
            }
            if let petsVal = profileDict["pets"] as? String {
                self.petsField.text = petsVal
            }
            if let smokingVal = profileDict["smoking"] as? String {
                self.smokingField.text = smokingVal
            }
            if let otherLifestyleVal = profileDict["otherLifestylePrefs"] as? String {
                self.otherPreferencesField.text = otherLifestyleVal
            }
            if let phoneVal = profileDict["phone"] as? String {
                self.phoneField.text = phoneVal
            }
            if let emailVal = profileDict["email"] as? String {
                self.emailField.text = emailVal
            }
            if let facebookVal = profileDict["facebook"] as? String {
                self.facebookField.text = facebookVal
            }
            if let otherContactVal = profileDict["otherContact"] as? String {
                self.otherContactField.text = otherContactVal
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
        headerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1) // Use default
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
            return 6
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
    
    // MARK: - Database Retrieval
    // update the location text to show user's preferences
    func setLocationText() {
        var locationText = ""
        getCities() { (citiesArray) in
            self.cities = citiesArray
            locationText = self.cities.joined(separator: ", ")
            
            self.futureLocationField.text = locationText
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
    
}
