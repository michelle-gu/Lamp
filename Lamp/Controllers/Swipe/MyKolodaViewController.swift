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

class MyKolodaViewController: UIViewController {
    
    var images: [Profile] = []
    var ref: DatabaseReference!
    var idDict: [String : NSObject] = [:]
    var ids: [String] = []
    var genders: [String] = []
    var locations: [String] = []
    var universities: [String] = []
    var listGender: [String : Dictionary<String,Bool>] = [:] as! [String : Dictionary]
    var listLocations: [String : Dictionary<String,Bool>] = [:] as! [String : Dictionary]
    var listUniversities: [String : Dictionary<String,Bool>] = [:] as! [String : Dictionary]
    var min:Int = 0
    var max:Int = 0
    var matches:Set<String> = Set<String>()
    var filtered:[String] = []
    var idsSet:Set<String> = Set<String>()
    var idsGenderSet:Set<String> = Set<String>()
    var idsLocationSet:Set<String> = Set<String>()
    var idsUniversitiesSet:Set<String> = Set<String>()
    
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.bringSubviewToFront(kolodaView)
        ref = Database.database().reference()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        setUserPref()
//        filtering()
        getUsers()
        getIds()
        getData()
        self.kolodaView.reloadData()
//        getIds()
        
    }
    
    func getData() {
        
        ref.child("user-profiles").queryOrderedByKey().observe(.value) { snapshot in
            
            self.images = snapshot.children.compactMap { child in
                guard let snap = child as? DataSnapshot else { return nil }
                return Profile(snapshot: snap)
            }
            
            self.kolodaView.reloadData()
        }
        
    }
    
    func getIds() {
        ref.child("user-profiles").queryOrderedByKey().observe(.value, with: { (snapshot) in
//            self.ids = snapshot
            self.idDict = snapshot.value as? [String : NSObject] ?? [:]
            //returns a list of filtered objects
//            let filtered = self.filtering()
//            print("these are the filtered ids: \(self.filtered)")
//            for value in self.filtered{
//                self.ids.append(value)
//            }
            for (key, value) in self.listGender{
                if self.genders.contains(key){
                    for(k, v) in self.listGender[key]!{
                        if v && (k != Auth.auth().currentUser?.uid){
//                            self.ids.append(k)
                            self.idsGenderSet.insert(k)
                        }
                    }
                }
            }
            for (key, value) in self.listLocations{
                if self.locations.contains(key){
                    for(k, v) in self.listLocations[key]!{
                        if v && (k != Auth.auth().currentUser?.uid){
                            self.idsLocationSet.insert(k)
                        }
                    }
                }
            }
            for (key, value) in self.listUniversities{
                if self.universities.contains(key){
                    for(k, v) in self.listUniversities[key]!{
                        if v && (k != Auth.auth().currentUser?.uid){
                            self.idsUniversitiesSet.insert(k)
                        }
                    }
                }
            }
            self.idsSet = self.idsGenderSet.intersection(self.idsLocationSet)
            self.idsSet = self.idsSet.intersection(self.idsUniversitiesSet)
            self.ids = Array(self.idsSet)
//            print("these are the valid gender ids (in set form): \(self.idsGenderSet)")
//            print("these are the valid location ids (in set form): \(self.idsLocationSet)")
//            print("these are the valid university ids (in set form): \(self.idsUniversitiesSet)")
//            print("these are the valid ids (in set form): \(self.idsSet)")
//            print("these are the valid ids (in array form): \(self.ids)")
            
//            for (key, _) in self.idDict {
//                
//                
//                if key != Auth.auth().currentUser?.uid{
////                    var k:String = ""
//                   
//                    self.ids.append(key)
//                print("These are the ids: \(self.ids)")
//                }
//            }
        })
        
        self.kolodaView.reloadData()
    }
    
    func setUserPref(){
        let user = Auth.auth().currentUser?.uid
        let preferences = ref.child("user-profiles").child(user!).child("settings").child("discovery")
        preferences.observe(.value, with: {(snapshot) in
            let prefDict = snapshot.value as? [String : AnyObject] ?? [:]
            //let min and max age preferences to filter by
            let ageMin = prefDict["ageMin"]
            let ageMax = prefDict["ageMax"]
            //get a list of the preferred future locations
            let futureLoc = self.ref.child("user-profiles").child(user!).child("settings").child("discovery").child("futureLoc")
            futureLoc.observe(.value, with: {(snapshot) in
                let locDict = snapshot.value as? [String : AnyObject] ?? [:]
                for (key,_) in locDict{
                    self.locations.append(key)
                }
            })
            //make a list of preferred genders
            let gen = self.ref.child("user-profiles").child(user!).child("settings").child("discovery").child("genders")
            gen.observe(.value, with: {(snapshot) in
                let genDict = snapshot.value as? [String: AnyObject] ?? [:]
                for (key, value) in genDict{
                    let x = value as? Bool ?? false
                    if x{
                        self.genders.append(key)
                    }
                }
            })
            //make a list of universities
            let uni = self.ref.child("user-profiles").child(user!).child("settings").child("discovery").child("universities")
            uni.observe(.value, with: {(snapshot) in
                let uniDict = snapshot.value as? [String:AnyObject] ?? [:]
                for (key, _) in uniDict{
                    self.universities.append(key)
                }
            })
            
            
            self.min = ageMin as! Int
            self.max = ageMax as! Int
            //            loc = futureloc
            
        })
        self.kolodaView.reloadData()
        
    }
    
    func getUsers(){
        let user = Auth.auth().currentUser?.uid
        let userGenders = ref.child("genders")
        userGenders.observe(.value, with: {(snapshot) in
            let genderDict = snapshot.value as? [String : AnyObject] ?? [:]
            for (key, value) in genderDict{
//                print("this is a list: \(value)")
                self.listGender[key] = value as! [String : Bool]
//                print("gendered list of people without knowing their values: \(self.listGender)")
//                for (k, v) in self.listGender[key]!{
//                    print("Key: \(k) Value: \(v)")
//                }
            }
        })
        let userLocations = ref.child("locations")
        userLocations.observe(.value, with: {(snapshot) in
            let locationsDict = snapshot.value as? [String : AnyObject] ?? [:]
            for (key, value) in locationsDict{
                self.listLocations[key] = value as! [String : Bool]
            }
        })
        let userUniversities = ref.child("universities")
        userUniversities.observe(.value, with: {(snapshot) in
            let universitiesDict = snapshot.value as? [String : AnyObject] ?? [:]
            for (key, value) in universitiesDict{
                self.listUniversities[key] = value as! [String : Bool]
            }
        })
        
        
    }
    
    
    
    //should check if the other user has also "liked" this user
    @IBAction func yesButtonPressed(_ sender: Any) {
        let user = Auth.auth().currentUser?.uid
        let index = kolodaView.currentCardIndex

//        let swipeValues = [
//            "liked": true,
//            "swiped": true
//        ]
//        //update user's swipe values
//        ref.child("swipes").child(user!).child(ids[index]).updateChildValues(swipeValues)

        //set up the dictionary of people the other user has swiped on
        let swipe = ref.child("swipes").child(ids[index]).child(user!)
        let matchingSelf = ref.child("user-profiles").child(user!).child("matches")
        let matchingTarget = ref.child("user-profiles").child(ids[index]).child("matches")

        swipe.observe(.value, with: {(snapshot) in
            let swipingDict = snapshot.value as? [String : AnyObject] ?? [:]
            let liked = swipingDict["liked"] as? Bool ?? false
            if liked{
                let match = [
                    self.ids[index]: true
                ]
                matchingSelf.updateChildValues(match)
                let match2 = [
                    user: true
                ]
                matchingTarget.updateChildValues(match2)
                self.kolodaView.swipe(.right)
                self.performSegue(withIdentifier: "matchSegue", sender:sender)

            }
            else{
                self.kolodaView.swipe(.right)
            }

        })
        
//        self.performSegue(withIdentifier: "matchSegue", sender:sender)
    }
    @IBAction func noButtonPressed(_ sender: Any) {
        let user = Auth.auth().currentUser?.uid
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyKolodaViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //this should open the profile
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {

        let user = Auth.auth().currentUser?.uid
        
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
                        user: true
                    ]
                    matchingTarget.updateChildValues(match2)
                    print("would segue: \(self.ids[index-1])")
                    self.performSegue(withIdentifier: "matchSegue", sender:self)
                    
                }
                else{
                    print("would not segue: \(self.ids[index-1])")
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
}

extension MyKolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return ids.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let card:CardView =  CardView.create()

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
            }

            var location:String = ""
            let locationList = self.ref.child("user-profiles").child(self.ids[index]).child("profile").child("futureLoc")
            locationList.observe(.value, with: {(snapshot) in
                let locationDict = snapshot.value as? [String : AnyObject] ?? [:]
                var counter = 0
                for (key,_) in locationDict{
                    counter += 1
                    if counter == 1{
                        location = "\(key)"
                    }
                    else {
                        location = "\(location), \(key)"
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
}

