//
//  Profile.swift
//  Lamp
//
//  Created by Pearl Xie on 3/26/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import Foundation
import Firebase

struct Profile {
    
    // Firebase ref/key
    let ref: DatabaseReference?
    let key: String
    
    // Basic info
    let firstName: String
    let birthday: String
    let gender: String
    let uni: String
    let futureLoc: String
    let occupation: String
    
    // Lifestyle preferences
    
    // Contact info
    
    //let profilePicture: UIImage
    
    init(key: String = "", firstName: String, birthday: String, gender: String, uni: String, futureLoc: String, occupation: String) {
        self.ref = nil
        self.key = key
        self.firstName = firstName
        self.birthday = birthday
        self.gender = gender
        self.uni = uni
        self.futureLoc = futureLoc
        self.occupation = occupation
        //self.profilePicture = profilePicture
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let firstName = value["firstName"] as? String,
            let birthday = value["birthday"] as? String,
            let gender = value["gender"] as? String,
            let uni = value["uni"] as? String,
            let futureLoc = value["futureLoc"] as? String,
            let occupation = value["occupation"] as? String else {
            //let profilePicture = value["profilePicture"] as? UIImage
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.firstName = firstName
        self.birthday = birthday
        self.gender = gender
        self.uni = uni
        self.futureLoc = futureLoc
        self.occupation = occupation
        //self.profilePicture = profilePicture
    }
    
//    func getAgeStr() -> String {
//        let now = Date()
//        let calendar = Calendar.current
//
//        let myDateFormatter = DateFormatter()
//        myDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        myDateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        let date = myDateFormatter.date(from: self.birthday)!
//
//
//        let birthday =
//        let ageComponents = calendar.dateComponents([.year], from: self.birthday, to: now)
//
//        let age = ageComponents.year!
//
//        return age
//    }
    
    func toAnyObject() -> Any {
        return [
            "firstName": firstName,
            "birthday": birthday,
            "gender": gender,
            "uni": uni,
            "futureLoc": futureLoc,
            "occupation": occupation,
            //"profilePicture": profilePicture
        ]
    }
}
