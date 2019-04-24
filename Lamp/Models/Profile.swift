//
//  Profile.swift
//  Lamp
//
//  Created by Pearl Xie on 3/26/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import Foundation
import Firebase

// Model for user profiles
struct Profile {
    
    // MARK: Variables
    // Firebase ref/key
    let ref: DatabaseReference?
    let key: String
    
    // Basic info
    let firstName: String
    let birthday: String
    let gender: String
    let uni: String
    let futureLoc: [String : Bool]
    let occupation: String
    let bio: String
    let budget: String
    let profilePicture: String
    
    // Lifestyle preferences
    let numBedrooms: String
    let pets: String
    let smoking: String
    let otherLifestylePrefs: String
    
    // Contact info
    let phone: String
    let email: String
    let facebook: String
    let otherContact: String
    
    // MARK: Initializers
    
    // Initializer
    init(key: String = "", firstName: String, birthday: String, gender: String, uni: String, futureLoc: [String : Bool] = [:], occupation: String) {
        // Initialize Firebase ref/key
        self.ref = nil
        self.key = key
        
        // Initialize Basic Info
        self.firstName = firstName
        self.birthday = birthday
        self.gender = gender
        self.uni = uni
        self.futureLoc = futureLoc
        self.occupation = occupation
        self.bio = ""
        self.budget = ""
        self.profilePicture = ""
        
        // Initialize Lifestyle Preferences
        self.numBedrooms = ""
        self.pets = ""
        self.smoking = ""
        self.otherLifestylePrefs = ""
        
        // Initialize Contact Info
        self.phone = ""
        self.email = ""
        self.facebook = ""
        self.otherContact = ""
    }
    
    // Snapshot initializer
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let firstName = value["firstName"] as? String,
            let birthday = value["birthday"] as? String,
            let gender = value["gender"] as? String,
            let uni = value["uni"] as? String,
            let futureLoc = value["futureLoc"] as? [String : Bool],
            let occupation = value["occupation"] as? String,
            let bio = value["bio"] as? String,
            let budget = value["budget"] as? String,
            let profilePicture = value["profilePicture"] as? String,
            let numBedrooms = value["numBedrooms"] as? String,
            let pets = value["pets"] as? String,
            let smoking = value["smoking"] as? String,
            let otherLifestylePrefs = value["otherLifestylePrefs"] as? String,
            let phone = value["phone"] as? String,
            let email = value["email"] as? String,
            let facebook = value["facebook"] as? String,
            let otherContact = value["otherContact"] as? String else {
            return nil
        }
        
        // Firebase ref/key
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        // Basic Info
        self.firstName = firstName
        self.birthday = birthday
        self.gender = gender
        self.uni = uni
        self.futureLoc = futureLoc
        self.occupation = occupation
        self.bio = bio
        self.budget = budget
        self.profilePicture = profilePicture
        
        // Lifestyle Preferences
        self.numBedrooms = numBedrooms
        self.pets = pets
        self.smoking = smoking
        self.otherLifestylePrefs = otherLifestylePrefs
        
        // Contact Info
        self.phone = phone
        self.email = email
        self.facebook = facebook
        self.otherContact = otherContact
    }
    
    // MARK: Functions
    // Returns json of profile data
    func toAnyObject() -> Any {
        return [
            "profile": [
                // Basic Info
                "firstName": firstName,
                "birthday": birthday,
                "gender": gender,
                "uni": uni,
                "futureLoc": futureLoc,
                "occupation": occupation,
                "bio": bio,
                "budget": budget,
                "profilePicture": profilePicture,
                // Lifestyle Prefs
                "numBedrooms": numBedrooms,
                "pets": pets,
                "smoking": smoking,
                "otherLifestylePrefs": otherLifestylePrefs,
                // Contact Info
                "phone": phone,
                "email": email,
                "facebook": facebook,
                "otherContact": otherContact
            ]
        ]
    }
}
