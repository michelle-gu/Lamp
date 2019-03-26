//
//  LogInViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 3/8/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    // MARK: Constants
    let showSignUpScreen = "showSignUpScreen"
    let showSocialMediaScreen = "showSocialMediaScreen"
    
    // MARK: Properties
    
    // MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: Actions
    @IBAction func logInDidTouch(_ sender: Any) {
        // Fetch from Firebase and sign in
        guard
            let email = emailField.text,
            let password = passwordField.text,
            email.count > 0,
            password.count > 0
            else {
                let alert = UIAlertController(
                    title: "Sign In Failed",
                    message: "Please fill in all fields.",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(
                    title: "Sign In Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpDidTouch(_ sender: Any) {
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Checks if user is already logged in
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "showSocialMediaScreen",
                                  sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    // MARK: - Navigation

}
