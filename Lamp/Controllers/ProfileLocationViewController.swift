//
//  ProfileLocationViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

// current universities
let uniPickerData = [String](arrayLiteral: "University of Texas at Austin", "St. Edwards")

class ProfileLocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // segues
    let openMap = "openMap"
    let showHomePage = "showHomePage"
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var uniTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilePictureView.clipsToBounds = true
        
        // for university picker
        let uniPicker = UIPickerView()
        uniPicker.delegate = self
        uniTextField.inputView = uniPicker
        
    }
    
    // for uni picker delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // for uni picker delegate
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return uniPickerData.count
    }
    
    // for uni picker delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return uniPickerData[row]
    }
    
    // for uni picker delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        uniTextField.text = uniPickerData[row]
    }

}
