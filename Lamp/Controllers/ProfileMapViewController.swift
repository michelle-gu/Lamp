//
//  ProfileMapViewController.swift
//  Lamp
//
//  Created by Pearl Xie on 4/3/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import MapKit

class ProfileMapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addCityToList: UIButton!
    @IBOutlet weak var radiusInput: UITextField!
    @IBOutlet weak var radiusOkButton: UIButton!
    
    // MARK: Properties
    let regionRadius: CLLocationDistance = 10000
    let locationManager = CLLocationManager()
    let searchRadius: CLLocationDistance = 2000
    let initialLocation = CLLocation(latitude: 37.773972, longitude: -122.431297)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        centerMapOnLocation(location: initialLocation)
        
        // change add button styling
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        addButton.layer.borderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1).cgColor
        
        addCityToList.layer.borderWidth = 1
        addCityToList.layer.cornerRadius = addButton.bounds.height / 2
        addCityToList.layer.borderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1).cgColor
        
        radiusOkButton.layer.borderWidth = 1
        radiusOkButton.layer.cornerRadius = addButton.bounds.height / 3
        radiusOkButton.layer.borderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1).cgColor
        
    }
    
    // helper method that sets the rectangular view of the map based on region radius
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // when the Add button is pressed, the Search bar is brought up
    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        // Hide the search bar after search
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("oops")
            } else {
                // Remove existing pinpoints
                let pinpoints = self.mapView.annotations
                self.mapView.removeAnnotations(pinpoints)
                
                // Get data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                // Create pinpoint
                let pinpoint = MKPointAnnotation()
                pinpoint.title = searchBar.text
                pinpoint.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(pinpoint)
                
                // Zoom in on map to the pinpoint
                let coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    // Add to list of cities
    @IBAction func addCityToListButtonPressed(_ sender: Any) {
    }
    
    func addRadius(location: CLLocation) {
        //let radius = radiusInput.text
    }
    
    // MARK: Navigation
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Authorization
    // Source: raywenderlich.com
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    /*
    // This gets called when location information comes back. You get an array of locations, but you’re only interested in the first item. You don’t do anything with it yet, but eventually you will zoom to this location.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    */

}
