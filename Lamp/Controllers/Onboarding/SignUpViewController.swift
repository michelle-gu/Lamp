//
//  SignUpViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 3/8/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Constants
    let sendEmailConfirm = "sendEmailConfirm"
    let showLoginScreen = "showLoginScreen"

    // MARK: - Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            signUpButton.sendActions(for: .touchUpInside)
        }
        // Do not add a line break
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func logInDidTouch(_ sender: Any) {
        
    }
    
    @IBAction func signUpDidTouch(_ sender: Any) {
        guard
            let email = emailField.text,
            let password = passwordField.text,
            let confirmedPassword = confirmPasswordField.text,
            email.count > 0,
            email.hasSuffix(".edu"),
            password.count > 0,
            confirmedPassword.count > 0,
            confirmedPassword == password
            else {
                let alert = UIAlertController(
                    title: "Sign Up Failed",
                    message: "Please fill in all fields, use a '.edu' email, and ensure password matches confirmation password.",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        // Store email and password to firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            if let error = error, user == nil {
                let alert = UIAlertController(
                    title: "Sign Up Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                self.performSegue(withIdentifier: self.sendEmailConfirm, sender: nil)
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        emailField.tag = 0
        passwordField.delegate = self
        passwordField.tag = 1
        confirmPasswordField.delegate = self
        confirmPasswordField.tag = 2
        
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
