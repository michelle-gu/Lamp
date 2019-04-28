//
//  LogInViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 3/8/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {

    // MARK: Constants
    let showSignUpScreen = "showSignUpScreen"
    let showSocialMediaScreen = "showSocialMediaScreen"
    let showProfileSegueIdentifier = "showProfileSegueIdentifier"
    
    let ref = Database.database().reference(withPath: "user-profiles")
    
    // MARK: - Functions
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
//            logInButton.sendActions(for: .touchUpInside)
        }
        // Do not add a line break
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
//    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

    
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
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    @objc func keyboardNotification(notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            let endFrameY = endFrame!.origin.y ?? 0
//            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
//            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
//            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
//            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
//            if endFrameY >= UIScreen.main.bounds.size.height {
//                self.keyboardHeightLayoutConstraint?.constant = 0.0
//            } else {
//                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
//            }
//            UIView.animate(withDuration: duration,
//                           delay: TimeInterval(0),
//                           options: animationCurve,
//                           animations: { self.view.layoutIfNeeded() },
//                           completion: nil)
//        }
//    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        emailField.tag = 0
        passwordField.delegate = self
        passwordField.tag = 1
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Checks if user is already logged in
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.emailField.text = nil
                self.passwordField.text = nil
                
                if let userID = user?.uid {
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
