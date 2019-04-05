//
//  ChangePasswordViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 4/3/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: Actions
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard
            let oldPassword = oldPasswordField.text,
            let newPassword = newPasswordField.text,
            let confirmPassword = confirmPasswordField.text,
            newPassword.count > 6,
            confirmPassword == newPassword
            else {
                let alert = UIAlertController(
                    title: "Password Change Failed",
                    message: "Please fill in all fields and ensure the new password is at least 6 characters and matches the confirmed password.",
                    preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
//        let user = Auth.auth().currentUser
//        var credential: AuthCredential
        
//        // Prompt the user to re-provide their sign-in credentials
//        user?.reauthenticate(with: credential) { error in
//            if let error = error {
//                let alert = UIAlertController(
//                    title: "Password Change Failed",
//                    message: error.localizedDescription,
//                    preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                // User re-authenticated.
//            }
//        }
        
        Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
            let alert = UIAlertController(
                title: "Password Change Failed",
                message: error?.localizedDescription,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
