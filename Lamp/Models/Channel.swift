//
//  Channel.swift
//  Lamp
//
//  Created by Lindsey Thompson on 4/23/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import Foundation
import Firebase

struct Channel {
    // MARK: Variables
    // Firebase ref/key
    let ref: DatabaseReference?
    let key: String
    
    // Basic info
    let timestamp: Int
    let time: String
    let lastMessage: String
    
    // MARK: Initializers
    
    // Initializer
    init(key: String = "", timestamp: Int, time: String, lastMessage: String) {
        // Initialize Firebase ref/key
        self.ref = nil
        self.key = key
        
        // Initialize Basic Info
        self.timestamp = timestamp
        self.time = time
        self.lastMessage = lastMessage
    }
    
    // Snapshot initializer
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let timestamp = value["timestamp"] as? Int,
            let time = value["time"] as? String,
            let lastMessage = value["lastMessage"] as? String else {
                return nil
        }
        
        // Firebase ref/key
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        // Basic Info
        self.timestamp = timestamp
        self.time = time
        self.lastMessage = lastMessage
    }
    
    // MARK: Functions
    // Returns json of profile data
    func toAnyObject() -> Any {
        return [
            "channel": [
                // Basic Info
                "timestamp": timestamp,
                "time": time,
                "lastMessage": lastMessage
            ]
        ]
    }
}
