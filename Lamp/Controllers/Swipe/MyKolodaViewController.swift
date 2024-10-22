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

    let ref: DatabaseReference = Database.database().reference()
    let userRef = Database.database().reference(withPath: "user-profiles")
    let locationRef = Database.database().reference(withPath: "locations")

    // MARK: - Variables
    var ids: [String] = []
    var cities: [String] = []
    // set for match message to pass profile picture
    var matchId: String = String()

    // MARK: - Outlets
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!

    // MARK: - Functions
    // Get age from birthday string
    func getAge(birthday: String) -> Int {
        let now = Date()
        let calendar = Calendar.current
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM/dd/yyyy"
        let birthdayDate = myDateFormatter.date(from: birthday)!
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: birthdayDate, to: now)
        let age = ageComponents.year!
        return Int(age)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates/data sources
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        // Set logo to nav bar title
        let logo = UIImage(named: "LogoColor")
        let imageView = UIImageView(image: logo)
        imageView.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 30))
        titleView.addSubview(imageView)
        titleView.backgroundColor = .clear
        self.navigationItem.titleView = titleView

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
                    let myAgeMin = myDiscovery["ageMin"] as? CGFloat,
                    let myAgeMax = myDiscovery["ageMax"] as? CGFloat {

                    let allSwipesDict = dict["swipes"] as? [String: AnyObject] ?? [:]
                    let mySwipes = allSwipesDict[self.user!] as? [String: AnyObject] ?? [:]
                    
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

                    // get users I haven't swiped and users that are visible
                    var allUsers: [String] = []
                    for user in userProfilesDict {
                        allUsers.append(user.key)
                    }
                    var usersNotSwipedYet : Set<String> = Set<String>()
                    var invisibleUsers: Set<String> = Set<String>()
                    var usersInAgeRange: Set<String> = Set<String>()

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
                        
                        if let userProfile = userProfilesDict[user] as? [String: AnyObject],
                            let userSettings = userProfile["settings"] as? [String: AnyObject],
                            let userDiscovery = userSettings["discovery"] as? [String: AnyObject],
                            let userIsVisible: Bool = userDiscovery["showProfile"] as? Bool {
                            if !userIsVisible {
                                invisibleUsers.insert(user)
                            }
                        }

                        if let userProfile = userProfilesDict[user] as? [String: AnyObject],
                            let userProfileInfo = userProfile["profile"] as? [String: AnyObject],
                            let userBirthday = userProfileInfo["birthday"] as? String {
                            let userAge = self.getAge(birthday: userBirthday)
                            if userAge >= Int(myAgeMin) && userAge <= Int(myAgeMax) {
                                usersInAgeRange.insert(user)
                            }
                        }
                    }
                    
                    // intersect the sets
                    compatibleUsers = usersInMyLocs.intersection(usersWithPrefGender)
                    compatibleUsers = compatibleUsers.intersection(usersWithPrefUnis)
                    compatibleUsers = compatibleUsers.intersection(usersNotSwipedYet)
                    compatibleUsers = compatibleUsers.intersection(ids)
                    compatibleUsers = compatibleUsers.intersection(usersInAgeRange)
                    compatibleUsers.subtract(invisibleUsers)

                    // Set self.ids to the filtered array (a modified ids array)
                    self.ids = Array(compatibleUsers)

                    // Reload the swipe view with our new list
                    if self.ids.count == 0 {
                        self.noButton.isEnabled = false
                        self.yesButton.isEnabled = false
                        self.kolodaView.isHidden = true
                    } else {
                        self.noButton.isEnabled = true
                        self.yesButton.isEnabled = true
                        self.kolodaView.resetCurrentCardIndex()
                    }
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add app logo with constraints to nav bar
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        // add logo to navbar
        let image = UIImage(named: "LogoColor")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
  
    func cardStyling() {
        // yes & no button styles
        yesButton.layer.shadowColor = UIColor.darkGray.cgColor
        yesButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        yesButton.layer.shadowOpacity = 0.2
        yesButton.layer.shadowRadius = 2
        
        noButton.layer.shadowColor = UIColor.darkGray.cgColor
        noButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        noButton.layer.shadowOpacity = 0.2
        noButton.layer.shadowRadius = 2
        
        // add app logo with constraints to nav bar
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.contentMode = .scaleAspectFit
        // add logo to navbar
        let image = UIImage(named: "LogoColor")
        imageView.image = image
        
        self.navigationItem.titleView = imageView
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

    // populate the cities array with cities currently in Firebase
    func getCities(id: String, completion: @escaping ([String]) -> Void) {
        let profileLocs = userRef.child(id).child("profile").child("futureLoc")
        profileLocs.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let citiesDict = snapshot.value as? [String : AnyObject] else {
                return completion([])
            }

            var citiesArray: [String] = []
            for city in citiesDict {
                if ((city.value as? Bool)!) {
                    citiesArray.append(city.key)
                }
            }
            completion(citiesArray)
        })
    }
    
    // Get age from birthday string
    func getAgeStr(birthday: String) -> String {
        let now = Date()
        let calendar = Calendar.current
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM/dd/yyyy"
        let birthdayDate = myDateFormatter.date(from: birthday)!
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: birthdayDate, to: now)
        let age = ageComponents.year!
        return String(age)
    }

    // MARK: - Actions
    //should check if the other user has also "liked" this user
    @IBAction func yesButtonPressed(_ sender: Any) {
        kolodaView.swipe(.right)
    }

    @IBAction func noButtonPressed(_ sender: Any) {
        kolodaView.swipe(.left)
    }

    //  MARK: - Navigation
    // passes match id to match message VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "matchSegue" {
            let controller: MatchMessageViewController = segue.destination as! MatchMessageViewController
            controller.match = matchId
        }
    }

    // MARK: - Koloda View Data Source
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }

    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return ids.count
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let card:CardView =  CardView.create()

        // Set delegate
        card.delegate = self
        card.uid = ids[index]


        let profile = ref.child("user-profiles").child(ids[index]).child("profile")
        profile.observe(.value, with: {(snapshot) in

            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let firstName = profileDict["firstName"] as? String,
                let birthdayVal = profileDict["birthday"] as? String {
                card.nameLabel.text = "\(firstName), \(self.getAgeStr(birthday: birthdayVal))"
            }
            if let gender = profileDict["gender"] as? String {
                card.genderLabel.text = gender
            }
            if let job = profileDict["occupation"] as? String {
                card.jobLabel.text = job
            }
            if let university = profileDict["uni"] as? String {
                card.universityLabel.text = university
            }

            if let profilePicVal = profileDict["profilePicture"] as? String {
                if profilePicVal != "" {
                    let profilePicURL = URL(string: profilePicVal)
                    card.image.kf.setImage(with: profilePicURL)
                }
                else {
                    if let profilePicVal = profileDict["profilePicture"] as? String {
                        if profilePicVal != "" {
                            let profilePicURL = URL(string: profilePicVal)
                            card.image.kf.setImage(with: profilePicURL)
                        } else {
                            card.image.image = UIImage(named: "profile-pic-blank")
                        }
                    }
                }
            }
        })

        var locationText = ""
        getCities(id: ids[index]) { (citiesArray) in
            self.cities = citiesArray
            locationText = self.cities.joined(separator: ", ")
            card.locationLabel.text = locationText
        }
        
        return card
    }


    // MARK: - Koloda View Delegate
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.noButton.isEnabled = false
        self.yesButton.isEnabled = false
        kolodaView.isHidden = true
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        matchId = ids[index]

        switch direction {
        case .right:
            // Update for Swiped Right
            let swipeValues = [
                "liked": true,
                "swiped": true
            ]
            ref.child("swipes").child(user!).child(ids[index]).updateChildValues(swipeValues)

            // Check if there's a match
            let targetSwipe = ref.child("swipes").child(ids[index]).child(user!)
            targetSwipe.observe(.value, with: {(snapshot) in
                let swipingDict = snapshot.value as? [String : AnyObject] ?? [:]
                let liked = swipingDict["liked"] as? Bool ?? false

                if liked { // There's a match
                    // Update Firebase
                    self.ref.child("user-profiles").child(self.user!).child("matches").child(self.ids[index]).setValue(true)
                    self.ref.child("user-profiles").child(self.ids[index]).child("matches").child(self.user!).setValue(true)

                    // Create Channels in Firebase also
                    let profileRef = Database.database().reference(withPath: "user-profiles")
                    let newChannelId = UUID().uuidString
                    // Add channel to user-profiles
                    let userRef = profileRef.child(self.user!).child("channels")
                    let chan = [newChannelId : true]
                    userRef.updateChildValues(chan)
                    let matchRef = profileRef.child(self.matchId).child("channels")
                    let chan2 = [newChannelId : true]
                    matchRef.updateChildValues(chan2)
                    
                    // ADDING TO MESSAGING
                    let messagingRef = Database.database().reference(withPath: "messaging")
                    // Add channel to CHANNELS
                    let channelsRef = messagingRef.child("channels")
                    let channel = channelsRef.child(newChannelId).child("channel")
                    channel.setValue([
                        "last-message": "New Match!",
                        "time": "",
                        "timestamp": "0"
                        ])
                    
                    // Add users to MEMBERS
                    let membersRef = messagingRef.child("members")
                    let member = membersRef.child(newChannelId)
                    member.setValue([
                        self.user : true,
                        self.matchId : true
                        ])
                    
                    // Segue to matched screen
                    self.performSegue(withIdentifier: "matchSegue", sender:self)
                }
            })
        case .left:
            // Update for Swiped Left
            let swipeValues = [
                "liked": false,
                "swiped": true
            ]
            ref.child("swipes").child(user!).child(ids[index]).updateChildValues(swipeValues)
        default:
            break
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
