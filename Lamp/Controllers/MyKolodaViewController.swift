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
    var min:Int = 0
    var max:Int = 0
    var matches:Set<String> = Set<String>()
    
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        setUserPref()
        getIds()
        getData()
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
            
            for (key, _) in self.idDict {
                if key != Auth.auth().currentUser?.uid{
                    
                    self.ids.append(key)
                }
            }
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
        
    }
    
    func filtering() {
        //check each of the lists and labels to make sets
//        let user = Auth.auth().currentUser?.uid
        let genderMatches = self.ref.child("genders")// this is reaching into the genders dict
        genderMatches.observe(.value, with: {(snapshot) in
            //this is a dictionary of gender w/ list of users w/ booleans
            let gendersDict = snapshot.value as? [String : AnyObject ] ?? [:]
            
        })
        
        
    }
    
    
    //should check if the other user has also "liked" this user
    @IBAction func yesButtonPressed(_ sender: Any) {
        let user = Auth.auth().currentUser?.uid
        let index = kolodaView.currentCardIndex
        
        let swipeValues = [
            "liked": true,
            "swiped": true
        ]
        //update user's swipe values
        ref.child("swipes").child(user!).child(ids[index]).updateChildValues(swipeValues)
        
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
                self.performSegue(withIdentifier: "matchSegue", sender:sender)
                
            }
        
        })
        kolodaView.swipe(.right)
    
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
            let swipeValues = [
                "liked": true,
                "swiped": true
            ]
            ref.child("swipes").child(user!).child(ids[index]).updateChildValues(swipeValues)
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
        print(ids[index])
        profile.observe(.value, with: {(snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            let firstName = profileDict["firstName"] as! String
            let job:String = profileDict["occupation"] as! String
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
//            //let location = "Austin"
            card.image.image = UIImage(named: "empty")
            card.nameLabel.text = firstName
            card.jobLabel.text = job
            card.locationLabel.text = location
            
        })
        return card
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil //Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView
    }
}

