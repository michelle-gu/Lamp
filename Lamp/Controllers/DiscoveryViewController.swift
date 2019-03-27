//
//  DiscoveryViewController.swift
//  Lamp
//
//  Created by Maria Ocanas on 3/26/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Eureka

public let discovery = ["Future Location", "Max Distance", "Universities", "Gender", "Age Range", "Show My Profile"]

class DiscoveryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let discoveryCellIdentifier = "DiscoveryCellIdentifier"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discovery.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let cellLabel = discovery[row]
        
        switch cellLabel {
            
        case "Future Location":
            fallthrough
        case "Universities":
            fallthrough
        case "Gender":
            let subtitleCell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier) as! SubtitleTableViewCell
            subtitleCell.titleLabel.text = cellLabel
            subtitleCell.subtitleLabel.text = "Hello"
            // configure subtitle

            return subtitleCell
        case "Age Range":
            let rangeCell = tableView.dequeueReusableCell(withIdentifier: RangeSliderTableViewCell.identifier) as! RangeSliderTableViewCell
            rangeCell.titleLabel.text = cellLabel
            
            // configure range cell
            
            return rangeCell
            
        case "Max Distance":
            let sliderCell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier) as! SliderTableViewCell
            
            // configure slider cell
            
            return sliderCell
            
        case "Show My Profile":
            let toggleCell = tableView.dequeueReusableCell(withIdentifier: ToggleTableViewCell.identifier) as! ToggleTableViewCell
            
            
            return toggleCell
        default:
            fatalError("Something went wrong")
        }
        
        
//        if cellLabel == "Future Location" || cellLabel == "Universities" || cellLabel == "Gender"{
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: discoveryCellIdentifier)
//            cell.detailTextLabel?.text = "Nothing"
//        }
//
//        cell.textLabel?.text = cellLabel
////        else if cellLabel == "Max Distance" || cellLabel == "Age Range"{
////
////        }
//
//        cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
//
//        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
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
