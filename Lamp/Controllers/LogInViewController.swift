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
    let showProfileSegueIdentifier = "showProfileSegueIdentifier"
    
    let ref = Database.database().reference(withPath: "user-profiles")
    
    // MARK: Properties
    
    // MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: Actions
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        print("Unwind segue to login triggered!")
    }

    
    @IBAction func logInDidTouch(_ sender: Any) {
        guard
            let email = emailField.text,
            let password = passwordField.text,
            email.count > 0,
            password.count > 0
            else {
                print("\nError signing with fields!\n")
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
                print("\nError signing in\n")
                let alert = UIAlertController(
                    title: "Sign In Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                print("\nSuccess! Using social media segue\n")
                if let userID = user?.user.uid {
                    self.ref.child(userID).child("profile").observe(.value, with: { (snapshot) in
                        let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
                        if profileDict["uni"] == nil {
                            self.performSegue(withIdentifier: self.showSocialMediaScreen, sender: nil)
                        } else {
                            self.performSegue(withIdentifier: self.showProfileSegueIdentifier, sender: nil)
                        }
                    })
                }
//                self.performSegue(withIdentifier: self.showSocialMediaScreen, sender: nil)
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
                self.emailField.text = nil
                self.passwordField.text = nil
                
                print ("Already logged in!!!!")
                if let userID = user?.uid {
                    print ("UserID exists")
                    self.ref.child(userID).child("profile").observe(.value, with: { (snapshot) in
                        let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
                        if profileDict["uni"] == nil {
                            self.performSegue(withIdentifier: self.showSocialMediaScreen, sender: nil)
                        } else {
                            self.performSegue(withIdentifier: self.showProfileSegueIdentifier, sender: nil)
                        }
                    })
                }
                
            }
        }
    }
    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == showSocialMediaScreen {
//        }
//    }
    
}
