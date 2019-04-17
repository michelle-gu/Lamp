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
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
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
                self.ids.append(key)
            }
        })
        self.kolodaView.reloadData()
    }
    
    //should check if the other user has also "liked" this user
    @IBAction func yesButtonPressed(_ sender: Any) {
        let user = Auth.auth().currentUser?.uid
        let index = kolodaView.currentCardIndex
        
        let swipeValues = [
            "liked": true,
            "swiped": true
        ]
        ref.child("swipes").child(user!).child(ids[index]).updateChildValues(swipeValues)
        
        let swipe = ref.child("swipes").child(ids[index]).child(user!)
        let matchingSelf = ref.child(user!).child("matches")
        let matchingTarget = ref.child(ids[index]).child("matches")
        
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
 
//        let profile = ref.child("user-profiles").child(ids[index])

        let user = Auth.auth().currentUser?.uid
//        let id =
        
        if direction == .right{
            //record it as a right swipe
//            let swipeValues = [
//                ids[index]: true
//            ]
//            ref.child(user!).child("matches").updateChildValues(swipeValues)
            //updates the swiping values
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
//        let profile = images[index]
        let profile = ref.child("user-profiles").child(ids[index]).child("profile")
        profile.observe(.value, with: {(snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            let firstName = profileDict["firstName"] as! String
            let job = "Student"
            let location = "Austin"
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

