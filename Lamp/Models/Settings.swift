//
//  Settings.swift
//  Lamp
//
//  Created by Michelle Gu on 4/4/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import Foundation
import Firebase

// Model for user settings
struct Settings {
    
    // MARK: Variables
    // Firebase ref/key
    let ref: DatabaseReference?
    let key: String
    
    // Account Settings
    let fb: Bool
    let google: Bool
    
    // Notification Settings
    let newMessages: Bool
    let newMatches: Bool
    
    // Discovery Settings
    let futureLocs: [String: Bool] // Array of location data
    let maxDistance: Int
    let universities: [String: Bool] // Array of universities allowed
    let genders: [String: Bool] // Array of genders allowed
    let ageMin: Int
    let ageMax: Int
    let showProfile: Bool
    
    // MARK: Initializers
    // Initializer with default settings
    init(key: String = "", fb: Bool = false, google: Bool = false, newMessages: Bool = true, newMatches: Bool = true, futureLocs: [String: Bool] = [:], maxDistance: Int = 0, universities: [String: Bool] = [:], genders: [String: Bool] = ["Female": true, "Male": true, "Other": true, "Prefer not to say": true], ageMin: Int = 0, ageMax: Int = Int.max, showProfile: Bool = true) {
        // Initialize Firebase ref/key
        self.ref = nil
        self.key = key
        
        // Initialize Account Settings
        self.fb = fb
        self.google = google
        
        // Initialize Notification Settings
        self.newMessages = newMessages
        self.newMatches = newMatches

        // Initialize Discovery Settings
        self.futureLocs = futureLocs
        self.maxDistance = maxDistance
        self.universities = universities
        self.genders = genders
        self.ageMin = ageMin
        self.ageMax = ageMax
        self.showProfile = showProfile
    }
    
    // Snapshot initializer
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let fb = value["fb"] as? Bool,
            let google = value["google"] as? Bool,
            let newMessages = value["newMessages"] as? Bool,
            let newMatches = value["newMatches"] as? Bool,
            let futureLocs = value["futureLocs"] as? [String: Bool],
            let maxDistance = value["maxDistance"] as? Int,
            let universities = value["universities"] as? [String: Bool],
            let genders = value["genders"] as? [String: Bool],
            let ageMin = value["ageMin"] as? Int,
            let ageMax = value["ageMax"] as? Int,
            let showProfile = value["showProfile"] as? Bool else {
                return nil
        }
        
        // Firebase ref/key
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        // Initialize Account Settings
        self.fb = fb
        self.google = google
        
        // Initialize Notification Settings
        self.newMessages = newMessages
        self.newMatches = newMatches
        
        // Initialize Discovery Settings
        self.futureLocs = futureLocs
        self.maxDistance = maxDistance
        self.universities = universities
        self.genders = genders
        self.ageMin = ageMin
        self.ageMax = ageMax
        self.showProfile = showProfile
    }
    
    // MARK: Functions
    // Returns json of settings data
    func toAnyObject() -> Any {
        return [
            "settings": [
                "accountSettings": [
                    "fb": fb,
                    "google": google
                ],
                "notifications": [
                    "newMessages": newMessages,
                    "newMatches": newMatches
                ],
                "discovery": [
                    "futureLocs": futureLocs,
                    "maxDistance": maxDistance,
                    "universities": universities,
                    "genders": genders,
                    "ageMin": ageMin,
                    "ageMax": ageMax,
                    "showProfile": showProfile
                ]
            ]
        ]
    }
}


