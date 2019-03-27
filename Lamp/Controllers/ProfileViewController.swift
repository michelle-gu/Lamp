//
//  ProfileViewController.swift
//  Lamp
//
//  Created by Pearl Xie on 3/27/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController  {
    // UITableViewDelegate, UITableViewDataSource
    
    // MARK: Constants
    let bioTableViewCellIdentifier = "bioTableViewCellIdentifier"
    let budgetTableViewCellIdentifier = "budgetTableViewCellIdentifier"
    let lifestylePrefsTableViewCellIdentifier = "lifestylePrefsViewCellIdentifier"
    let contactInfoTableViewCellIdentifier = "contactInfoTableViewCellIdentifier"

    
    // MARK: Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var futureLocationLabel: UILabel!
    @IBOutlet weak var uniLabel: UILabel!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: Properties
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
    
    // TODO: Make cell rows unselectable
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier, for: indexPath) as! CustomTableViewCell
//        let cell: UITableViewCell
//        let row = indexPath.row
//        switch row {
//        case 0:
//            cell = profileTableView.dequeueReusableCell(withIdentifier: bioTableViewCellIdentifier, for: indexPath)
//        case 1:
//            cell = profileTableView.dequeueReusableCell(withIdentifier: budgetTableViewCellIdentifier, for: indexPath)
//        case 2:
//            cell = profileTableView.dequeueReusableCell(withIdentifier: lifestylePrefsTableViewCellIdentifier, for: indexPath)
//        case 3:
//            cell = profileTableView.dequeueReusableCell(withIdentifier: contactInfoTableViewCellIdentifier, for: indexPath)
//        default:
//            cell = profileTableView.dequeueReusableCell(withIdentifier: bioTableViewCellIdentifier, for: indexPath)
//            print("Shouldn't happen.")
//        }
//
//        // TODO: Set cell details
//
//        return cell
//    }
    
    // MARK: Actions
    @IBAction func editButtonDidTouch(_ sender: Any) {
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        profileTableView.delegate = self
//        profileTableView.dataSource = self
    }
    
}
