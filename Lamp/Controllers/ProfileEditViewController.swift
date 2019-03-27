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
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load existing information
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfilePicture(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
}
