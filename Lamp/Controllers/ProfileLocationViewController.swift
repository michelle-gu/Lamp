//
//  ProfileLocationViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit

class ProfileLocationViewController: UIViewController {

    // segues
    let openMap = "openMap"
    let showHomePage = "showHomePage"
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilePictureView.clipsToBounds = true
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
