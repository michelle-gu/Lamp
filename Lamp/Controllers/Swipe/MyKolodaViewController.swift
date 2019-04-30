//
//  MyKolodaViewController.swift
//  Lamp
//
//  Created by Maria Ocanas on 4/5/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import UIKit
import Koloda
import Firebase

class MyKolodaViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate, UserProfileVCDelegate {
    
    // MARK: - Constants
    let user = Auth.auth().currentUser?.uid
    // set for match message to pass profile picture
    var matchId = ""
    
    let ref: DatabaseReference = Database.database().reference()
    let userRef = Database.database().reference(withPath: "user-profiles")
    let locationRef = Database.database().reference(withPath: "locations")

    // MARK: - Variables
    var ids: [String] = []
    
    // MARK: - Outlets
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates/data sources
        kolodaView.dataSource = self
        kolodaView.delegate = self
        // yes & no button styles
        yesButton.layer.shadowColor = UIColor.darkGray.cgColor
        yesButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        yesButton.layer.shadowOpacity = 0.2
        yesButton.layer.shadowRadius = 2
        
        noButton.layer.shadowColor = UIColor.darkGray.cgColor
        noButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        noButton.layer.shadowOpacity = 0.2
        noButton.layer.shadowRadius = 2
        
        // Get a list of all IDs in the database
        getIds() { (idsArray) in
            // idsArray is all the ids in user-profiles, make mutable
            var ids = idsArray
            var compatibleUsers : Set<String> = Set<String>()
            
            // Remove your own user id
            let indexOfSelf = idsArray.index(of: self.user!)
            ids.remove(at: indexOfSelf!)
            
            self.ref.observe(.value, with: { (snapshot) in
                let dict = snapshot.value as? [String : AnyObject] ?? [:]
                
                if let userProfilesDict = dict["user-profiles"] as? [String: AnyObject],
                    let myProfile = userProfilesDict[self.user!] as? [String: AnyObject],
                    let mySettings = myProfile["settings"] as? [String: AnyObject],
                    let myDiscovery = mySettings["discovery"] as? [String: AnyObject],
                    let allLocations = myDiscovery["futureLoc"] as? [String: Bool],
                    let allGenders = myDiscovery["genders"] as? [String: Bool],
                    let allUniversities = myDiscovery["universities"] as? [String: Bool],
                    let locationsDict = dict["locations"] as? [String: AnyObject],
                    let gendersDict = dict["genders"] as? [String: AnyObject],
                    let universitiesDict = dict["universities"] as? [String: AnyObject],
                    let allSwipesDict = dict["swipes"] as? [String: AnyObject],
                    let mySwipes = allSwipesDict[self.user!]! as? [String: AnyObject] {
                    
                    // get users for locations
                    var myLocations: [String] = []
                    for loc in allLocations {
                        if loc.value {
                            myLocations.append(loc.key)
                        }
                    }
                    var usersInMyLocs : Set<String> = Set<String>()
                    for loc in myLocations {
                        for user in (locationsDict[loc] as? [String: Bool]) ?? [:] {
                            if user.value { // if the user is here
                                usersInMyLocs.insert(user.key)
                            }
                        }
                    }
                    
                    // get users for genders
                    var myGenders: [String] = []
                    for gender in allGenders {
                        if gender.value {
                            myGenders.append(gender.key)
                        }
                    }
                    var usersWithPrefGender : Set<String> = Set<String>()
                    for gender in myGenders {
                        for user in (gendersDict[gender] as? [String: Bool]) ?? [:] {
                            if user.value { // if the user is here
                                usersWithPrefGender.insert(user.key)
                            }
                        }
                    }
                    
                    // get users for unis
                    var myUniversities: [String] = []
                    for uni in allUniversities {
                        if uni.value {
                            myUniversities.append(uni.key)
                        }
                    }
                    var usersWithPrefUnis : Set<String> = Set<String>()
                    for uni in myUniversities {
                        for user in (universitiesDict[uni] as? [String: Bool]) ?? [:] {
                            if user.value { // if the user is here
                                usersWithPrefUnis.insert(user.key)
                            }
                        }
                    }
                    
                    // get users I haven't swiped
                    var allUsers: [String] = []
                    for user in userProfilesDict {
                        allUsers.append(user.key)
                    }
                    var usersNotSwipedYet : Set<String> = Set<String>()
                    for user in allUsers {
                        let swipedUser = mySwipes[user] as? [String: Bool]
                        if swipedUser == nil {
                            usersNotSwipedYet.insert(user)
                        } else {
                            let swipedVal: Bool = swipedUser!["swiped"]!
                            if swipedVal == false {
                                usersNotSwipedYet.insert(user)
                            }
                        }
                    }

                    // intersect the sets
                    compatibleUsers = usersInMyLocs.intersection(usersWithPrefGender)
                    compatibleUsers = compatibleUsers.intersection(usersWithPrefUnis)
                    compatibleUsers = compatibleUsers.intersection(usersNotSwipedYet)
                    compatibleUsers = compatibleUsers.intersection(ids)
                    
                    // Set self.ids to the filtered array (a modified ids array)
                    self.ids = Array(compatibleUsers)
                    
                    // Reload the swipe view with our new list
                    self.kolodaView.reloadData()
                }
            })
        }
    }
    
    // MARK: - Data Retrieval
    // Retrieve a list of user IDs from Firebase
    func getIds(completion: @escaping ([String]) -> Void) {
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let profilesDict = snapshot.value as? [String : AnyObject] else {
                return completion([])
            }
            
            var idsArray: [String] = []
            for profile in profilesDict {
                idsArray.append(profile.key)
            }
            completion(idsArray)
        })
    }

    // MARK: - Actions
    //should check if the other user has also "liked" this user
    @IBAction func yesButtonPressed(_ sender: Any) {
        let index = kolodaView.currentCardIndex
        
        // sets global matchId variable to pass in prepare method
        matchId = ids[index]

//        let swipeValues = [
//            "liked": true,
//            "swiped": true
//        ]
//        //update user's swipe values
//        ref.child("swipes").child(user!).child(ids[index]).updateChildValues(swipeValues)

        //set up the dictionary of people the other user has swiped on
        let swipe = ref.child("swipes").child(matchId).child(user!)
        let matchingSelf = ref.child("user-profiles").child(user!).child("matches")
        let matchingTarget = ref.child("user-profiles").child(matchId).child("matches")

        swipe.observe(.value, with: {(snapshot) in
            let swipingDict = snapshot.value as? [String : AnyObject] ?? [:]
            let liked = swipingDict["liked"] as? Bool ?? false
            if liked{
                let match = [
                    self.ids[index-1]: true
                ]
                matchingSelf.updateChildValues(match)
                let match2 = [
                    self.user: true
                ]
                matchingTarget.updateChildValues(match2)
                self.kolodaView.swipe(.right)
                self.performSegue(withIdentifier: "matchSegue", sender:sender)
            }
            else{
                self.kolodaView.swipe(.right)
            }
        })
        
    }
    
    // passes match id to match message VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "matchSegue" {
            let controller: MatchMessageViewController = segue.destination as! MatchMessageViewController
            controller.match = matchId
        }
    }
    
  @IBAction func noButtonPressed(_ sender: Any) {
        let index = kolodaView.currentCardIndex
        //update the card value
        let swipeValues = [
            "liked": false,
            "swiped": true
        ]
        ref.child("swipes").child(user!).child(ids[index]).updateChildValues(swipeValues)
        //don't record for now, will probably change this
        kolodaView.swipe(.left)
        
    }
    
    // MARK: - Koloda View Data Source
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return ids.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let card:CardView =  CardView.create()
        
        // Set delegate
        card.delegate = self
        card.uid = ids[index]
        
        let profile = ref.child("user-profiles").child(ids[index]).child("profile")
        profile.observe(.value, with: {(snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let firstName = profileDict["firstName"] as? String {
                card.nameLabel.text = firstName
            }
            if let job = profileDict["occupation"] as? String {
                card.jobLabel.text = job
            }
            
            if let profilePicVal = profileDict["profilePicture"] as? String {
                if profilePicVal != "" {
                    let profilePicURL = URL(string: profilePicVal)
                    card.image.kf.setImage(with: profilePicURL)
                }
                else {
                    let profilePicURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/lamp-2c5a7.appspot.com/profilePictures/profile-pic-blank.jpg")
                    card.image.kf.setImage(with: profilePicURL)
//                    card.image =   //UIImageView(named: "empty")
                }
            }
            
            var location:String = ""
            let locationList = self.ref.child("user-profiles").child(self.ids[index]).child("profile").child("futureLoc")
            locationList.observe(.value, with: {(snapshot) in
                let locationDict = snapshot.value as? [String : AnyObject] ?? [:]
                var counter = 0
                for (key,value) in locationDict{
                    let v = value as? Bool ?? false
                    if v{
                        counter += 1
                        if counter == 1{
                            location = "\(key)"
                        }
                        else {
                            location = "\(location), \(key)"
                        }
                    }
                }
                card.locationLabel.text = location
            })
            //            TODO: //let location = "Austin"
            card.locationLabel.text = location
        })
        
        return card
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil //Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView
    }
    
    // MARK: - Koloda View Delegate
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //this should open the profile
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right{
            //            let user = Auth.auth().currentUser?.uid
            let index = kolodaView.currentCardIndex
            
            let swipeValues = [
                "liked": true,
                "swiped": true
            ]
            //update user's swipe values
            ref.child("swipes").child(user!).child(ids[index-1]).updateChildValues(swipeValues)
            
            //set up the dictionary of people the other user has swiped on
            let swipe = ref.child("swipes").child(ids[index-1]).child(user!)
            let matchingSelf = ref.child("user-profiles").child(user!).child("matches")
            let matchingTarget = ref.child("user-profiles").child(ids[index-1]).child("matches")
            
            swipe.observe(.value, with: {(snapshot) in
                let swipingDict = snapshot.value as? [String : AnyObject] ?? [:]
                let liked = swipingDict["liked"] as? Bool ?? false
                if liked{
                    let match = [
                        self.ids[index-1]: true
                    ]
                    matchingSelf.updateChildValues(match)
                    let match2 = [
                        self.user: true
                    ]
                    matchingTarget.updateChildValues(match2)
//                    print("would segue: \(self.ids[index-1])")
//                    self.performSegue(withIdentifier: "matchSegue", sender:self)
                }
                else{
//                    print("would not segue: \(self.ids[index-1])")
                }
                
            })
        }
        else{
            let swipeValues = [
                "liked": false,
                "swiped": true
            ]
            ref.child("swipes").child(user!).child(ids[index]).updateChildValues(swipeValues)
            //don't record for now, will probably change this
        }
    }
    
    // MARK: - User Profile VC Delegate
    func didPressInfoButton(uid: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let userProfileVC = storyBoard.instantiateViewController(withIdentifier: "userProfileVC") as! UserProfileTableViewController
        userProfileVC.user = uid
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }

}

