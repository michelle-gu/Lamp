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
        
        // Prompt the user to re-provide their sign-in credentials
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: oldPassword)
        user?.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
            if let error = error {
                // An error happened.
                let alert = UIAlertController(
                    title: "Old Password Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("User re-authenticated. Attempting to update password.")
                Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                    if let error = error {
                        print("Password change failed.")
                        let alert = UIAlertController(
                            title: "Password Change Failed",
                            message: error.localizedDescription,
                            preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                        return
                    } else {
                        print("Password change success. Returning to previous screen.")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        })
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordField.isSecureTextEntry = true
        newPasswordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
    }
    
}
