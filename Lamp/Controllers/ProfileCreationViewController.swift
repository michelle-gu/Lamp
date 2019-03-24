//
//  ProfileCreationViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

let genderPickerData = [String](arrayLiteral: "Female", "Male", "Other")

class ProfileCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Constants
    let showLocationInfoScreen = "showLocationInfoScreen"
    
    @IBOutlet weak var genderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Gender picker setup
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderTextField.inputView = genderPicker
    }
    
    // UI Picker delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of elements
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerData[row]
    }
    
    // Sets gender text field to selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genderPickerData[row]
    }

}