// MARK: - Data Retrieval
//    func getData() {
//
//        ref.child("user-profiles").queryOrderedByKey().observe(.value) { snapshot in
//
//            self.images = snapshot.children.compactMap { child in
//                guard let snap = child as? DataSnapshot else { return nil }
//                return Profile(snapshot: snap)
//            }
//            for (key, value) in self.listGender{
//                if self.genders.contains(key){
//                    for(k, v) in self.listGender[key]!{
//                        if v && (k != Auth.auth().currentUser?.uid){
////                            self.ids.append(k)
//                            self.idsGenderSet.insert(k)
//                        }
//                    }
//                }
////
////            self.kolodaView.reloadData()
////        }
////
////    }
//            }
//            for (key, value) in self.listLocations{
//                if self.locations.contains(key){
//                    for(k, v) in self.listLocations[key]!{
//                        if v && (k != Auth.auth().currentUser?.uid){
//                            self.idsLocationSet.insert(k)
//                        }
//                    }
//                }
//            }
//            for (key, value) in self.listUniversities{
//                if self.universities.contains(key){
//                    for(k, v) in self.listUniversities[key]!{
//                        if v && (k != Auth.auth().currentUser?.uid){
//                            self.idsUniversitiesSet.insert(k)
//                        }
//                    }
//                }
//            }
//            self.idsSet = self.idsGenderSet.intersection(self.idsLocationSet)
//            self.idsSet = self.idsSet.intersection(self.idsUniversitiesSet)
//            self.ids = Array(self.idsSet)
//            print("these are the valid gender ids (in set form): \(self.idsGenderSet)")
//            print("these are the valid location ids (in set form): \(self.idsLocationSet)")
//            print("these are the valid university ids (in set form): \(self.idsUniversitiesSet)")
//            print("these are the valid ids (in set form): \(self.idsSet)")
//            print("these are the valid ids (in array form): \(self.ids)")


