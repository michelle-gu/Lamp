//
//  ProfileMapViewController.swift
//  Lamp
//
//  Created by Lindsey Thompson on 3/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import MapKit

class ProfileMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // radius that the map shows with coordinates in the center
    let regionRadius: CLLocationDistance = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting initial map location
        let initialLocation = CLLocation(latitude: 37.773972, longitude: -122.431297)
        // showing map
        centerMapOnLocation(location: initialLocation)
    }
    
    // helper method that sets the rectangular view of the map based on region radius
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}
