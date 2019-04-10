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
    //@IBOutlet weak var radiusInput: UITextField!
    //@IBOutlet weak var radiusOkButton: UIButton!
    @IBOutlet weak var futureCity1: UIButton!
    @IBOutlet weak var futureCity2: UIButton!
    @IBOutlet weak var futureCity3: UIButton!
    
    // MARK: Properties
    var cities:[String] = []
    let regionRadius: CLLocationDistance = 10000
    let locationManager = CLLocationManager()
    var location = CLLocation()
    var currentCity: String = ""
    let searchRadius: CLLocationDistance = 2000
    let initialLocation = CLLocation(latitude: 37.773972, longitude: -122.431297)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        futureCity1.isHidden = true
        futureCity2.isHidden = true
        futureCity3.isHidden = true
        
        centerMapOnLocation(location: initialLocation)
        
        // change add button styling
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        addButton.layer.borderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1).cgColor
        
        addCityToList.layer.borderWidth = 1
        addCityToList.layer.cornerRadius = addButton.bounds.height / 1.5
        addCityToList.layer.borderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1).cgColor
        
        /*
        radiusOkButton.layer.borderWidth = 1
        radiusOkButton.layer.cornerRadius = addButton.bounds.height / 3
        radiusOkButton.layer.borderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1).cgColor */
        
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
                
                self.location = CLLocation(latitude: latitude!, longitude: longitude!)
                
                // convert coordinates to city name
                // add city to array of cities
                self.fetchCityAndCountry(from: self.location) { city, country, error in
                    guard let city = city, error == nil else { return }
                    self.currentCity = city
                }
            }
        }
    }
    
    // Convert a Coordinate into a Placemark
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    // Add to list of cities
    // super duper hard coded
    @IBAction func addCityToListButtonPressed(_ sender: Any) {
        cities.append(currentCity)
        let size = cities.count
        /*
        for n in 1...size {
            
        } */
        
        if (futureCity1.isHidden == true) {
            futureCity1.setTitle(currentCity, for: .normal)
            futureCity1.isHidden = false
        } else if (futureCity2.isHidden == true) {
            futureCity2.setTitle(currentCity, for: .normal)
            futureCity2.isHidden = false
        } else if (futureCity3.isHidden == true) {
            futureCity3.setTitle(currentCity, for: .normal)
            futureCity3.isHidden = false
        }
        
        if (futureCity1.isHidden == false && futureCity2.isHidden == false && futureCity3.isHidden == false) {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
    // Click to Remove City
    @IBAction func city1ButtonPressed(_ sender: Any) {
        if (futureCity1.isHidden == false) {
            futureCity1.isHidden = true
        }
        if (futureCity1.isHidden == true || futureCity2.isHidden == true || futureCity3.isHidden == true) {
            addButton.isHidden = false
        }
    }
    
    @IBAction func city2ButtonPressed(_ sender: Any) {
        if (futureCity2.isHidden == false) {
            futureCity2.isHidden = true
        }
        if (futureCity1.isHidden == true || futureCity2.isHidden == true || futureCity3.isHidden == true) {
            addButton.isHidden = false
        }
    }
    
    @IBAction func city3ButtonPressed(_ sender: Any) {
        if (futureCity3.isHidden == false) {
            futureCity3.isHidden = true
        }
        if (futureCity1.isHidden == true || futureCity2.isHidden == true || futureCity3.isHidden == true) {
            addButton.isHidden = false
        }
    }
    
    /*
    func addRadius(location: CLLocation) {
        //let radius = radiusInput.text
    } */
    
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

}
