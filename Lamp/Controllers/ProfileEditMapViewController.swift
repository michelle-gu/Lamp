//
//  ProfileEditMapViewController.swift
//  Lamp
//
//  Created by Pearl Xie on 4/17/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ProfileEditMapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addCityToList: UIButton!
    @IBOutlet weak var futureCity1: UIButton!
    @IBOutlet weak var futureCity2: UIButton!
    @IBOutlet weak var futureCity3: UIButton!
    
    // MARK: Firebase Properties
    let citiesRef = Database.database().reference(withPath: "locations")
    let userRef = Database.database().reference(withPath: "user-profiles")
    let user = Auth.auth().currentUser?.uid
    
    // MARK: Properties
    var cities:[String] = []
    var locationManager = CLLocationManager()
    var location = CLLocation()
    var currentCity: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        //update user location
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        // Get user authorization
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        // Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        // Update location
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        getCities() { (citiesArray) in
            self.cities = citiesArray
            
            self.futureCity1.isHidden = true
            self.futureCity2.isHidden = true
            self.futureCity3.isHidden = true
            
            if (self.cities.count == 1) {
                self.futureCity1.setTitle(self.cities[0], for: .normal)
                self.futureCity1.isHidden = false
            }else if (self.cities.count == 2) {
                self.futureCity1.setTitle(self.cities[0], for: .normal)
                self.futureCity2.setTitle(self.cities[1], for: .normal)
                self.futureCity1.isHidden = false
                self.futureCity2.isHidden = false
            } else if (self.cities.count == 3) {
                self.futureCity1.setTitle(self.cities[0], for: .normal)
                self.futureCity2.setTitle(self.cities[1], for: .normal)
                self.futureCity3.setTitle(self.cities[2], for: .normal)
                self.futureCity1.isHidden = false
                self.futureCity2.isHidden = false
                self.futureCity3.isHidden = false
            }
        }
        
        //centerMapOnLocation(location: initialLocation)
        
        // button styling
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        addButton.layer.borderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1).cgColor
        
        addCityToList.layer.borderWidth = 1
        addCityToList.layer.cornerRadius = addButton.bounds.height / 1.5
        addCityToList.layer.borderColor = UIColor(red: 0.59, green: 0.64, blue: 0.99, alpha: 1).cgColor
    }
    
    // updates a user's location and shows it on the map!
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
    }
    
    // populate the cities array with cities currently in Firebase
    func getCities(completion: @escaping ([String]) -> Void) {
        let filterLocs = userRef.child(user!).child("settings").child("discovery").child("futureLoc")
        filterLocs.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let citiesDict = snapshot.value as? [String : AnyObject] else {
                return completion([])
            }
            
            var citiesArray: [String] = []
            for city in citiesDict {
                citiesArray.append(city.key)
            }
            completion(citiesArray)
        })
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
    
    @IBAction func addCityButtonPressed(_ sender: Any) {
        if (currentCity != "") {
            cities.append(currentCity)
        }
        
        if (futureCity1.isHidden == true && currentCity != "") {
            futureCity1.setTitle(currentCity, for: .normal)
            futureCity1.isHidden = false
        } else if (futureCity2.isHidden == true && currentCity != "") {
            futureCity2.setTitle(currentCity, for: .normal)
            futureCity2.isHidden = false
        } else if (futureCity3.isHidden == true && currentCity != "") {
            futureCity3.setTitle(currentCity, for: .normal)
            futureCity3.isHidden = false
        }
        
        currentCity = ""
        
        if (futureCity1.isHidden == false && futureCity2.isHidden == false && futureCity3.isHidden == false) {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
    // Click to Remove City
    @IBAction func city1Pressed(_ sender: Any) {
        var n = 0
        for currentCity in cities {
            if (currentCity == futureCity1.titleLabel?.text) {
                // if trying to remove last city, send alert
                if (cities.count == 1) {
                    let alert = UIAlertController(
                        title: "You must select at least one city to relocate to.",
                        message: "Please add another city if you wish to remove this one.",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    // hide the button
                    if (futureCity1.isHidden == false) {
                        futureCity1.isHidden = true
                    }
                    
                    // remove city from array
                    cities.remove(at: n)
                    n -= 1
                    
                    //remove from Firebase
                    let profileLocs = userRef.child(user!).child("profile").child("futureLoc")
                    profileLocs.child(currentCity).removeValue()
                    
                    let discoverySettingsRef = self.userRef.child(user!).child("settings").child("discovery").child("futureLoc")
                    discoverySettingsRef.child(currentCity).removeValue()
                    
                    citiesRef.child(currentCity).child(user!).removeValue()
                }
            }
            n += 1
        }
        
        if (futureCity1.isHidden == true || futureCity2.isHidden == true || futureCity3.isHidden == true) {
            addButton.isHidden = false
        }
    }
    
    @IBAction func city2Pressed(_ sender: Any) {
        var n = 0
        for currentCity in cities {
            if (currentCity == futureCity2.titleLabel?.text) {
                // if trying to remove last city, send alert
                if (cities.count == 1) {
                    let alert = UIAlertController(
                        title: "You must select at least one city to relocate to.",
                        message: "Please add another city if you wish to remove this one.",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    // hide the button
                    if (futureCity2.isHidden == false) {
                        futureCity2.isHidden = true
                    }
                    
                    // remove city from array
                    cities.remove(at: n)
                    n -= 1
                    
                    //remove from Firebase
                    let profileLocs = userRef.child(user!).child("profile").child("futureLoc")
                    profileLocs.child(currentCity).removeValue()
                    
                    let discoverySettingsRef = self.userRef.child(user!).child("settings").child("discovery").child("futureLoc")
                    discoverySettingsRef.child(currentCity).removeValue()
                    
                    citiesRef.child(currentCity).child(user!).removeValue()
                }
            }
            n += 1
        }
        
        if (futureCity1.isHidden == true || futureCity2.isHidden == true || futureCity3.isHidden == true) {
            addButton.isHidden = false
        }
    }
    
    @IBAction func city3Pressed(_ sender: Any) {
        var n = 0
        for currentCity in cities {
            if (currentCity == futureCity3.titleLabel?.text) {
                // if trying to remove last city, send alert
                if (cities.count == 1) {
                    let alert = UIAlertController(
                        title: "You must select at least one city to relocate to.",
                        message: "Please add another city if you wish to remove this one.",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    // hide the button
                    if (futureCity3.isHidden == false) {
                        futureCity3.isHidden = true
                    }
                    
                    // remove city from array
                    cities.remove(at: n)
                    n -= 1
                    
                    //remove from Firebase
                    let profileLocs = userRef.child(user!).child("profile").child("futureLoc")
                    profileLocs.child(currentCity).removeValue()
                    
                    let discoverySettingsRef = self.userRef.child(user!).child("settings").child("discovery").child("futureLoc")
                    discoverySettingsRef.child(currentCity).removeValue()
                    
                    citiesRef.child(currentCity).child(user!).removeValue()
                }
            }
            n += 1
        }
        
        if (futureCity1.isHidden == true || futureCity2.isHidden == true || futureCity3.isHidden == true) {
            addButton.isHidden = false
        }
    }
    
    // MARK: - Navigation
    @IBAction func saveButtonPressed(_ sender: Any) {
        let profileRef = self.userRef.child(user!).child("profile")
        let discoverySettingsRef = userRef.child(user!).child("settings").child("discovery")
        
        // add each city in array to Firebase
        for currentCity in cities {
            let values: [String : Any] = [
                currentCity: true
            ]
            
            // update locations
            citiesRef.updateChildValues(values)
            
            // update locations nested in user>profile>futureLoc
            profileRef.child("futureLoc").updateChildValues(values)
            
            // update locations nested in user>settings>discovery>futureLocs
            discoverySettingsRef.child("futureLoc").updateChildValues(values)
        }
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // code to dismiss keyboard when user clicks on background
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
