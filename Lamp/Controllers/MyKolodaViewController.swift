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
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "user-profiles")
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        getData()
    }
    
    func getData() {
        
        ref.queryOrderedByKey().observe(.value) { snapshot in
            
            self.images = snapshot.children.compactMap { child in
                guard let snap = child as? DataSnapshot else { return nil }
                return Profile(snapshot: snap)
            }
            
            self.kolodaView.reloadData()
        }
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
        //so this opens the profile
        
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
//        let user = Auth.auth().currentUser?.uid
//        let profile = ref.child(user!)
    }
}

extension MyKolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return images.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let card:CardView =  CardView.create()
        let profile = images[index]
        card.image.image = UIImage(named: "empty")
        card.nameLabel.text = profile.firstName
        return card
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil //Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView
    }
}
