//
//  Message.swift
//  Lamp
//
//  Created by Lindsey Thompson on 4/18/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

// MessageKit works with messages that conform to the MessageType protocol
struct Message: MessageType {
    
    let userId: String
    let text: String
    let messageId: String
    
    var sender: Sender {
        return Sender(id: userId, displayName: "")
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
