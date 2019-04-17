//
//  ProfileEditViewController.swift
//  Lamp
//
//  Created by Pearl Xie on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var futureLocTextField: UITextField!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var bedroomNumTextField: UITextField!
    @IBOutlet weak var petsTextField: UITextField!
    @IBOutlet weak var smokingTextField: UITextField!
    @IBOutlet weak var otherLifestylePrefsTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var otherContactTextField: UITextField!
    
    // MARK: - Constants
    let profilesRef = Database.database().reference(withPath: "user-profiles")
    let user = Auth.auth().currentUser?.uid
    let dbRef = Database.database()
    let citiesRef = Database.database().reference(withPath: "locations")
    
    // MARK: - Variables
    var cities:[String] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bioText.delegate = self
        
        let borderRadius = profilePictureImageView.bounds.height / 2
        profilePictureImageView.layer.cornerRadius = borderRadius
        profilePictureImageView.clipsToBounds = true
        
        bioText.layer.borderWidth = 0.5
        bioText.layer.cornerRadius = 5
        bioText.layer.borderColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1).cgColor

//        if (bioText.text == "") {
////            bioText.text = "Bio"
//            bioText.textColor = UIColor.black
////            bioText.textColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
//        }

//        bioText.becomeFirstResponder()
        
//        bioText.selectedTextRange = bioText.textRange(from: bioText.beginningOfDocument, to: bioText.beginningOfDocument)
        
        // Pre-populate with values from Firebase
//        let profile = profilesRef.child(user!).child("profile")
//        profile.observe(.value, with: { (snapshot) in
//            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
//            if let uniVal = profileDict["uni"] as? String {
//                self.uniTextField?.text = uniVal
//            }
//            self.setLocationText()
//            if let occupationVal = profileDict["occupation"] as? String {
//                self.occupationTextField?.text = occupationVal
//            }
//        })

        
        let user = Auth.auth().currentUser?.uid
        let profile = profilesRef.child(user!).child("profile")
        profile.observe(.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.firstNameTextField.text = profileDict["firstName"] as? String
            self.occupationTextField.text = profileDict["occupation"] as? String
            self.setLocationText()
            self.bioText.text = profileDict["bio"] as? String
//            if self.bioText.text != "" {
//                self.bioText.textColor = UIColor.black
//            }
            self.budgetTextField.text = profileDict["budget"] as? String
            self.bedroomNumTextField.text = profileDict["numBedrooms"] as? String
            self.petsTextField.text = profileDict["pets"] as? String
            self.smokingTextField.text = profileDict["smoking"] as? String
            self.otherLifestylePrefsTextField.text = profileDict["otherLifestylePrefs"] as? String
            self.phoneTextField.text = profileDict["phone"] as? String
            self.emailTextField.text = profileDict["email"] as? String
            self.facebookTextField.text = profileDict["facebook"] as? String
            self.otherContactTextField.text = profileDict["otherContact"] as? String
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Database Retrieval
    // update the location text to show user's preferences
    func setLocationText() {
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

    // MARK: - TextView Delegate
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1) {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        // Combine the textView text and the replacement text to
//        // create the updated text string
//        let currentText:String = textView.text
//        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
//
//        // If updated text view will be empty, add the placeholder
//        // and set the cursor to the beginning of the text view
//        if updatedText.isEmpty {
//
////            textView.text = "Bio"
//            textView.textColor = UIColor.black
////            textView.textColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
//
//            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//        }
//
//            // Else if the text view's placeholder is showing and the
//            // length of the replacement string is greater than 0, set
//            // the text color to black then set its text to the
//            // replacement string
//        else if textView.textColor == UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1) && !text.isEmpty {
//            textView.textColor = UIColor.black
//            textView.text = text
//        }
//
//            // For every other case, the text should change with the usual
//            // behavior...
//        else {
//            return true
//        }
//
//        // ...otherwise return false since the updates have already
//        // been made
//        return false
//    }
    
    // MARK: - Actions
    // dismisses the edit page and returns to ProfileViewController
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfilePicture(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard
            let firstName = firstNameTextField.text,
            let occupation = occupationTextField.text,
            let futureLoc = futureLocTextField.text,
            let bio = bioText.text,
            let budget = budgetTextField.text,
            let numBedrooms = bedroomNumTextField.text,
            let smoking = smokingTextField.text,
            let pets = petsTextField.text,
            let otherLifestylePrefs = otherLifestylePrefsTextField.text,
            let phone = phoneTextField.text,
            let email = emailTextField.text,
            let facebook = facebookTextField.text,
            let otherContact = otherContactTextField.text
            //let profilePicture = profilePictureView.image
            else {
                return
        }
        
        // Update all but futureLoc val
        let profile = profilesRef.child(user!).child("profile")
        let values = [
            // Basic Info
            "firstName": firstName,
//            "futureLoc": [futureLoc: true],
            "occupation": occupation,
            "bio": bio,
            "budget": budget,
            //"profilePicture": profilePicture,
            // Lifestyle Prefs
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
        
        self.dismiss(animated: true, completion: nil)
    }
}