//    func getIds() {
//        ref.child("user-profiles").queryOrderedByKey().observe(.value, with: { (snapshot) in
////            self.ids = snapshot
//            self.idDict = snapshot.value as? [String : NSObject] ?? [:]
//            //returns a list of filtered objects
////            let filtered = self.filtering()
////            print("these are the filtered ids: \(self.filtered)")
////            for value in self.filtered{
////                self.ids.append(value)
////            }
//            for (key, value) in self.listGender{
//                if self.genders.contains(key){
//                    for(k, v) in self.listGender[key]!{
//                        if v && (k != Auth.auth().currentUser?.uid){
//                            self.ids.append(k)
//                        }
//                    }
//                }
//            }
//
////            for (key, _) in self.idDict {
////                if key != Auth.auth().currentUser?.uid{
//////                    var k:String = ""
////
////                    self.ids.append(key)
////                print("These are the ids: \(self.ids)")
////                }
////            }
//        })
//
//        self.kolodaView.reloadData()
//    }

// Gets dictionary of all gender information
//    func getUsers(){
//        let userGenders = ref.child("genders")
//        userGenders.observe(.value, with: {(snapshot) in
//            let genderDict = snapshot.value as? [String : AnyObject] ?? [:]
//            for (key, value) in genderDict{
//                //                print("this is a list: \(value)")
//                self.listGender[key] = value as! [String : Bool]
//                //                print("gendered list of people without knowing their values: \(self.listGender)")
//                //                for (k, v) in self.listGender[key]!{
//                //                    print("Key: \(k) Value: \(v)")
//                //                }
//            }
//        })
//    }
