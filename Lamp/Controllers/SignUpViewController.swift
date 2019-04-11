//
//  SignUpViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 3/8/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: Constants
    let sendEmailConfirm = "sendEmailConfirm"
    let showLoginScreen = "showLoginScreen"

    // MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: Actions
    @IBAction func logInDidTouch(_ sender: Any) {
        
    }
    
    @IBAction func signUpDidTouch(_ sender: Any) {
        guard
            let email = emailField.text,
            let password = passwordField.text,
            let confirmedPassword = confirmPasswordField.text,
            email.count > 0,
            password.count > 0,
            confirmedPassword.count > 0,
            confirmedPassword == password
            else {
                let alert = UIAlertController(
                    title: "Sign Up Failed",
                    message: "Please fill in all fields and ensure password matches confirmation password.",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        // Store email and password to firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            if let error = error, user == nil {
                print("\nError signing up\n")
                let alert = UIAlertController(
                    title: "Sign Up Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                print("\nSuccess! Using segue\n")
                self.performSegue(withIdentifier: self.sendEmailConfirm, sender: nil)
            }
        }
        
        // Add default user info to Firebase
//        let user = Auth.auth().currentUser?.uid
//        let settings = Settings()
//        let userRef = ref.child(user!)
//        userRef.setValue(settings.toAnyObject())
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Checks if user is already logged in
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "showLoginScreen",
                                  sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }

}
