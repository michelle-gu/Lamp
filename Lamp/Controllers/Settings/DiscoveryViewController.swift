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
    
    let futureLocationSegueIdentifier = "FutureLocationSegueIdentifier"
    let universitiesSegueIdentifier = "UniversitiesSegueIdentifier"
    let genderSegueIdentifier = "GenderSegueIdentifier"
    
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
            sliderCell.titleLabel.text = cellLabel
            // configure slider cell
            
            return sliderCell
            
        case "Show My Profile":
            let toggleCell = tableView.dequeueReusableCell(withIdentifier: ToggleTableViewCell.identifier) as! ToggleTableViewCell
            toggleCell.titleLabel.text = cellLabel
            
            return toggleCell
        default:
            fatalError("Something went wrong")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        var segueIdentifier = ""
        if discovery[indexPath.row] == "Future Location"{
            segueIdentifier = futureLocationSegueIdentifier
        }
        else if discovery[indexPath.row] == "Universities"{
            segueIdentifier = universitiesSegueIdentifier
        }
        else if discovery[indexPath.row] == "Gender"{
            segueIdentifier = genderSegueIdentifier
        }
        performSegue(withIdentifier: segueIdentifier, sender: self)
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
