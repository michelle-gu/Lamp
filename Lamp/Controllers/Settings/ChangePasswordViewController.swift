//
//  ChangePasswordViewController.swift
//  Lamp
//
//  Created by Michelle Gu on 4/3/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: Actions
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
