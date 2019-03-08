//
//  SignUpViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 3/8/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: Constants
    let signUpSegue = "signUpSegue"

    // MARK: Properties

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
        
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
