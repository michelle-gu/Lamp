//
//  ProfileEditViewController.swift
//  Lamp
//
//  Created by Pearl Xie on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var futureLocTextField: UITextField!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var bedroomNumTextField: UITextField!
    @IBOutlet weak var petsTextField: UITextField!
    @IBOutlet weak var smokingTextField: UITextField!
    @IBOutlet weak var timeOfDayTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load existing information
        let borderRadius = profilePictureImageView.bounds.height / 2
        profilePictureImageView.layer.cornerRadius = borderRadius
        profilePictureImageView.clipsToBounds = true
        
        bioText.layer.borderWidth = 0.5
        bioText.layer.cornerRadius = 5
        bioText.layer.borderColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1).cgColor
        bioText.text = "Bio"
        bioText.textColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Bio"
            textView.textColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // dismisses the edit page and returns to ProfileViewController
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfilePicture(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
}
